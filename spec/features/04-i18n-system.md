# 04 — i18n system

## Purpose

Internationalization system (ES/EN) with no external dependencies. Based on `data-i18n` attributes + `lang.json` file.

## Components

### 1. HTML markup (`data-i18n`)
Translatable elements carry `data-i18n="key"`. The `key` value corresponds to an entry in `lang.json`.

```astro
<h1 data-i18n="hero-title">Name (ES fallback)</h1>
```

### 2. Translation file (`lang.json`)
```json
{
  "es": { "hero-title": "Alonso Suárez Reza" },
  "en": { "hero-title": "Alonso Suárez Reza" }
}
```

### 3. Helper `t()`
For dynamic content rendered from JS:
```javascript
t({ es: "Hola", en: "Hello" })  // → "Hola" if lang=es, "Hello" if lang=en
```

### 4. `changeLanguage()` function
```javascript
function changeLanguage(lang) {
  currentLang = lang;
  renderAll();             // re-renders everything
  localStorage.setItem('preferredLang', lang);
  document.documentElement.lang = lang;
}
```

### 5. Persistence
The language is saved in `localStorage` under the key `preferredLang`. Default: `es`.

### 6. Language buttons
In `LangSwitcher.astro`:
```astro
<button data-lang="es">ES</button>
<button data-lang="en">EN</button>
```
`client.js` assigns events with `addEventListener`:
```javascript
document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang));
});
```

## Rules
- **Do not use `onclick`** — use `data-lang` + `addEventListener`.
- **Do not duplicate content** — all dynamic text comes from JSONs, not from components.
- **Always include both languages** in bilingual fields.

## Relevant code
- `src/components/LangSwitcher.astro` — buttons with `data-lang`
- `src/scripts/client.js:132-134` — addEventListener on [data-lang]
- `src/scripts/client.js:93-101` — changeLanguage()
- `src/data/lang.json` — translation dictionary
