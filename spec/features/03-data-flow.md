# 03 — Data flow

## Purpose

Describes the complete journey of data from the JSONs to rendering in the browser.

## Pipeline

```
1. src/data/*.json (7 files)
        │ Static import in BaseLayout.astro
        ▼
2. BaseLayout.astro
        │ const dataBundle = JSON.stringify({ lang, skills, ... })
        │ Injection: <body data-data={dataBundle}>
        ▼
3. Static HTML (Astro build-time)
        │ The data-data attribute contains ALL escaped data
        ▼
4. Browser
        │ HTML loads
        │ The DOM auto-decodes HTML entities in the dataset
        ▼
5. client.js
        │ const DATA = JSON.parse(document.body.dataset.data)
        │ DATA.lang, DATA.skills, DATA.education, etc.
        ▼
6. Render
        │ translateUI() applies data-i18n
        │ renderSection() fills dynamic containers
        │ toggleSection() hides empty arrays
```

## Advantages

- **0 extra HTTP requests** for data (everything travels in the initial HTML).
- **No XSS vulnerabilities** — Astro automatically escapes the string in the template.
- **No globals** — data does not pollute `window`.
- **Instant** — the client does not need to wait for fetch().

## Design decisions

The following approaches were discarded:
- **fetch() to static JSONs**: extra latency, loading state complexity.
- **`<script is:inline set:html>`**: Astro discourages it for dynamic data, mixes logic and presentation.
- **`Astro.serialize()`**: API that does not exist in Astro 5.

## Relevant code
- `src/layouts/BaseLayout.astro:14` — `JSON.stringify()`
- `src/layouts/BaseLayout.astro:35` — `data-data` on `<body>`
- `src/scripts/client.js:1` — `JSON.parse(document.body.dataset.data)`
