# CODEV troubleshooting

## CLI chat or `/models` returns HTTP 502 with “Invalid redirect value”

This is a server-side gateway compatibility error, not an incorrect model ID or a quota charge. Update the deployed CODEV Worker to a release that uses a Cloudflare-supported redirect mode (`follow` or `manual`) for upstream model and chat requests. Then reopen the CLI and run `/models` again. If you do not manage the Worker, send the error text and app version to its administrator.

The failed request should not use a local successful-request allowance. The upstream provider may still log failed traffic according to its own policy.

## A model is missing from `/models`

1. Check that the intended provider is selected with `/provider` or in **API & Model**.
2. For BYOK, verify the API Base URL and key, then load models again.
3. Confirm that your provider account has access to that model ID.
4. For CODEV-hosted models, try again after the gateway is available. The upstream catalog determines which built-in models are enabled.

## “401” or authentication error

For BYOK, check the key and whether it has permission for the requested API. For CODEV-hosted models, do not paste an upstream key into the app; contact the service administrator if the hosted gateway reports an authentication error.

## “404” or model not found

Check the selected provider and exact model ID. Model IDs are provider-specific. Re-load the model catalog and choose an ID from the list.

## “429” or rate limit

The provider or gateway is rate limiting requests. Wait before retrying and check provider-side usage/billing. Team Mode sends a request to every selected model, so it can reach provider limits faster than single-model chat.

## “Request origin is not allowed” in Desktop

Update to a Desktop release whose local proxy forwards hosted model requests through the deployed CODEV Worker without forwarding the local loopback browser Origin header. Do not disable the Worker origin check to work around this problem.

## Plugins will not connect

Press **Connect** and complete authorization in the provider's browser page. If CODEV says the integration is unavailable or not configured, the CODEV deployment administrator must fix the server-side integration. End users should not enter OAuth client secrets into chat or local app fields.

## ZIP download is missing files

Generated files need clear relative paths and separate file blocks so CODEV can recognize them. Re-run the request asking for each file with its path, then use **Download ZIP** (or `/zip` in CLI). Inspect the archive before extracting it.

## Terminal command fails

Verify that a project folder is selected and that the required tool is installed on your computer. For example, running `npm test` requires Node.js/npm and a project with a test script. CODEV does not install every development tool automatically.

## Share a useful bug report

Include the app version, Web/Desktop/CLI, provider, model ID, exact error and steps to reproduce. Attach a screenshot if useful. Remove API keys, access tokens, personal data and private source code before sharing.
