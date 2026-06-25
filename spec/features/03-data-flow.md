# 03 — Flujo de datos

## Propósito

Describe el recorrido completo de los datos desde los JSONs hasta el renderizado en el navegador.

## Pipeline

```
1. src/data/*.json (7 archivos)
        │ Importación estática en BaseLayout.astro
        ▼
2. BaseLayout.astro
        │ const dataBundle = JSON.stringify({ lang, skills, ... })
        │ Inyección: <body data-data={dataBundle}>
        ▼
3. HTML estático (build-time de Astro)
        │ El atributo data-data contiene TODOS los datos escapados
        ▼
4. Navegador
        │ Carga del HTML
        │ El DOM auto-decodifica HTML entities en el dataset
        ▼
5. client.js
        │ const DATA = JSON.parse(document.body.dataset.data)
        │ DATA.lang, DATA.skills, DATA.education, etc.
        ▼
6. Render
        │ translateUI() aplica data-i18n
        │ renderSection() rellena contenedores dinámicos
        │ toggleSection() oculta arrays vacíos
```

## Ventajas

- **0 peticiones HTTP** extra para datos (todo viaja en el HTML inicial).
- **Sin vulnerabilidades XSS** — Astro escapa el string automáticamente en el template.
- **Sin globales** — los datos no contaminan `window`.
- **Instantáneo** — el cliente no necesita esperar fetch().

## Decisión de diseño

Se descartó:
- **fetch() a JSONs estáticos**: latencia extra, complejidad de estado de carga.
- **`<script is:inline set:html>`**: Astro desaconseja para datos dinámicos, mezcla lógica y presentación.
- **`Astro.serialize()`**: API que no existe en Astro 5.

## Código relevante
- `src/layouts/BaseLayout.astro:14` — `JSON.stringify()`
- `src/layouts/BaseLayout.astro:35` — `data-data` en `<body>`
- `src/scripts/client.js:1` — `JSON.parse(document.body.dataset.data)`
