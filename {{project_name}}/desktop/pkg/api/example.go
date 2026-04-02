package api

import (
	"context"
	"net/http"
	"time"

	"github.com/danielgtaylor/huma/v2"
)

// --- Example: GET /v1/hello (public) and GET /v1/me (authenticated) ---

// HelloOutput is the response for the public hello endpoint.
type HelloOutput struct {
	Body struct {
		Message string `json:"message" doc:"Greeting message"`
		Time    string `json:"time" doc:"Server time in RFC3339 format"`
	}
}

// MeOutput is the response for the authenticated me endpoint.
type MeOutput struct {
	Body struct {
		ID    string `json:"id" doc:"User record ID"`
		Email string `json:"email" doc:"User email address"`
	}
}

func registerExampleRoutes(api huma.API, s *Server) {
	// Public endpoint — no auth required.
	huma.Register(api, huma.Operation{
		OperationID: "hello",
		Method:      http.MethodGet,
		Path:        "/v1/hello",
		Summary:     "Hello world",
		Tags:        []string{"Example"},
	}, func(_ context.Context, _ *struct{}) (*HelloOutput, error) {
		resp := &HelloOutput{}
		resp.Body.Message = "Hello from {{app_title}}!"
		resp.Body.Time = time.Now().UTC().Format(time.RFC3339)
		return resp, nil
	})

	// Authenticated endpoint — requires bearer token.
	huma.Register(api, huma.Operation{
		OperationID: "me",
		Method:      http.MethodGet,
		Path:        "/v1/me",
		Summary:     "Get current user",
		Tags:        []string{"Example"},
		Security:    []map[string][]string{{"bearer": {}}},
	}, func(ctx context.Context, _ *struct{}) (*MeOutput, error) {
		auth := AuthFromContext(ctx)
		if auth == nil {
			return nil, huma.Error401Unauthorized("not authenticated")
		}
		resp := &MeOutput{}
		resp.Body.ID = auth.Id
		resp.Body.Email = auth.Email()
		return resp, nil
	})
}
