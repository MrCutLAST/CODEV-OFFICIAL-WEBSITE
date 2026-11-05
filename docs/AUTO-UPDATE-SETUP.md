# Set up CODEV automatic updates

This page is for the CODEV repository owner. It covers the one-time GitHub setup and first release.

## What is already configured

The repository contains a GitHub Actions workflow at `.github/workflows/release-codev.yml`. It builds Desktop installers for Windows/macOS/Linux, builds the CLI, creates update metadata, and publishes a GitHub Release when a matching version tag is pushed.

The workflow uses GitHub's automatic `GITHUB_TOKEN`; no Personal Access Token, AI API key or OAuth secret is needed for publishing.

## One-time source upload

The application source is supplied as one ZIP so you do not need to upload dozens of individual files.

1. Download the CODEV R11 Full Source ZIP: `Codev-Desktop-v16.20.6-R11-FULL-SOURCE.zip`.
2. Open the repository page and choose **Add file → Upload files**.
3. Create a folder named `source` and upload the ZIP at this exact path:

   `source/Codev-Desktop-v16.20.6-R11-FULL-SOURCE.zip`

4. Commit the upload to `main`.

The release workflow extracts this archive during each build. It preserves the user-facing `readme.md`, `docs/`, `CONTRIBUTING.md` and current GitHub workflows. It deliberately skips the old `.github/workflows/release-desktop.yml` inside the ZIP so that only the new release workflow publishes tags.

The importer validates archive paths and requires the Desktop, Worker and CLI source files. Do not upload `.env` files, chat backups, API keys or OAuth secrets.

## GitHub Actions permission

The release workflow already requests the least permission it needs:

- All build jobs: `contents: read`.
- The final publisher job only: `contents: write`.

GitHub creates `GITHUB_TOKEN` automatically for each workflow job. No Personal Access Token or extra repository secret is needed. Job-level `permissions` override the repository default; however, an organization policy can restrict write access. If the publisher job reports a 403/permission error, open **Settings → Actions → General → Workflow permissions** and allow **Read and write permissions**, or ask the organization owner to permit release publishing.

## Publish the first release

The source archive has Desktop/Worker version `16.20.6` and CLI version `16.20.7`.

After uploading the ZIP:

1. Open **Actions → Build and publish CODEV releases**.
2. Click **Run workflow** on the default branch. This validates/builds all platforms without publishing a Release.
3. Wait for every build job to pass and inspect its artifacts.
4. Push the Desktop version tag:

   ```bash
   git tag v16.20.6
   git push origin v16.20.6
   ```

5. The tagged run publishes the GitHub Release after all jobs pass.

The workflow checks that `package.json`, `VERSION.txt` and the tag match. It stops if required installer or update metadata is missing.

## Release assets

- Windows: `CodevSetup.exe`, `latest.yml`, `CodevSetup.exe.blockmap`.
- macOS: Codev DMG installers and update metadata.
- Linux: Codev AppImage and update metadata.
- CLI: `CodevCLI.exe`, `CodevCLI-Setup.exe`, `cli-update.json` and Linux CLI.

The first Desktop installation must be built with `MrCutLAST/Codev-OFFICIAL` embedded as its GitHub update provider. Existing installations without a configured provider require one manual update.

## CLI update Worker variable

After deploying the Worker route `GET /api/cli/update`, add this non-secret Worker Variable:

```text
CODEV_CLI_UPDATE_MANIFEST_URL=https://github.com/MrCutLAST/Codev-OFFICIAL/releases/latest/download/cli-update.json
```

CLI users can then run `/update`. The app checks the HTTPS URL and validates SHA-256 before replacing the executable.

## What remains separate

- This workflow publishes releases; it does not deploy Cloudflare Worker code.
- AI provider and OAuth credentials stay in Cloudflare Worker variables/secrets.
- Do not put API keys or OAuth secrets in the GitHub repository.
- Do not create the release tag until the manual build workflow passes.
