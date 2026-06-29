# 01 · Architecture — Plan

## Approach

Single-page architecture with Astro SSG. Two distinct phases keep concerns separated: Astro handles static generation, vanilla JS handles dynamic client needs. Data moves from JSON to HTML attribute to JavaScript object — no network requests.

## Implementation

1. **BaseLayout.astro** imports all 7 JSONs statically, serializes them, and injects as `data-data` attribute on `<body>`.
2. **client.js** reads `JSON.parse(document.body.dataset.data)` on load — no fetch, no globals.
3. **init()** runs on page load: loads saved language from localStorage, translates UI, sets language button active, triggers reveal animations.
4. **changeLanguage()** re-renders all dynamic sections from the data object and persists the choice.

## Decisions

- **data-data attribute over `<script is:inline set:html>`** — Astro encourages data in HTML attributes for server-rendered content. Avoids mixing logic and presentation.
- **data-data over `window.DATA`** — no global pollution. Data is scoped to the DOM element, accessible only via `document.body.dataset.data`.
- **data-data over `fetch()`** — zero extra HTTP requests, instant data availability, no loading state.
- **Vanilla JS over framework** — the portfolio has simple interactivity (i18n switching, scroll animations). A framework would add unnecessary complexity.

## Risks

- **HTML entity encoding** — Astro automatically escapes strings in templates, which can break `JSON.parse`. The browser auto-decodes entities in `dataset`, mitigating this. Verify with special characters (accents, quotes).
- **Large JSON payload** — Currently small (7 JSONs, <50KB combined). If data grows significantly, consider lazy sections.
