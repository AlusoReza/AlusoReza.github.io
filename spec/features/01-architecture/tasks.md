# 01 · Architecture — Tasks

- [x] Implement `BaseLayout.astro` with data-data injection
- [x] Implement `client.js` with `JSON.parse(document.body.dataset.data)`
- [x] Verify no `<script is:inline set:html>` in build output
- [x] Verify no `window.DATA` or `window.changeLanguage` globals
- [ ] Run `check-astro-mcp.ps1` to verify architecture compliance

## Maintenance

- [ ] If a new JSON is added to `src/data/`, update the bundle in `BaseLayout.astro` and the `DATA` object in `client.js`.
