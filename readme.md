# CODEV — Your workspace for building software

CODEV brings AI chat, project files, model teams and developer tools into one workspace. Use the browser version, install the desktop app, or work from the terminal with CODEV CLI.

**Website:** https://codev.bytecraft.workers.dev/  
**Try CODEV:** https://codev.bytecraft.workers.dev/try-demo-on  
**Help:** https://codev.bytecraft.workers.dev/docs  
**Downloads:** https://codev.bytecraft.workers.dev/download

## Choose how to use CODEV

| App | Best for | Start here |
|---|---|---|
| Web | Trying CODEV in a browser | Open Try CODEV on the website |
| Desktop | Full workspace, local project files, Review Side, terminal, MCP and LSP | Download and install CODEV Desktop |
| CLI | Keyboard-first chat and coding in a terminal | Install CODEV CLI, open a terminal and run `codev` |

## Quick start

1. Open CODEV Web or install Desktop/CLI from the [Downloads page](https://codev.bytecraft.workers.dev/download).
2. Create a new session.
3. Select one model from the model picker.
4. Type a request and press Enter.
5. To compare models, select a second model. Team Mode starts automatically; you can select up to six models.
6. Attach files from the attachment menu, or use `@path/to/file` in CLI to include a local text file.
7. Use **Download ZIP** when CODEV has created a set of project files.

## Models and API providers

CODEV-hosted models are available in the model picker without entering a separate API key. To use your own provider, open **API & Model**, choose a provider, enter its API Base URL and API Key, then choose **Test & Load Models**. Select a model from the returned catalog.

Never paste private API keys, OAuth tokens or passwords into a chat. Keep credentials in provider settings or the secure configuration area provided by your deployment.

## Team Mode and usage

Selecting two or more models enables Team Mode automatically. Every selected model receives its own request. Each model is counted separately only when it returns a complete, non-empty response.

- CODEV-hosted models: 20 successful requests per model in a rolling 72-hour window.
- Your own API provider (BYOK): 20 successful requests per model in a rolling 24-hour window.
- Failed requests, timeouts, blocked requests and empty responses are not charged by the local usage counter.

These counters are per local app profile/device, not a shared account-wide billing ledger. The upstream provider may apply additional limits or charges.

## Files, code and ZIP downloads

Use the attachment menu to add documents, images, source files or supported media. Long pasted text is attached as `paste.txt` to keep the composer readable. Generated code can be viewed, copied or downloaded. Use **Download ZIP** to collect generated project files into one archive. In CLI, `/zip` packages recognized files in the latest assistant response into the current project folder.

## Connect services

Open **Extensions** and press **Connect** beside a supported service. CODEV opens the service's authorization page in your browser. Sign in and approve the requested permissions, then return to CODEV. You do not need to enter OAuth developer credentials in the app. If a connector is reported as unavailable, contact the CODEV administrator; do not send credentials in chat.

## User help

- [Getting started](docs/GETTING-STARTED.md)
- [Desktop and Web guide](docs/USER-GUIDE.md)
- [CLI guide and commands](docs/CLI-GUIDE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Privacy, usage and known limits](docs/PRIVACY-AND-LIMITS.md)

## Reporting a problem

Include the CODEV version, whether you used Web/Desktop/CLI, the selected provider/model, and the exact error text. A screenshot can help. Remove API keys, access tokens, private source code and personal data before sharing logs. Open an issue at https://github.com/MrCutLAST/Codev-OFFICIAL/issues.

## About this repository

This repository is the public home for CODEV documentation and release information. Development and deployment details for maintainers are kept in [CONTRIBUTING.md](CONTRIBUTING.md), not in the end-user guides.
