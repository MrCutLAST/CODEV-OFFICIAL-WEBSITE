# Set up CODEV automatic updates safely

This public repository contains release automation and public release assets only. **Never place the CODEV application source, source ZIP, build cache, environment file, or credentials in this repository.**

## Architecture

- `MrCutLAST/Codev-OFFICIAL` stays public. It contains the updater/release workflow and publishes installers and CLI binaries as GitHub Release assets.
- The complete CODEV application source must live in a separate **private** GitHub repository owned by the project owner.
- GitHub Actions checks out the private source with a read-only token, builds it on hosted runners, and uploads only the resulting installers/binaries to public Releases.
- No source archive is committed to this public repository. The importer script used by the previous design has been removed.

## One-time private source setup

1. In GitHub, create a separate repository such as `MrCutLAST/Codev-SOURCE` and set its visibility to **Private**.
2. Upload the complete CODEV Desktop/Worker/CLI source tree to that private repository's `main` branch. Do not put the source ZIP in `Codev-OFFICIAL`.
3. Create a fine-grained Personal Access Token restricted to that private source repository, with **Contents: Read-only** permission. Do not grant administration, workflow, or write permissions.
4. In the public `Codev-OFFICIAL` repository, open **Settings → Secrets and variables → Actions**:
   - Under **Variables**, add `CODEV_SOURCE_REPOSITORY` with value `MrCutLAST/Codev-SOURCE` (use the actual private repository owner/name).
   - Under **Secrets**, add `CODEV_SOURCE_TOKEN` with the fine-grained read-only token.
5. Keep the private source repository private. Do not paste the token into files, workflow YAML, issue comments, or chat.

The token is used only by checkout steps. It is not embedded in the installer and is not used by the running application.

## Build and publish

The workflow is `.github/workflows/release-codev.yml`.

1. Push the updated source to the private repository's `main` branch first.
2. In the public repository, open **Actions → Build and publish CODEV releases → Run workflow**. The optional `source_ref` input defaults to `main`; you can enter a private source branch, tag, or commit for a manual validation build.
3. The manual run builds and stores temporary workflow artifacts; it does not publish a public Release.
4. After all build jobs pass, push a version tag to the **public** repository, for example:

   ```bash
   git tag v16.20.6
   git push origin v16.20.6
   ```

5. The tag run checks the private source version against the tag, builds Desktop for Windows/macOS/Linux and CLI for Windows/Linux, then publishes the binary assets to the public GitHub Release.

For tag-triggered releases, the workflow checks out the private source repository's `main` branch. Update that branch to the intended release before creating the public tag. The tag must match `package.json` and `VERSION.txt`.

## GitHub Actions permissions

The workflow uses the automatically provided `GITHUB_TOKEN` for publishing:

- Build jobs: `contents: read` on the public repository, plus the separate read-only `CODEV_SOURCE_TOKEN` for the private source repository.
- Publisher job only: `contents: write` to create the public GitHub Release.

If publishing fails with a permission error, check **Settings → Actions → General → Workflow permissions** and organization policy. No write token is needed for the private source repository.

## Published assets

- Windows Desktop: `CodevSetup.exe`, `latest.yml`, and blockmap files.
- macOS Desktop: DMG installers and update metadata.
- Linux Desktop: AppImage and update metadata.
- CLI: `CodevCLI.exe`, `CodevCLI-Setup.exe`, `CodevCLI-linux-amd64`, and `cli-update.json`.

Only built outputs are published. The complete source remains in the private source repository.

## CLI update Worker variable

After deploying the Worker route `GET /api/cli/update`, add this non-secret Worker variable:

```text
CODEV_CLI_UPDATE_MANIFEST_URL=https://github.com/MrCutLAST/Codev-OFFICIAL/releases/latest/download/cli-update.json
```

CLI users can then run `/update`. The app checks the HTTPS URL and validates SHA-256 before replacing the executable.

## Separate credentials

- AI provider and OAuth credentials remain in Cloudflare Worker variables/secrets.
- The private-source checkout token stays in GitHub Actions Secrets and must be read-only.
- Do not commit `.env`, API keys, OAuth secrets, chat backups, or private source to this public repository.
