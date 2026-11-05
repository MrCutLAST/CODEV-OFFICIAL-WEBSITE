# Contributing to CODEV

Thank you for helping improve CODEV. This document is for developers and maintainers. End-user help is in the [docs/](docs/) directory.

## Report bugs

Open an issue at https://github.com/MrCutLAST/Codev-OFFICIAL/issues with reproducible steps, expected behavior, actual behavior, app version and redacted logs. Never commit API keys, OAuth secrets, access tokens, chat backups or private project files.

## Local development

1. Fork or clone the repository.
2. Install Node.js 22 or newer. Go 1.23+ is needed only to rebuild the CLI binaries from source.
3. Install JavaScript dependencies:

   ```bash
   npm install
   ```

4. Run the checks relevant to your change:

   ```bash
   npm run check
   npm run test:all:desktop
   ```

5. For CLI source changes:

   ```bash
   cd cli
   go test ./...
   ```

## Cloudflare Worker compatibility

Cloudflare Workers support `redirect: "follow"` and `redirect: "manual"` for outbound fetches. Do not use `redirect: "error"` in Worker code. Add regression coverage when changing gateway/model discovery or provider fetch behavior.

## Build

- Desktop: run `BUILD-WINDOWS.bat` on Windows with Node.js 22+.
- CLI: use `cli/build-windows.ps1` or the commands documented in `cli/README.md` on a machine with Go 1.23+.
- Web: deploy `worker.js` using the deployment procedure for the project. Keep production secrets in the platform's secret store; never commit populated `.env` files.

## Pull requests

Create a branch from `main`, describe the user-facing change, include tests and screenshots where appropriate, and update user documentation when behavior changes. Do not publish binaries, chat data or secrets in source commits unless the release process explicitly requires a public artifact.


## Release automation

The GitHub release workflow is [`.github/workflows/release-codev.yml`](.github/workflows/release-codev.yml). Before tagging, make sure the full application source tree (Worker, Electron Desktop and CLI) is present at the repository root. The workflow validates these files, runs the cross-platform tests, embeds `GITHUB_REPOSITORY` for electron-updater, builds platform installers, and publishes release assets using the job-scoped `GITHUB_TOKEN`.

See [Automatic update setup](docs/AUTO-UPDATE-SETUP.md) for the repository permission, first-release, Desktop updater and CLI manifest steps. The release workflow cannot build from the current documentation-only repository; the full R11 application source still needs to be committed.
