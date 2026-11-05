# Privacy, usage and known limits

## API keys and connected accounts

Keep provider API keys private. BYOK keys are used to authenticate requests to the provider you selected. Do not paste keys, OAuth access tokens, refresh tokens or passwords into prompts, screenshots, issue reports or public repositories.

When connecting a plugin, CODEV opens the provider's authorization page. Review the requested permissions before approving. Disconnect an integration from the app when you no longer want it available.

## Chat and project data

Chat history, settings and usage counters may be stored in the local browser or desktop profile. Backups can contain prompts, generated files and private project content. Store backups in a private location and do not upload them to a public repository.

Local files are available only when you attach/select them or use the local project workspace. A chat model does not automatically have access to every file on your computer.

## Request allowances

The current local usage guard is:

- CODEV-hosted models: 20 successful requests per model in a rolling 72-hour period.
- BYOK models: 20 successful requests per model in a rolling 24-hour period.
- Team Mode: each selected model is counted separately after a complete, non-empty response.
- Failed, timed-out, blocked or empty responses are not charged by the local usage guard.

The counter is stored per app profile/device and is not an account-wide billing system. A model provider or gateway can enforce additional limits and may charge according to its own terms.

## What CODEV can and cannot guarantee

- Model answers can be incorrect or incomplete. Review generated code before using it in production.
- Long output depends on the selected model's context/output limits and the provider's service limits.
- Image, video and audio features depend on the selected model and upstream provider's support and account permissions.
- Web search requires an available search service and internet access.
- Local terminal commands run with the permissions of your operating-system account and can change files. Inspect commands before approving/running them.
- LSP features require the language-server program to be installed locally.
- A successful local test does not prove that a third-party provider account, model entitlement or remote deployment is configured correctly.
- A new conversation does not automatically imply that the model remembers private context from other conversations. Use chat backup/restore or explicitly attach the relevant project context.

## Safe bug reports

Never include API keys, OAuth tokens, private keys, passwords, cookies, personal data or private project files in public issues. Share only the minimum redacted information needed to reproduce a problem.
