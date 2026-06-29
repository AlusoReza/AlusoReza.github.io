# 01 · Architecture

**Status:** implemented ✅

## What it does

Defines the two-phase architecture of the portfolio: static render at build-time (Astro) + dynamic client-side hydration (vanilla JS).

### Phase 1: Build-time (Astro)
- Astro compiles all `.astro` files to static HTML.
- `BaseLayout.astro` serializes the 7 JSONs from `src/data/` into a `dataBundle` object using `JSON.stringify()`.
- This string is injected as a `data-data` attribute on the `<body>` tag.
- Components render content in Spanish by default.
- Sections with empty arrays (`experience`, `certificates`) render with `style="display:none"`.

### Phase 2: Client-side (browser)
- `client.js` loads as an external script (bundled by Astro).
- Reads `JSON.parse(document.body.dataset.data)` — the browser auto-decodes HTML entities.
- Loads saved language from `localStorage`.
- If language is not Spanish, runs `changeLanguage()` which re-renders dynamic sections.

## Why

Provides a zero-dependency, secure, and instant-loading architecture. All data travels in the initial HTML — no extra HTTP requests, no XSS vulnerabilities, no globals on `window`.

## Acceptance criteria

- [ ] Build output has no inline `<script is:inline set:html>` tags.
- [ ] The `<body>` tag has a `data-data` attribute with all 7 JSONs serialized.
- [ ] `client.js` reads data exclusively from `document.body.dataset.data` — no `fetch()` calls.
- [ ] No `window.DATA` or `window.changeLanguage` globals exist.
- [ ] Empty arrays render sections with `display:none` in initial HTML.

## Out of scope

- Server-side rendering (SSR) — the site is fully static (SSG).
- Dynamic routing — all content lives on a single page.
