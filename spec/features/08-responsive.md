# 08 — Responsive

## Propósito

Define los puntos de quiebre y los cambios de layout para dispositivos móviles.

## Breakpoints

### 650px — Tablet / Móvil grande
| Elemento | Cambio |
|----------|--------|
| `.profile-header` | Flex column, centrado |
| `.profile-img` | 180x185px, centrado |
| `.skills-grid` | 1 columna |
| `.badges-wrapper` | Centrado, gap 5px |
| `.badge` | Font-size 0.85em |
| `.cv-cta-button` | Width 100%, max-width none |
| `.edu-header` | Flex column, alineado a la izquierda |
| `nav a` | Font-size 0.75em, margin reducido |
| h1 | Font-size 2em |
| `.nav-container` | Padding-right 80px (espacio para lang switcher) |
| `#inicio` | Padding 20px, background-size 20px |
| `.lang-switcher` | Top 10px, right 10px |

### 480px — Móvil pequeño
| Elemento | Cambio |
|----------|--------|
| `.social-btns` | Flex column, centrado |
| `.social-btns a` | Min-width 0, width 100%, max-width 280px |
| `nav a` | Font-size 0.7em, margin 0 4px |

## Reglas
- Mobile-first: el layout base es desktop, los media queries reducen.
- No duplicar propiedades entre media queries del mismo breakpoint.

## Código relevante
- `src/styles/global.css:104-118` — nav responsive (650px)
- `src/styles/global.css:173-178` — hero responsive (650px)
- `src/styles/global.css:287-292` — CV button responsive (650px)
- `src/styles/global.css:625-679` — perfil, skills, badges responsive (650px)
- `src/styles/global.css:681-695` — social, nav (480px)
- `src/styles/global.css:732-738` — lang switcher (650px)
