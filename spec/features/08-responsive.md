# 08 — Responsive

## Purpose

Defines breakpoints and layout changes for mobile devices.

## Breakpoints

### 650px — Tablet / Large mobile
| Element | Change |
|---------|--------|
| `.profile-header` | Flex column, centered |
| `.profile-img` | 180x185px, centered |
| `.skills-grid` | 1 column |
| `.badges-wrapper` | Centered, gap 5px |
| `.badge` | Font-size 0.85em |
| `.cv-cta-button` | Width 100%, max-width none |
| `.edu-header` | Flex column, left-aligned |
| `nav a` | Font-size 0.75em, reduced margin |
| h1 | Font-size 2em |
| `.nav-container` | Padding-right 80px (space for lang switcher) |
| `#inicio` | Padding 20px, background-size 20px |
| `.lang-switcher` | Top 10px, right 10px |

### 480px — Small mobile
| Element | Change |
|---------|--------|
| `.social-btns` | Flex column, centered |
| `.social-btns a` | Min-width 0, width 100%, max-width 280px |
| `nav a` | Font-size 0.7em, margin 0 4px |

## Rules
- Mobile-first: the base layout is desktop, media queries scale down.
- Do not duplicate properties between media queries of the same breakpoint.

## Relevant code
- `src/styles/global.css:104-118` — nav responsive (650px)
- `src/styles/global.css:173-178` — hero responsive (650px)
- `src/styles/global.css:287-292` — CV button responsive (650px)
- `src/styles/global.css:625-679` — profile, skills, badges responsive (650px)
- `src/styles/global.css:681-695` — social, nav (480px)
- `src/styles/global.css:732-738` — lang switcher (650px)
