# Scaffold: Wails + Gleam/Lustre + PocketBase Desktop App

This directory is a project template for building desktop applications with
[Wails](https://wails.io/) (Go backend), [PocketBase](https://pocketbase.io/)
(embedded database + auth), [Huma](https://huma.rocks/) (API framework),
and [Gleam](https://gleam.run/) + [Lustre](https://hexdocs.pm/lustre/) (frontend).

## Instantiating the template

Replace all `{{...}}` placeholders in **file contents and file/directory paths**:

| Variable | Example | Description |
|----------|---------|-------------|
| `{{project_name}}` | `phb` | Directory name, binary name, Go module, Gleam package |
| `{{app_title}}` | `PHB — Requirements Manager` | Window title and display name |
| `{{bundle_id}}` | `com.xperi.phb` | macOS bundle identifier |
| `{{author_name}}` | `Marcin Bilski` | Developer name (used in signing identity) |
| `{{author_email}}` | `gyamtso@gmail.com` | Apple ID (used for notarization) |
| `{{apple_team_id}}` | `MG36V283JX` | Apple Developer Team ID |
| `{{dev_superuser_email}}` | `admin@example.com` | Dev mode PocketBase superuser email |
| `{{dev_superuser_password}}` | `changeme123!` | Dev mode PocketBase superuser password |
| `{{dev_user_email}}` | `user@example.com` | Dev mode regular user email |
| `{{dev_user_password}}` | `changeme456!` | Dev mode regular user password |

After replacing placeholders:

```bash
cd frontend && gleam deps download
cd ../desktop && go mod tidy
```

Tell the user to replace the dev seed credentials in
`desktop/pkg/store/migrations.go` with their own values, or remove the
`SeedDevUsers` call if they don't want seeded accounts.

## Architecture

- `desktop/main.go` — Entry point. Starts PocketBase (embedded, on
  `127.0.0.1:8090`) in a goroutine, then launches the Wails window.
- `desktop/pkg/store/migrations.go` — Programmatic collection creation and
  dev-mode seeding. Collections are ensured on every startup (idempotent).
- `desktop/pkg/api/server.go` — Huma API setup with bearer auth middleware.
  Mounted on PocketBase's router under `/v1/`. OpenAPI docs at `/docs` when
  `--docs` flag is set.
- `desktop/pkg/api/auth.go` — Bridges PocketBase auth into Huma context.
- `desktop/pkg/api/example.go` — Example endpoints: `GET /v1/hello` (public)
  and `GET /v1/me` (authenticated).
- `frontend/src/{{project_name}}.gleam` — Gleam entry point using Lustre (TEA
  architecture). Renders into `#app`.
- `frontend/index.html` — HTML shell that loads the compiled Gleam module.

### Auth flow

1. Frontend authenticates via PocketBase SDK (`POST /api/collections/users/auth-with-password`)
2. PocketBase returns a JWT token
3. Frontend includes `Authorization: Bearer <token>` on API calls
4. PocketBase validates the token and populates `e.Auth`
5. `api.Mount` bridges `e.Auth` into Huma context via `ContextWithAuth`
6. Huma middleware enforces auth on operations with `Security: bearer`
7. Handlers access the user via `AuthFromContext(ctx)`

### PocketBase data

PocketBase stores data in `./data/pb_data` (SQLite). The admin UI is
available at `http://127.0.0.1:8090/_/` when running. In dev mode (`--dev`
flag), seed accounts are created automatically.

## Development workflow

- `make dev` — starts the Lustre dev server with hot reload (frontend only).
  PocketBase must be started separately or via `make build-desktop`.
- `make build` — full build: compiles frontend, builds macOS `.app`, signs,
  notarizes, and zips.
- `make build-windows` — cross-compiles for Windows.
- `make clean` — removes all build artifacts.

## Adding features

### Backend (Go + PocketBase + Huma)

1. Add collections in `desktop/pkg/store/migrations.go` following the
   `ensureItems` pattern: find-or-create collection, add fields, set API rules.
2. Add API endpoints in `desktop/pkg/api/` — register them in `server.go`'s
   `Handler()`. Use `Security: bearer` for authenticated endpoints.
3. Access the current user via `AuthFromContext(ctx)` in handlers.
4. For direct PocketBase data access, use `pb.FindRecordsByFilter()`,
   `pb.Save()`, etc.

### Frontend (Gleam + Lustre)

1. Define your model in a `frontend/src/{{project_name}}/model.gleam` module.
2. Define messages in `msg.gleam`, update logic in `update.gleam`, and UI in
   `view.gleam` — following the TEA (The Elm Architecture) pattern.
3. For Go backend functionality, add exported methods to a struct in
   `desktop/main.go` and bind it via `wails.Run` options. Wails generates
   TypeScript bindings automatically; call them from Gleam via JavaScript FFI.
4. For JavaScript interop (e.g. browser APIs), create `_ffi.mjs` files in
   `frontend/src/` and import them with `@external` in Gleam.
5. For PocketBase interaction, use the PocketBase JS SDK or call the REST API
   directly from Gleam via `lustre_http`.

## Secrets and code signing

**IMPORTANT: Never read, display, or ask the user for the contents of
`secrets/gon-sign.json`. It contains credential references. Never ask
the user for their Apple Developer password.**

### How `secrets/` works

The `secrets/` directory contains template files with credential placeholders.
These files are checked into version control (they use `@env:` references, not
actual passwords). The Makefile copies them to their target locations at build
time:

| Template | Target | Trigger |
|----------|--------|---------|
| `secrets/gon-sign.json` | `desktop/build/darwin/gon-sign.json` | `make sign` |

The target locations (`desktop/build/`) are gitignored so credentials never
leak into the repository. See `secrets/README.md` for setup instructions.

### User setup

Tell the user to:

1. Set the `AC_PASSWORD` environment variable to their Apple app-specific
   password (generate at https://appleid.apple.com/ under Sign-In and
   Security > App-Specific Passwords).
2. Edit `secrets/gon-sign.json` to verify the `bundle_id` and signing
   identity are correct.

For signing details, refer them to the
[Wails signing guide](https://wails.io/docs/guides/signing/).

## Conventions

- Frontend state is managed exclusively through Lustre's TEA cycle — no
  mutable global state.
- Go backend should be thin — prefer doing logic in Gleam where possible.
- JavaScript FFI modules are named `*_ffi.mjs` and kept in `frontend/src/`.
- Collections are created programmatically in Go, not via PocketBase migration
  files. This keeps the schema in code and makes it versionable.
- Dev seed credentials use `{{...}}` placeholders — they are not real secrets
  but should still be changed after instantiation.
