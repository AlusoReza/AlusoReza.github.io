# 01 — Architecture

## Purpose

Defines the two-phase architecture of the portfolio: static render at build-time (Astro) + dynamic client-side hydration (vanilla JS).

## Phases

### Phase 1: Build-time (Astro)
- Astro compiles all `.astro` files to static HTML.
- The `BaseLayout.astro` layout serializes the 7 JSONs from `src/data/` into a `dataBundle` object using `JSON.stringify()`.
- This string is injected as a `data-data` attribute on the `<body>` tag.
- Components render content in Spanish by default.
- Sections with empty arrays (`experience`, `certificates`) receive `style="display:none"`.

### Phase 2: Client-side (browser)
- `client.js` loads as an external script (bundled by Astro).
- Reads `JSON.parse(document.body.dataset.data)` — the browser auto-decodes HTML entities.
- Loads the saved language from `localStorage`.
- If the language is not Spanish, it runs `changeLanguage()` which re-renders all sections.

## Data flow

```
src/data/*.json
    → BaseLayout.astro imports and serializes them
    → <body data-data={JSON.stringify({...})}>
    → client.js: JSON.parse(document.body.dataset.data)
    → renderAll() / changeLanguage()
```

## Rules
- **Do not use fetch() to load JSONs on the client** — everything travels in `data-data`.
- **Do not use `<script is:inline set:html>`** — data goes in the HTML attribute.
- **Do not expose `window.DATA`** — data is only accessible from `document.body.dataset.data`.

## Relevant code
- `src/layouts/BaseLayout.astro:13-14` — dataBundle serialization
- `src/layouts/BaseLayout.astro:35` — `<body data-data={dataBundle}>`
- `src/scripts/client.js:1` — `JSON.parse(document.body.dataset.data)`
