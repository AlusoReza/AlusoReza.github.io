# 04 — Sistema i18n

## Propósito

Sistema de internacionalización (ES/EN) sin dependencias externas. Basado en atributos `data-i18n` + archivo `lang.json`.

## Componentes

### 1. Marcado HTML (`data-i18n`)
Los elementos traducibles llevan `data-i18n="clave"`. El valor de `clave` corresponde a una entrada en `lang.json`.

```astro
<h1 data-i18n="hero-title">Nombre (fallback ES)</h1>
```

### 2. Archivo de traducciones (`lang.json`)
```json
{
  "es": { "hero-title": "Alonso Suárez Reza" },
  "en": { "hero-title": "Alonso Suárez Reza" }
}
```

### 3. Helper `t()`
Para contenido dinámico renderizado desde JS:
```javascript
t({ es: "Hola", en: "Hello" })  // → "Hola" si lang=es, "Hello" si lang=en
```

### 4. Función `changeLanguage()`
```javascript
function changeLanguage(lang) {
  currentLang = lang;
  renderAll();             // re-renderiza todo
  localStorage.setItem('preferredLang', lang);
  document.documentElement.lang = lang;
}
```

### 5. Persistencia
El idioma se guarda en `localStorage` bajo la clave `preferredLang`. Default: `es`.

### 6. Botones de idioma
En `LangSwitcher.astro`:
```astro
<button data-lang="es">ES</button>
<button data-lang="en">EN</button>
```
`client.js` asigna eventos con `addEventListener`:
```javascript
document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang));
});
```

## Reglas
- **No usar `onclick`** — usar `data-lang` + `addEventListener`.
- **No duplicar contenido** — todo texto dinámico viene de los JSONs, no de los componentes.
- **Siempre incluir ambos idiomas** en campos bilingües.

## Código relevante
- `src/components/LangSwitcher.astro` — botones con `data-lang`
- `src/scripts/client.js:132-134` — addEventListener en [data-lang]
- `src/scripts/client.js:93-101` — changeLanguage()
- `src/data/lang.json` — diccionario de traducciones
