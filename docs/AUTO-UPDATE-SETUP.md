# Set up automatic updates for CODEV

This guide is for the repository owner. It covers the GitHub setup needed for Desktop releases and the Worker variable needed by CLI updates.

## Current repository prerequisite

The public repository must contain the complete application source at its root before the release workflow can build anything. Required files include:

- `package.json`
- `worker.js`
- `desktop/electron/main.mjs`
- `desktop/electron/electron-builder.config.cjs`
- `cli/go.mod`
- `cli/cmd/codev/main.go`

The current documentation-only repository does not yet contain those app source files. The release workflow intentionally checks for them and stops with a clear error rather than publishing an empty or broken release. Upload/merge the full source from the matching CODEV R11 source package first.

## 1. GitHub Actions permissions

In the repository, open:

**Settings → Actions → General → Workflow permissions**

Select **Read and write permissions**, then save.

The release workflow also declares:

```yaml
permissions:
  contents: read
```

and grants `contents: write` only to its release-publishing job. The publisher uses GitHub's automatically generated `GITHUB_TOKEN`; no Personal Access Token or extra GitHub secret is required.

## 2. No GitHub secret is required for the public release

For a public repository, the workflow uses:

- `github.repository` to identify `MrCutLAST/Codev-OFFICIAL`.
- `secrets.GITHUB_TOKEN` to create a Release and upload assets.
- A Git tag such as `v16.20.6` to start a release build.

Do not add your AI `API_KEY_SECRET`, provider API keys or OAuth client secrets to GitHub Actions. They are not required to build or publish the desktop app.

## 3. Desktop updater

The Desktop source uses `electron-updater` and the GitHub provider in `desktop/electron/electron-builder.config.cjs`. The build must receive `GITHUB_REPOSITORY=MrCutLAST/Codev-OFFICIAL`; the workflow sets it for every platform build.

The release must contain:

- `CodevSetup.exe`
- `latest.yml`
- `CodevSetup.exe.blockmap`
- macOS/Linux installers and their platform metadata, when those builds succeed.

The first installed Desktop build must be packaged with this GitHub repository as its update provider. Existing installations built without a provider cannot discover this feed automatically; install the first correctly packaged release manually.

## 4. CLI updater

The release workflow creates `cli-update.json` with the CLI version, release download URL and SHA-256. After the source is deployed to the Worker, set this **Worker Variable**:

```text
CODEV_CLI_UPDATE_MANIFEST_URL=https://github.com/MrCutLAST/Codev-OFFICIAL/releases/latest/download/cli-update.json
```

This is a public URL, not a secret. The Worker route `GET /api/cli/update` reads the manifest and returns it to the CLI. The CLI validates the HTTPS URL and SHA-256 before replacing its executable.

The current manifest is for the Windows CLI executable. Do not use it for a different operating system unless that platform's binary and checksum are published in a platform-aware manifest.

## 5. Publish the first release

After the complete source and workflow are in the default branch:

1. Update the `version` in `package.json`.
2. Make sure the version matches `VERSION.txt` and the release notes.
3. Commit and push the source.
4. Create and push a matching tag. Example:

   ```bash
   git tag v16.20.6
   git push origin v16.20.6
   ```

5. Open **Actions → Build and publish CODEV releases** and wait for all desktop and CLI jobs to pass.
6. Open **Releases** and verify the Windows installer, `latest.yml`, blockmap, CLI executable, CLI installer and `cli-update.json` are present.

The workflow checks that the source is present and that the tag matches `package.json`. It does not publish a Release if build assets are missing.

## 6. Verify updates

### Desktop

Install the first release built with the GitHub provider. Publish a higher version with the same workflow. Open the installed app; when a newer release is available, CODEV offers to download it and then restart to install.

### CLI

Install the CLI executable from the release. After publishing a higher version and updating the Worker manifest URL variable, run `/update`. The CLI checks the version and checksum before replacing the installed binary.

## 7. What this setup does not do

- It does not deploy the Cloudflare Worker. Deploy Worker code separately.
- It does not configure AI provider credentials or OAuth credentials.
- It does not auto-update an already-installed Desktop app that was originally built without the GitHub update provider.
- It does not create a release until the complete app source is present and the build workflow succeeds.
