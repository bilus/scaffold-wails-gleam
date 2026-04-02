package store

import (
	"fmt"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// EnsureCollections creates or updates the application's PocketBase collections.
// Add new collections here as the schema evolves.
func EnsureCollections(pb core.App) error {
	if err := ensureUsers(pb); err != nil {
		return fmt.Errorf("ensure users: %w", err)
	}
	if err := ensureItems(pb); err != nil {
		return fmt.Errorf("ensure items: %w", err)
	}
	return nil
}

// SeedDevUsers creates default superuser and user accounts for development.
// Only call this when the app is running in dev mode (--dev flag).
func SeedDevUsers(pb core.App) error {
	if err := ensureSuperuser(pb, "{{dev_superuser_email}}", "{{dev_superuser_password}}"); err != nil {
		return err
	}
	if err := ensureUser(pb, "{{dev_user_email}}", "{{dev_user_password}}"); err != nil {
		return err
	}
	return nil
}

// --- Collections ---

// ensureUsers creates or updates the "users" auth collection.
func ensureUsers(pb core.App) error {
	col, _ := pb.FindCollectionByNameOrId("users")
	if col == nil {
		col = core.NewAuthCollection("users")
	}
	addAutoDateFields(col)
	if err := pb.Save(col); err != nil {
		return fmt.Errorf("save users: %w", err)
	}
	return nil
}

// ensureItems is an example collection — replace with your own.
func ensureItems(pb core.App) error {
	users, err := pb.FindCollectionByNameOrId("users")
	if err != nil {
		return fmt.Errorf("find users collection: %w", err)
	}

	col, _ := pb.FindCollectionByNameOrId("items")
	if col == nil {
		col = core.NewBaseCollection("items")
	}

	col.Fields.Add(
		&core.TextField{Name: "title", Required: true},
		&core.TextField{Name: "description"},
		&core.RelationField{
			Name:         "owner",
			CollectionId: users.Id,
			Required:     true,
			MaxSelect:    1,
		},
	)
	addAutoDateFields(col)

	// API rules: only the owning user can access their items.
	col.ListRule = types.Pointer("owner = @request.auth.id")
	col.ViewRule = types.Pointer("owner = @request.auth.id")
	col.CreateRule = types.Pointer("@request.auth.id != ''")
	col.UpdateRule = types.Pointer("owner = @request.auth.id")
	col.DeleteRule = types.Pointer("owner = @request.auth.id")

	if err := pb.Save(col); err != nil {
		return fmt.Errorf("save items: %w", err)
	}
	return nil
}

// --- Helpers ---

func ensureSuperuser(pb core.App, email, password string) error {
	if _, err := pb.FindAuthRecordByEmail("_superusers", email); err == nil {
		return nil
	}
	col, err := pb.FindCollectionByNameOrId("_superusers")
	if err != nil {
		return fmt.Errorf("find superusers collection: %w", err)
	}
	rec := core.NewRecord(col)
	rec.SetEmail(email)
	rec.SetPassword(password)
	if err := pb.Save(rec); err != nil {
		return fmt.Errorf("save superuser: %w", err)
	}
	return nil
}

func ensureUser(pb core.App, email, password string) error {
	if _, err := pb.FindAuthRecordByEmail("users", email); err == nil {
		return nil
	}
	col, err := pb.FindCollectionByNameOrId("users")
	if err != nil {
		return fmt.Errorf("find users collection: %w", err)
	}
	rec := core.NewRecord(col)
	rec.SetEmail(email)
	rec.SetPassword(password)
	if err := pb.Save(rec); err != nil {
		return fmt.Errorf("save user: %w", err)
	}
	return nil
}

func addAutoDateFields(col *core.Collection) {
	col.Fields.Add(
		&core.AutodateField{Name: "created", OnCreate: true},
		&core.AutodateField{Name: "updated", OnCreate: true, OnUpdate: true},
	)
}
