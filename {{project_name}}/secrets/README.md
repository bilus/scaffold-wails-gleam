# Secrets

This directory contains **template files** with sensitive credential placeholders.
They are not used directly — the build process copies them to their target
locations where they are gitignored.

## Files

| Template | Copied to | When |
|----------|-----------|------|
| `gon-sign.json` | `desktop/build/darwin/gon-sign.json` | `make sign` |

## Setup

After instantiating the project from the scaffold:

1. Edit `gon-sign.json` in this directory to verify the `bundle_id` and
   signing identity are correct.
2. Set the `AC_PASSWORD` environment variable to your Apple app-specific
   password (generate at https://appleid.apple.com/).
3. Run `make build` — the Makefile copies files to their target locations
   automatically.

The target locations (`desktop/build/`) are gitignored. This directory is
**not** gitignored so the templates stay in version control, but should never
contain actual passwords — use `@env:` references instead.
