# 03 · Data flow — Plan

## Approach

Data flows in a unidirectional pipeline: JSON files → Astro template → HTML attribute → browser dataset → JavaScript object → DOM rendering. No network requests beyond the initial HTML load.

## Implementation

1. **BaseLayout.astro** imports each JSON with `import` statements. Creates a single bundle object and `JSON.stringify()`s it.
2. **Template injection:** `<body data-data={dataBundle}>` — Astro auto-escapes the string.
3. **Browser parsing:** `JSON.parse(document.body.dataset.data)` — the `dataset` property auto-decodes HTML entities, making the escaped JSON valid again.
4. **Rendering:** `translateUI()` iterates `[data-i18n]` elements; `renderSection()` fills dynamic containers from the parsed data.

## Decisions

- **Single attribute over multiple attributes** — All 7 JSONs in one `data-data` attribute avoids multiple dataset lookups and keeps the HTML clean.
- **JSON.stringify at build time** — The stringification happens once per build, not on every page load. Client only parses.
- **Astro auto-escaping** — Astro's template escaping prevents XSS. The browser `dataset` auto-decodes, so `JSON.parse` receives valid JSON.

## Risks

- **Quotes and special characters** — If a JSON contains characters that break HTML attribute parsing (e.g., unescaped `"`), the page may not render. Astro's auto-escaping handles this.
- **Large payload** — Currently <50KB. If data grows to >500KB, consider splitting into multiple attributes or lazy loading.
