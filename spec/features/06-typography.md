# 06 — Typography

## Purpose

Defines the typographic system of the portfolio.

## Fonts

### Display: Space Grotesk
- **Purpose:** Titles, profile name, badges, skill/education labels.
- **Character:** Technical, geometric, evokes math and code.
- **Weights:** 400, 500, 600, 700.
- **Loading:** Google Fonts via `<link>` in `<head>` of `BaseLayout.astro`.

### Body: Inter
- **Purpose:** Paragraph text, descriptions, navigation.
- **Character:** Optimized for screen, excellent readability at light weights.
- **Weights:** 400, 500, 600, 700.
- **CSS Variable:** `--font-body`.

## Hierarchy

| Element | Font | Size | Weight |
|---------|------|------|--------|
| h1 (name) | `--font-display` | 2.5em | 600 |
| h2 (sections) | `--font-display` | — | 600 |
| .subtitle | `--font-body` | 1.1em | — |
| body | `--font-body` | — | 400 |
| .badge | `--font-display` | 0.8em | 600 |
| .skill-item strong | `--font-display` | — | 600 |
| .edu-header strong | `--font-display` | 1.15em | 600 |
| nav a | `--font-body` | 0.85em | 500 |

## Rules
- **Do not mix fonts** in the same context. Display for titles, body for text.
- **Load with `display=swap`** to avoid FOIT (Flash of Invisible Text).

## Relevant code
- `src/styles/global.css:12-13` — font variable declarations
- `src/styles/global.css:22` — font-family on body
- `src/styles/global.css:37` — font-family on h2
- `src/layouts/BaseLayout.astro:30-32` — Google Fonts <link>
