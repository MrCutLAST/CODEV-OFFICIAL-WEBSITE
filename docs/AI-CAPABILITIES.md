# What CODEV AI can do — and what it cannot assume

This page explains the practical capabilities of CODEV and the conditions they depend on. Features can vary by app version, selected model, provider permissions and connected tools.

## 1. Generate files and ZIP archives

CODEV can generate project files as separate named artifacts. In Desktop/Web, use the file download controls or **Download ZIP** when the response contains multiple generated files. In CLI, use `/zip` after the model has returned file blocks with relative paths. The archive contains only files CODEV successfully recognized; check the file list and archive before replacing an existing project.

## 2. Browser and web search

The Review Side Browser can search through the configured CODEV search service and display supported web results. Search needs an internet connection and an available search service. A search result is not the same as a full browser automation session: opening arbitrary pages, running JavaScript-heavy sites or interacting with sign-in pages may not be supported.

## 3. Terminal and commands

Desktop Terminal runs commands in the project folder selected by the user. CODEV CLI supports `!command` for a local shell command. These operations run with the current operating-system user's permissions. Review commands before running them; commands can modify or delete files. A web-only session does not automatically gain access to the computer's terminal.

## 4. Local files and folders

CODEV can work with files that the user attaches, selects in the project workspace, or explicitly references in CLI with `@path/to/file`. It does not silently scan the entire computer, Desktop, Downloads folder or every drive. Large files and unsupported formats may need to be reduced or converted before attaching.

## 5. Internet and current information

Live information requires the Browser/search service or another connected tool and an internet connection. If search is unavailable, the model may only have its existing knowledge and the context supplied in the conversation. Ask for source links when a claim needs verification.

## 6. Images, video and audio

Media generation and understanding depend on the selected model, configured provider, account permissions and upstream API support. A model that accepts images does not necessarily generate images. Video generation can be asynchronous and may require provider-specific status polling. CODEV cannot promise that every model supports every media type.

## 7. Long output and context

Long code and documents can be packaged into files instead of filling the chat panel. The usable context and maximum output still depend on the selected model and provider. The app can continue some truncated outputs, but it cannot override provider token ceilings, service timeouts, rate limits or unavailable capacity.

## 8. Sessions and memory

Chat history may be stored in the local browser or desktop profile and can be backed up where the app provides Backup/Restore. A new session is a separate conversation. Do not assume the model knows content from another session unless you restore it, attach the files, or provide the relevant context again.

## 9. Tests and validation

CODEV should state exactly which checks it ran. A unit test or mocked provider response verifies application logic; it does not prove that a live provider account, model entitlement, deployed Worker or a user's Windows installation works. Real integration checks need the actual deployment and authorized account. Review generated code and test it in your own environment before production use.

## 10. Accuracy and safety

AI responses can be wrong, incomplete or outdated. Verify important technical, legal, financial and operational decisions with authoritative sources. Do not share API keys, OAuth tokens, passwords or private project files in prompts or public bug reports.
