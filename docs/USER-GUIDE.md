# CODEV Desktop and Web user guide

## Main areas

- **Chat:** send requests, review answers and continue a conversation.
- **Model picker:** choose the model for the next request. Selecting two or more models turns on Team Mode automatically.
- **Review Side:** open tabs such as Files, Browser, Terminal, Console and Context when needed. Use the tab close control to close a panel tab. Drag the divider to adjust the panel width.
- **Extensions:** connect supported services, MCP servers and available skills.
- **Settings:** manage app preferences and chat backup/restore.
- **API & Model:** manage your own API providers and model catalogs. It is separate from general Settings.

## Team Mode

Select two to six models in the model picker. CODEV sends one request to each selected model. Responses are shown separately so you can compare them. Click a selected model again to remove it. The app records usage separately for every model that returns a complete, non-empty answer.

## API providers

CODEV-hosted models are available directly from the model picker. For BYOK (Bring Your Own Key), choose a provider in **API & Model**, add its API Base URL and API Key, then load the provider's model list. Provider model IDs are supplied by the selected provider; use an ID from that list.

Provider APIs can have their own billing, model permissions, rate limits and context limits. CODEV cannot override an upstream provider's policy.

## Plugins and authorization

Press **Connect** next to a service. Your browser opens the service's authorization page. Review the permissions and approve only if you trust the service and requested access. Return to CODEV after authorization. If the app reports that a service is not configured or unavailable, the service needs attention from the CODEV deployment administrator. Do not paste OAuth client secrets into CODEV chat.

## MCP and LSP

MCP servers can expose tools to a session. Review the server name and tools before use. Some tools can write files or change data; only use servers you trust. LSP features depend on the matching language-server executable being installed and available on your computer.

## Browser and local terminal

The Browser tab is opened when you create it from Review Side. It can show the built-in search experience and web previews. The local Terminal runs commands in the selected project directory on your own computer. Commands can modify or delete files; inspect commands before running them.

## Code and generated files

Long code blocks can be collapsed to keep the conversation readable. Use Copy or Download File for an individual block. When a response contains multiple generated files, use Download ZIP. Review the archive contents before extracting over an existing project.

## Back up chats

Use **Settings → Backup Chat** to export a backup. Use **Settings → Restore Chat** to restore a compatible backup. Keep backup files private if they contain prompts, source code or other sensitive information.
