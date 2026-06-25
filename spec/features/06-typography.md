# 06 — Tipografía

## Propósito

Define el sistema tipográfico del portfolio.

## Fuentes

### Display: Space Grotesk
- **Propósito:** Títulos, nombre del perfil, badges, labels de skills/educación.
- **Carácter:** Técnico, geométrico, evoca matemáticas y código.
- **Pesos:** 400, 500, 600, 700.
- **Carga:** Google Fonts vía `<link>` en `<head>` de `BaseLayout.astro`.

### Body: Inter
- **Propósito:** Texto de párrafos, descripciones, navegación.
- **Carácter:** Optimizada para pantalla, excelente legibilidad en pesos ligeros.
- **Pesos:** 400, 500, 600, 700.
- **Variable CSS:** `--font-body`.

## Jerarquía

| Elemento | Font | Tamaño | Peso |
|----------|------|--------|------|
| h1 (nombre) | `--font-display` | 2.5em | 600 |
| h2 (secciones) | `--font-display` | — | 600 |
| .subtitle | `--font-body` | 1.1em | — |
| body | `--font-body` | — | 400 |
| .badge | `--font-display` | 0.8em | 600 |
| .skill-item strong | `--font-display` | — | 600 |
| .edu-header strong | `--font-display` | 1.15em | 600 |
| nav a | `--font-body` | 0.85em | 500 |

## Reglas
- **No mezclar fuentes** en el mismo contexto. Display para títulos, body para texto.
- **Cargar con `display=swap`** para evitar FOIT (Flash of Invisible Text).

## Código relevante
- `src/styles/global.css:12-13` — declaración de variables de fuente
- `src/styles/global.css:22` — font-family en body
- `src/styles/global.css:37` — font-family en h2
- `src/layouts/BaseLayout.astro:30-32` — Google Fonts <link>
