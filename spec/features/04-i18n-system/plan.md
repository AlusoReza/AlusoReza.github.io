# 04 · i18n system — Plan

## Approach

Static UI elements (nav, headings, contact text) use `data-i18n` attributes and are translated by `translateUI()`. Dynamic content (skills, projects, etc.) is re-rendered by `renderAll()` using the `t()` helper on each bilingual field.

## Implementation

1. **LangSwitcher.astro** renders two buttons with `data-lang="es"` and `data-lang="en"`.
2. **client.js** attaches click listeners: `document.querySelectorAll('[data-lang]').forEach(...)`.
3. **changeLanguage(lang):** sets `currentLang`, calls `renderAll()`, persists to localStorage, updates `document.documentElement.lang`.
4. **renderAll():** calls `translateUI()` for static elements + `renderSection()` for each dynamic section + `toggleSection()` for auto-hide sections.
5. **init():** on page load, reads saved language from localStorage and runs `translateUI()`.

## Decisions

- **data-i18n over class-based i18n** — Attributes are more semantic; the key is directly available via `el.dataset.i18n`.
- **Full re-render over targeted updates** — On language switch, `renderAll()` re-renders all dynamic sections. The sections are small enough that there's no performance concern, and it guarantees consistency.
- **localStorage over cookie** — Language preference is not sent to the server with every request (no server anyway).

## Risks

- **init() does not call renderAll()** — Currently `init()` only calls `translateUI()`, so visitors with EN saved see mixed ES/EN content in dynamic sections. **Known bug** (see bugs.md).
- **Missing lang.json keys** — If a key is missing from `lang.json`, `translateUI()` silently skips it (the `innerHTML` assignment is guarded by an existence check).
