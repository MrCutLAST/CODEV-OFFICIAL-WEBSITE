# CODEV releases and automatic updates

The public repository `MrCutLAST/Codev-OFFICIAL` contains release automation, helper scripts, and published binaries only. **Never commit the CODEV application source or a plaintext source ZIP here.**

## Source privacy: no separate source repository

You do not need a private source repository, a Mac, or a Linux machine. The source stays on your Windows PC. Before a release, the helper script:

1. Creates a source ZIP while excluding Git history, dependency folders, build output, environment files, and common key/certificate files.
2. Encrypts the ZIP with AES-256-GCM.
3. Stores the encryption key locally using Windows DPAPI and as the `CODEV_SOURCE_KEY` GitHub Actions secret.
4. Uploads only the encrypted `Codev-source.zip.enc` to a **draft** release named `codev-source-bundle`.
5. Creates the version tag. GitHub Actions downloads the encrypted bundle, decrypts it only on ephemeral build runners, and builds each platform. Plaintext source is never uploaded as a workflow artifact or public release asset.

The draft source-bundle release is not publicly visible. Keep it as a draft.

## One-time setup

Requirements on your Windows PC:
- GitHub CLI (`gh`): `winget install --id GitHub.cli`
- Node.js 22 or newer
- Git access to `MrCutLAST/Codev-OFFICIAL`

Clone this public repository, then sign in once:

```powershell
gh auth login
```

The release script automatically creates the encryption key on first use, protects its local copy with DPAPI, and writes the matching GitHub Actions secret. Do not delete `%APPDATA%\Codev\release-source-key.dpapi`; losing it means the existing encrypted bundle cannot be decrypted.

## Release assets built by CI

### Desktop

| OS | CPU | Assets |
|---|---|---|
| Windows | x64 | `CodevSetup.exe` installer, `Codev.exe` portable |
| Windows | ARM64 | `CodevSetup-arm64.exe` installer, `Codev-arm64.exe` portable |
| macOS | Intel x64 | `Codev-mac-x64.dmg`, `Codev-mac-x64.zip` |
| macOS | Apple Silicon ARM64 | `Codev-mac-arm64.dmg`, `Codev-mac-arm64.zip` |
| Linux | x64 | AppImage, DEB, RPM |
| Linux | ARM64 | AppImage, DEB, RPM |

Windows x64 NSIS, macOS ZIP, and Linux AppImage packages carry electron-updater metadata. The Windows ARM64 installer is currently a manual download because its feed is published separately as `latest-arm64.yml`. DEB/RPM and portable downloads are manual-install packages. macOS DMG/ZIP packages can be built without owning a Mac, but Gatekeeper may warn on first launch. Reliable macOS in-app updates and a clean first launch require Apple Developer ID signing and notarization; those credentials are not configured by this workflow.

### CLI

The workflow publishes Windows x64/ARM64 ZIPs, macOS x64/ARM64 tarballs, Linux x64/ARM64 tarballs, the Windows x64 installer, and a Windows x64 update manifest. The current CLI self-updater consumes one platform-specific manifest and is therefore enabled for Windows x64 only; other CLI builds are downloadable manually until platform-aware manifest selection is added to the CLI source.

## Publish a release

From the cloned `Codev-OFFICIAL` repository, run PowerShell:

```powershell
.\scripts\prepare-release.ps1 -SourcePath "C:\Path\To\Codev-Desktop-v1-FINAL" -Version "16.20.9" -ReleaseTag "v1"
```

Replace the path with the folder containing the current Codev source root (`package.json`, `VERSION.txt`, `worker.js`). The version must match both `package.json` and `VERSION.txt`.

The script encrypts and uploads the source bundle. When `-ReleaseTag "v1"` points to an existing release, it dispatches the workflow on `main` and updates that same release after all build jobs pass. For a new release channel, it creates the tag and the tag push starts the workflow. The helper can create the app-version release tag by default when `-ReleaseTag` is omitted. If a build fails, inspect **Actions**; the encrypted source bundle remains in its draft release.

Increase `package.json` and `VERSION.txt` before every app update. The stable channel can keep the human-facing GitHub release tag `v1`; `latest.yml` contains the app semantic version (for example `16.20.9`) used by the updater. Do not reuse an app semantic version for a different binary.

## Updater endpoints

- Desktop: electron-updater reads the generic feed configured in `desktop/electron/electron-builder.config.cjs`, which points to `https://github.com/MrCutLAST/Codev-OFFICIAL/releases/download/v1/`. electron-builder generates `latest.yml` with the app semantic version; this deliberately avoids parsing GitHub tag `v1` as app version 1.
- CLI: Worker route `GET /api/cli/update` reads the manifest URL configured by the non-secret Worker variable `CODEV_CLI_UPDATE_MANIFEST_URL`, normally `https://github.com/MrCutLAST/Codev-OFFICIAL/releases/latest/download/cli-update.json`.

The CLI manifest currently points to Windows x64 only. SHA-256 is checked before the executable is replaced.

## Permissions and secrets

- `CODEV_SOURCE_KEY` is the only source-build secret. It is generated by the local release script and stored as a GitHub Actions secret.
- Build jobs use `GITHUB_TOKEN` with `contents: read` to download the draft encrypted bundle.
- Only the release publisher job receives `contents: write` through `GITHUB_TOKEN`.
- The encryption key is never committed to the repository, source archive, or release assets.
