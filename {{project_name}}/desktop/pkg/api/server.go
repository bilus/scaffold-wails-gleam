package api

import (
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humago"
	"github.com/pocketbase/pocketbase/core"
)

// Server provides custom Huma API endpoints alongside PocketBase.
type Server struct {
	pb core.App
}

// New returns a Server backed by the given PocketBase app.
func New(pb core.App) *Server {
	return &Server{pb: pb}
}

// Handler returns an http.Handler serving the custom API with OpenAPI docs.
func (s *Server) Handler() http.Handler {
	mux := http.NewServeMux()
	config := huma.DefaultConfig("{{app_title}}", "0.1.0")
	config.Components.SecuritySchemes = map[string]*huma.SecurityScheme{
		"bearer": {
			Type:   "http",
			Scheme: "bearer",
		},
	}
	api := humago.New(mux, config)

	// Auth middleware: reject unauthenticated requests for secured operations.
	api.UseMiddleware(func(ctx huma.Context, next func(huma.Context)) {
		requiresAuth := false
		for _, sec := range ctx.Operation().Security {
			if _, ok := sec["bearer"]; ok {
				requiresAuth = true
				break
			}
		}
		if requiresAuth && AuthFromContext(ctx.Context()) == nil {
			huma.WriteErr(api, ctx, 401, "authentication required")
			return
		}
		next(ctx)
	})

	// Register example endpoint.
	registerExampleRoutes(api, s)

	return mux
}

// Mount registers the API handler on the PocketBase router.
// It bridges PocketBase's auth into Huma's context and mounts routes
// under /v1/ with optional OpenAPI docs.
func Mount(se *core.ServeEvent, pb core.App, docs bool) {
	srv := New(pb)
	h := srv.Handler()

	wrap := func(e *core.RequestEvent) error {
		r := e.Request
		if e.Auth != nil {
			ctx := ContextWithAuth(r.Context(), e.Auth)
			r = r.WithContext(ctx)
		}
		h.ServeHTTP(e.Response, r)
		return nil
	}

	se.Router.Any("/v1/{path...}", wrap)

	if docs {
		se.Router.GET("/openapi.json", wrap)
		se.Router.GET("/docs", wrap)
	}
}
