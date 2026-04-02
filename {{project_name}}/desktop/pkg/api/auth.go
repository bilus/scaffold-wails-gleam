package api

import (
	"context"

	"github.com/pocketbase/pocketbase/core"
)

type contextKey string

const authRecordKey contextKey = "pbAuthRecord"

// ContextWithAuth returns a new context carrying the PocketBase auth record.
func ContextWithAuth(ctx context.Context, record *core.Record) context.Context {
	return context.WithValue(ctx, authRecordKey, record)
}

// AuthFromContext extracts the PocketBase auth record from the context.
// Returns nil if no auth record is present.
func AuthFromContext(ctx context.Context) *core.Record {
	rec, _ := ctx.Value(authRecordKey).(*core.Record)
	return rec
}
