# Glosario — Alonso Suárez Reza Portfolio

## A
- **Astro 5**: Framework web estático (SSG) usado para construir el portfolio. Compila HTML en build-time y envía JS mínimo al cliente.
- **addEventListener**: Método JS estándar para asignar eventos. Reemplaza los `onclick` inline.

## B
- **Build-driven logging**: Estrategia de logging donde el `npm run build` es el trigger automático para revisar y completar el registro de sesión.

## C
- **changeLanguage()**: Función JS en `client.js` que cambia el idioma activo y re-renderiza todas las secciones dinámicas.

## D
- **data-data**: Atributo en `<body>` que serializa todos los JSONs del proyecto. Lectura vía `document.body.dataset.data`.
- **data-i18n**: Atributo HTML para marcado de elementos traducibles. El valor es la clave en `lang.json`.
- **data-lang**: Atributo en botones de idioma. `client.js` lo selecciona con `querySelectorAll('[data-lang]')`.

## E
- **ES**: Español (código de idioma).
- **EN**: Inglés (código de idioma).

## F
- **Frontend-design skill**: Skill de opencode con instrucciones de diseño frontend (paletas CSS, tipografía, sistema de espaciado, responsive).

## G
- **git diff**: Comando usado en el snapshot inicial y post-build para detectar cambios.

## I
- **i18n**: Internacionalización. Sistema de traducción basado en `data-i18n` + `lang.json`.

## J
- **JSON.stringify()**: Método usado en `BaseLayout.astro` para serializar el `dataBundle` en el atributo `data-data` del `<body>`.

## L
- **localStorage**: Almacenamiento del idioma preferido bajo la clave `preferredLang`. Default: `es`.

## M
- **MCP**: Model Context Protocol / Astro MCP. Conjunto de mejores prácticas de Astro 5 (eventos no inline, datos por atributos, sin globales).
- **motionOK**: Variable booleana en `client.js` que detecta `prefers-reduced-motion`. Si es `false`, se salta el scroll reveal.

## P
- **prefers-reduced-motion**: Media query CSS para accesibilidad. Detectado también en JS mediante `window.matchMedia()`.

## R
- **.reveal**: Clase CSS para animación de entrada con scroll. Tiene reset en `prefers-reduced-motion`.

## S
- **SDD**: Specification-Driven Development. Enfoque donde las especificaciones (`spec/`) son la fuente de verdad del proyecto.
- **set:html**: Directiva de Astro para renderizar HTML en elementos. Usada correctamente en componentes Astro (no en `<script>`).
- **Skill**: Plugin de opencode que provee instrucciones especializadas para tareas específicas (ej: `frontend-design`).

## T
- **t()**: Función helper que resuelve campos bilingües: `t({ es: "...", en: "..." })` → devuelve el valor del idioma actual.
- **toggleSection()**: Función JS que oculta/muestra secciones según si su array de datos está vacío.
