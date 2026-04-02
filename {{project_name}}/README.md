# {{app_title}}

Desktop application built with [Wails](https://wails.io/) (Go) and [Gleam](https://gleam.run/) + [Lustre](https://hexdocs.pm/lustre/).

## Prerequisites

- Go 1.23+
- [Wails CLI](https://wails.io/docs/gettingstarted/installation) (`go install github.com/wailsapp/wails/v2/cmd/wails@latest`)
- [Gleam](https://gleam.run/getting-started/installing/)
- For code signing: [gon](https://github.com/Bearer/gon) (`brew install Bearer/tap/gon`)

## Development

```bash
make dev
```

Starts the Gleam/Lustre dev server with hot reload.

## Build

```bash
make build
```

Builds the frontend, creates the macOS `.app` bundle, signs and notarizes it, and produces a `.zip` for distribution.

For Windows cross-compilation:

```bash
make build-windows
```

## Code signing

macOS code signing and notarization uses `gon`. Set the `AC_PASSWORD` environment variable to your app-specific password (generate at [appleid.apple.com](https://appleid.apple.com/)).

Signing configuration is in `desktop/signing/`. For setup details see the [Wails signing guide](https://wails.io/docs/guides/signing/).

## Template variables

This project was generated from a scaffold. The following placeholders were replaced:

| Variable | Value |
|----------|-------|
| `{{project_name}}` | *project directory and binary name* |
| `{{app_title}}` | *window title and display name* |
| `{{bundle_id}}` | *macOS bundle identifier* |
| `{{author_name}}` | *developer name for signing* |
| `{{author_email}}` | *Apple ID for notarization* |
| `{{apple_team_id}}` | *Apple Developer Team ID* |
