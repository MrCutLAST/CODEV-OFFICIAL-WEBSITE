# Set up automatic updates for CODEV

This guide covers the GitHub settings for CODEV Desktop updates and the Worker variable used by CLI updates.

## Important: the application source must be in this repository

The release workflow is now prepared, but it cannot build a release until the full application source is committed at the repository root. The current `main` branch contains public documentation, screenshots and the R11 gateway patch; it does not yet contain the Desktop/Worker/CLI source tree.

The workflow checks for these files and stops clearly when they are absent:

- `package.json`
- `worker.js`
- `desktop/electron/main.mjs`
- `desktop/electron/electron-builder.config.cjs`
- `cli/go.mod`
- `cli/cmd/codev/main.go`

Upload the matching full source package (for example, `Codev-Desktop-v16.20.6-R11-FULL-SOURCE.zip`) into a temporary folder, then copy these application files/folders into the repository root:

- `package.json`, `VERSION.txt`, `worker.js`, `BUILD-WINDOWS.bat`, `JSZIP-LICENSE.txt`
- `desktop/`, `cli/`, `tests/`

Preserve the current repository's user-facing `readme.md`, `docs/`, `CONTRIBUTING.md` and `.github/workflows/release-codev.yml`. **Do not copy** the source ZIP's `.github/workflows/release-desktop.yml`; it is the older release workflow and would run alongside the new publisher for the same tag. Keep only `release-codev.yml` enabled for tag publishing. Do not upload `.env`, secrets, chat backups or personal API keys.

The root `package.json` version must match `VERSION.txt`; the workflow checks both against the tag.

## 1. GitHub Actions permissions

Open:

**Repository → Settings → Actions → General → Workflow permissions**

Select **Read and write permissions**, then save.

The workflow grants `contents: write` only to the release job. It uses GitHub's automatically generated `GITHUB_TOKEN`; no Personal Access Token or extra GitHub secret is needed. If the repository or organization restricts Actions permissions, the repository-level setting must allow the workflow token to create releases.

## 2. No AI or OAuth secret is needed for releases

The release workflow uses:

- `github.repository` to identify `MrCutLAST/Codev-OFFICIAL`.
- `secrets.GITHUB_TOKEN` provided automatically by GitHub Actions.
- A matching version tag (such as `v16.20.6`) to trigger publication.

Do not add `API_KEY_SECRET`, provider API keys or OAuth client secrets to GitHub Actions. They are unrelated to application publishing.

## 3. Desktop update feed

The Desktop source uses `electron-updater` and electron-builder's GitHub provider. The build sets `GITHUB_REPOSITORY=MrCutLAST/Codev-OFFICIAL` so the installed app receives the correct update feed.

A Windows release must contain:

- `CodevSetup.exe`
- `latest.yml`
- `CodevSetup.exe.blockmap`

The first installation must come from a Desktop build that embeds this repository as its GitHub update provider. An older installation built without that provider cannot discover the feed; install the first correctly configured release manually.

## 4. CLI update feed

The Windows CLI release workflow creates `cli-update.json` containing its own CLI version, HTTPS download URL and SHA-256 checksum.

After deploying the Worker version that exposes `GET /api/cli/update`, set this **Worker Variable**:

```text
CODEV_CLI_UPDATE_MANIFEST_URL=https://github.com/MrCutLAST/Codev-OFFICIAL/releases/latest/download/cli-update.json
```

This is a public URL, not a secret. The CLI checks the manifest, verifies SHA-256, and then replaces its executable. The current manifest is for Windows CLI; do not use it for other operating systems until platform-specific update manifests are implemented.

## 5. Publish a release

Once the full source and workflow are in `main`:

1. Update the Desktop version in `package.json` and keep it consistent with `VERSION.txt`.
2. Update the CLI version constant in `cli/cmd/codev/main.go` when releasing a new CLI build.
3. Commit and push the source.
4. Create a matching tag for the Desktop/package version:

   ```bash
   git tag v16.20.6
   git push origin v16.20.6
   ```

5. Open **Actions → Build and publish CODEV releases**. Wait for all platform and CLI jobs.
6. Open **Releases** and confirm that the installer, `latest.yml`, blockmap, CLI executable, CLI installer and `cli-update.json` are attached.

The workflow checks the version/tag match and refuses to publish if release assets are missing.

## 6. Verify updates

### Desktop

Install the first correctly configured release. Publish a higher version with the same workflow. On the next app launch, CODEV checks the GitHub feed and offers a download. After downloading, choose Restart to install.

### CLI

Install the Windows CLI from the release. After a newer release is published and the Worker variable points to the latest manifest, run `/update`.

## 7. What remains separate

- The release workflow does not deploy Cloudflare Worker code.
- AI provider and OAuth credentials remain in the Worker secret/variable store.
- Existing Desktop installations without an embedded GitHub update feed need one manual update to the first configured build.
- No release is created until the full source is present and every required build passes.
