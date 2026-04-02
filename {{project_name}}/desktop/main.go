package main

import (
	"embed"
	"fmt"
	"log"

	"{{project_name}}/pkg/api"
	"{{project_name}}/pkg/store"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
)

//go:embed all:frontend/dist
var assets embed.FS

func main() {
	// Start PocketBase in a goroutine.
	pb := pocketbase.NewWithConfig(pocketbase.Config{
		DefaultDataDir: "./data/pb_data",
	})

	var docsEnabled bool
	pb.RootCmd.PersistentFlags().BoolVar(&docsEnabled, "docs", false, "Enable API documentation endpoints (/docs)")

	pb.OnServe().BindFunc(func(se *core.ServeEvent) error {
		if err := store.EnsureCollections(se.App); err != nil {
			return fmt.Errorf("ensure collections: %w", err)
		}

		if se.App.IsDev() {
			if err := store.SeedDevUsers(se.App); err != nil {
				return fmt.Errorf("seed dev users: %w", err)
			}
		}

		// Mount Huma API on /v1/ with optional docs.
		api.Mount(se, se.App, docsEnabled)

		return se.Next()
	})

	go func() {
		pb.RootCmd.SetArgs([]string{"serve", "--http", "127.0.0.1:8090"})
		if err := pb.Start(); err != nil {
			log.Fatal(err)
		}
	}()

	// Start Wails (blocks until window closes).
	err := wails.Run(&options.App{
		Title:  "{{app_title}}",
		Width:  1280,
		Height: 800,
		AssetServer: &assetserver.Options{
			Assets: assets,
		},
	})
	if err != nil {
		println("Error:", err.Error())
	}
}
