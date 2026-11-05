# Getting started with CODEV

This guide is for people using CODEV, not for maintaining its server.

## Open CODEV

- **Web:** visit https://codev.bytecraft.workers.dev/try-demo-on.
- **Desktop:** download the installer from https://codev.bytecraft.workers.dev/download, install it, then open CODEV from the Start menu.
- **CLI:** install CODEV CLI, open a new terminal window and run `codev`.

## Start a conversation

1. Create a new session.
2. Open the model picker.
3. Select one model.
4. Type a question or task in the composer and press Enter.

Selecting two or more models automatically enables Team Mode. Select up to six models. Click a selected model again to remove it.

## Add your own provider

1. Open **API & Model**.
2. Choose a provider or **Custom API**.
3. Enter that provider's API Base URL and API Key.
4. Choose **Test & Load Models**.
5. Select one of the models returned by the provider.

CODEV-hosted models do not require you to paste a separate key into the chat. Never share a private API key in a prompt or screenshot.

## Add files

Use the attachment menu to select files. In CLI, use `@path/to/file` to include a local text/source file with your next message. Files are subject to the size and format limits shown by the app.

## Save generated work

Use an individual file's Download action for one file, or **Download ZIP** to save a group of generated files together. In CLI, `/zip` saves recognized files from the latest response into the current project folder.
