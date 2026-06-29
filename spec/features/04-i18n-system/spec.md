# 04 · i18n system

**Status:** implemented ✅

## What it does

Internationalization system (ES/EN) with no external dependencies. Based on `data-i18n` attributes + `lang.json` file.

### Components
1. **HTML markup (`data-i18n`)** — Translatable elements carry `data-i18n="key"`. Key corresponds to `lang.json` entry.
2. **Translation file (`lang.json`)** — `{ "es": { "key": "..." }, "en": { "key": "..." } }`.
3. **Helper `t()`** — Resolves bilingual fields dynamically: `t({ es: "Hola", en: "Hello" })`.
4. **`changeLanguage()`** — Re-renders all sections, persists to `localStorage`, sets `document.documentElement.lang`.
5. **Persistence** — Language saved in `localStorage` under `preferredLang` key. Default: `es`.
6. **Language buttons** — ES/EN buttons with `data-lang` attributes. Events assigned via `addEventListener`.

## Why

A bilingual portfolio (Spanish/English) requires a lightweight i18n solution. Using `data-i18n` attributes + a small JS function avoids any framework dependency and keeps the translation logic transparent.

## Acceptance criteria

- [ ] Switching language re-renders all dynamic sections (skills, projects, education, experience, certificates).
- [ ] Language persists across page reloads (`localStorage`).
- [ ] No `onclick` handlers — all events via `data-lang` + `addEventListener`.
- [ ] `document.documentElement.lang` is set to current language.
- [ ] `t()` returns the correct language value, with fallback to ES, then EN, then empty string.

## Out of scope

- Right-to-left (RTL) language support.
- Runtime translation file loading — all translations are in the initial data bundle.
- Pluralization or gender-specific translations.
