# Changelog

## 16.20.6 — R11

### Fixed
- Fixed Cloudflare Worker upstream fetches for hosted models. R10 used `redirect: "error"` in Worker runtime paths; Cloudflare Workers accepts `follow` or `manual`. Model discovery and hosted chat could therefore fail with HTTP 502 and “Invalid redirect value”.
- Updated the hosted model proxy and media fetch helper to use `redirect: "follow"`.
- Added regression coverage for `GET /api/v1/models`, `POST /api/v1/chat/completions`, and a static guard against unsupported redirect modes.
- Added CLI tests proving `/models` and chat use the expected gateway endpoints.

### Documentation
- Replaced maintainer-focused content on the public `/docs` page with an end-user guide.
- Rewrote the repository README for CODEV users and added guides for getting started, Desktop/Web, CLI, troubleshooting, privacy and usage limits.
- Moved build/development instructions to `CONTRIBUTING.md`.

### Versioning
- Desktop/Worker source: 16.20.6.
- CLI: 16.20.7.
