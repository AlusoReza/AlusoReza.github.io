# 01 — Arquitectura

## Propósito

Define la arquitectura two-phase del portfolio: renderizado estático en build-time (Astro) + hidratación dinámica en cliente (JS vanilla).

## Fases

### Fase 1: Build-time (Astro)
- Astro compila todos los `.astro` a HTML estático.
- El layout `BaseLayout.astro` serializa los 7 JSONs de `src/data/` en un objeto `dataBundle` mediante `JSON.stringify()`.
- Este string se inyecta como atributo `data-data` en la etiqueta `<body>`.
- Los componentes renderizan el contenido en español por defecto.
- Las secciones con arrays vacíos (`experience`, `certificates`) reciben `style="display:none"`.

### Fase 2: Client-side (browser)
- `client.js` se carga como script externo (bundled por Astro).
- Lee `JSON.parse(document.body.dataset.data)` — el navegador decodifica HTML entities automáticamente.
- Carga el idioma guardado de `localStorage`.
- Si el idioma no es español, ejecuta `changeLanguage()` que re-renderiza todas las secciones.

## Flujo de datos

```
src/data/*.json
    → BaseLayout.astro los importa y serializa
    → <body data-data={JSON.stringify({...})}>
    → client.js: JSON.parse(document.body.dataset.data)
    → renderAll() / changeLanguage()
```

## Reglas
- **No usar fetch() para cargar JSONs en cliente** — todo viaja en el `data-data`.
- **No usar `<script is:inline set:html>`** — los datos van en el atributo HTML.
- **No exponer `window.DATA`** — los datos son accesibles solo desde `document.body.dataset.data`.

## Código relevante
- `src/layouts/BaseLayout.astro:13-14` — serialización del dataBundle
- `src/layouts/BaseLayout.astro:35` — `<body data-data={dataBundle}>`
- `src/scripts/client.js:1` — `JSON.parse(document.body.dataset.data)`
