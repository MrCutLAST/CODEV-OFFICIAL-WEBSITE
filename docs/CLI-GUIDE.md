# CODEV CLI guide

CODEV CLI is a terminal application. Install it from the CODEV [Downloads page](https://codev.bytecraft.workers.dev/download), open a new Windows Terminal/PowerShell window, then run:

```powershell
codev
```

Type `/` in the composer to open the command palette. Continue typing to filter. Use **Up/Down** to move, **Tab** to insert/complete a command, **Enter** to select or run it, and **Esc** to close the palette.

## Commands

| Command | What it does |
|---|---|
| `/help` | Show commands and keyboard shortcuts |
| `/new` | Start a blank conversation |
| `/clear` | Clear the current conversation view |
| `/models` | Fetch the current model catalog for the selected provider |
| `/model <id>` | Select one model |
| `/team add <id>` | Add a model to Team Mode |
| `/team remove <id>` | Remove one model from Team Mode |
| `/team list` | Show selected Team Mode models |
| `/team clear` | Turn off Team Mode |
| `/provider codev` | Use the hosted CODEV model gateway |
| `/provider custom` | Use your own provider settings |
| `/base-url <url>` | Set the selected provider's API Base URL |
| `/api-key <key>` | Save your own provider API key locally |
| `/project <path>` | Set the local project folder |
| `/status` | Show provider, model, team and project status |
| `/zip` | Create a ZIP from recognized files in the latest assistant response |
| `/update` | Check for a CLI update |
| `/exit` or `/quit` | Exit the CLI |

## Shortcuts and input

- `@path/to/file` — include a local text/source file in the next prompt.
- `!command` — run a local shell command in the selected project folder.
- `/` — open the full command palette.
- `/models` — refresh the model list. If the request fails, see [Troubleshooting](TROUBLESHOOTING.md).

## Team Mode

Use `/team add <id>` for each model. Team Mode starts when two or more models are selected. Use `/team list` to review the selected models and `/team remove <id>` to remove one. `/team clear` returns to single-model mode.

## ZIP files

After CODEV produces multiple fenced files with relative paths, run `/zip`. The CLI saves the ZIP into the selected project directory. Check that every expected file appears in the archive before using it.

## Local configuration and privacy

The CLI saves its profile under the current user's application configuration directory. Do not share the config file because it may contain a BYOK API key. Use a separate provider key with only the permissions and spending limits you need.
