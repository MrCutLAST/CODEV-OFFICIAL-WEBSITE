# Applying the R11 gateway fix

The repository's `patches/cloudflare-fetch-redirect-r11.patch` contains the minimal two-line Worker fix.

## Why it is needed

Cloudflare Worker outbound `fetch()` accepts `redirect: "follow"` or `redirect: "manual"`. The previous R10 code passed `redirect: "error"` in two Worker-side paths. The runtime rejected the fetch options before contacting the upstream service, so CLI chat and `/models` returned HTTP 502 with an “Invalid redirect value” message.

## Apply

1. Open the Worker source used by your active deployment.
2. In the shared media fetch helper, change `redirect: 'error'` to `redirect: 'follow'`.
3. In the `/api/v1` model/chat proxy, change `redirect: "error"` to `redirect: "follow"`.
4. Confirm no Cloudflare Worker code path still uses `redirect: "error"`. A Node/Electron local server is a separate runtime and may use different Fetch options.
5. Run the gateway regression tests from the R11 source package.
6. Deploy the Worker.
7. Reopen CODEV CLI and test `/models` followed by a normal chat request.

Do not remove the Worker's origin validation or expose `API_KEY_SECRET` to the client. Keep the upstream API key in the Worker secret store.
