# 02 · Data contracts — Plan

## Approach

Content-driven design: all section data lives in JSON files under `src/data/`. The `t()` helper provides safe bilingual resolution with graceful fallback.

## Implementation

1. Define each JSON with required and optional fields following the bilingual pattern.
2. All JSONs are statically imported in `BaseLayout.astro`.
3. `t()` helper in `client.js` resolves fields: checks current language, falls back to ES, then EN, then empty string.
4. `toggleSection()` hides sections if their data array is empty.

## Decisions

- **No `url` field in certificates** — PDFs are stored locally in `docs/certificates/` (gitignored) and served directly; URLs would break if the file is moved.
- **Plain strings for non-translatable fields** — project names (e.g., "Dockers-Image-Creator") don't change between languages. Using bilingual format for them would add noise.
- **`t()` fallback chain** — `currentLang → es → en → ''` ensures graceful degradation when a field is missing in one language.
- **Static imports over dynamic fetch** — aligns with Architecture (feature 01): no runtime HTTP requests.

## Risks

- **Missing language** — if a bilingual field only has `es`, the `t()` fallback still works, but EN visitors see Spanish. Mitigated by tests (`check-json-schema.ps1`).
- **Accidental `url` in certificates** — tests enforce the prohibition (`check-json-schema.ps1`).
