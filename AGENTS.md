# Scaffold: Wails + Gleam/Lustre Desktop App

This directory is a project template for building desktop applications with
[Wails](https://wails.io/) (Go backend) and [Gleam](https://gleam.run/) +
[Lustre](https://hexdocs.pm/lustre/) (frontend).

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

After replacing placeholders:

```bash
cd frontend && gleam deps download
cd ../desktop && go mod tidy
```

## Architecture

- `desktop/main.go` — Go entry point. Embeds the compiled frontend and serves
  it in a native window via Wails.
- `frontend/src/{{project_name}}.gleam` — Gleam entry point using Lustre (TEA
  architecture). Renders into `#app`.
- `frontend/index.html` — HTML shell that loads the compiled Gleam module.
- `desktop/wails.json` — Wails configuration. The `frontend:build` hook
  compiles Gleam and copies output to `desktop/frontend/dist/`.

## Development workflow

- `make dev` — starts the Lustre dev server with hot reload (frontend only).
- `make build` — full build: compiles frontend, builds macOS `.app`, signs,
  notarizes, and zips.
- `make build-windows` — cross-compiles for Windows.
- `make clean` — removes all build artifacts.

## Adding features

1. Define your model in a `frontend/src/{{project_name}}/model.gleam` module.
2. Define messages in `msg.gleam`, update logic in `update.gleam`, and UI in
   `view.gleam` — following the TEA (The Elm Architecture) pattern.
3. For Go backend functionality, add exported methods to a struct in
   `desktop/main.go` and bind it via `wails.Run` options. Wails generates
   TypeScript bindings automatically; call them from Gleam via JavaScript FFI.
4. For JavaScript interop (e.g. browser APIs), create `_ffi.mjs` files in
   `frontend/src/` and import them with `@external` in Gleam.

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
