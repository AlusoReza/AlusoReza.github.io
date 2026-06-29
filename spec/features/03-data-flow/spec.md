# 03 · Data flow

**Status:** implemented ✅

## What it does

Describes the complete journey of data from the JSON files to rendering in the browser.

### Pipeline
```
1. src/data/*.json (7 files)
        ↓ Static import in BaseLayout.astro
2. BaseLayout.astro
        ↓ const dataBundle = JSON.stringify({ lang, skills, ... })
        ↓ <body data-data={dataBundle}>
3. Static HTML (Astro build-time)
        ↓ The data-data attribute contains ALL escaped data
4. Browser
        ↓ HTML loads, DOM auto-decodes HTML entities in dataset
5. client.js
        ↓ const DATA = JSON.parse(document.body.dataset.data)
6. Render
        ↓ translateUI() applies data-i18n
        ↓ renderSection() fills dynamic containers
        ↓ toggleSection() hides empty arrays
```

## Why

Zero extra HTTP requests for data, no XSS vulnerabilities, no globals, instant availability. The entire data payload travels in the initial HTML document.

## Acceptance criteria

- [ ] No `fetch()` calls to load JSON data on the client.
- [ ] No `window.DATA` or `window.changeLanguage` globals.
- [ ] Special characters (accents, quotes, emoji) survive the JSON.stringify → data-data → JSON.parse round trip.
- [ ] Browser auto-decodes HTML entities in `document.body.dataset.data`.
- [ ] All 7 JSONs are available from `DATA` object after parsing.

## Out of scope

- Streaming data — the entire payload is delivered in a single HTML response.
- Caching strategies — data is always fresh from the build.
