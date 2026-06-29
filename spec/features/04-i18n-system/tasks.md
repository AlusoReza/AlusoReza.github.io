# 04 · i18n system — Tasks

- [x] Create `lang.json` with ES/EN translations for all static UI
- [x] Implement `translateUI()` in client.js
- [x] Implement `changeLanguage()` with localStorage persistence
- [x] Implement `t()` helper with fallback chain
- [x] Create LangSwitcher.astro with `data-lang` buttons
- [ ] Fix known bug: `init()` should call `renderAll()` if saved language is not ES
- [ ] Run `check-js-logic.ps1` to verify i18n compliance

## Maintenance

- [ ] When adding a new `data-i18n` key to HTML, add both ES and EN translations to `lang.json`
