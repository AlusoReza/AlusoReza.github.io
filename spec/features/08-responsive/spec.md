# 08 · Responsive

**Status:** implemented ✅

## What it does

Defines breakpoints and layout changes for mobile devices. Two breakpoints: 650px (tablet/large mobile) and 480px (small mobile). The base layout is desktop-first with media queries scaling down.

### 650px — Tablet / Large mobile
| Element | Change |
|---------|--------|
| `.profile-header` | Flex column, centered |
| `.profile-img` | 180x185px, centered |
| `.skills-grid` | 1 column |
| `.badges-wrapper` | Centered, gap 5px |
| `.badge` | Font-size 0.85em, padding reduced |
| `.cv-cta-button` | Width 100%, max-width none |
| `.edu-header` | Flex column, left-aligned |
| `nav a` | Font-size 0.75em, reduced margin |
| `h1` | Font-size 2em |
| `.nav-container` | Padding-right 80px (space for lang switcher) |
| `#inicio` | Padding 20px, background-size 20px |
| `.lang-switcher` | Top 10px, right 10px |

### 480px — Small mobile
| Element | Change |
|---------|--------|
| `.social-btns` | Flex column, centered |
| `.social-btns a` | Min-width 0, width 100%, max-width 280px |
| `nav a` | Font-size 0.7em, margin 0 4px |

## Why

The portfolio must be legible and functional on all screen sizes. Recruiters may view it on any device.

## Acceptance criteria

- [ ] At 650px and below, profile switches to column layout, skills go to 1 column, nav compresses.
- [ ] At 480px and below, social buttons stack vertically.
- [ ] Language switcher is fixed-position and visible on all screen sizes.
- [ ] No horizontal scroll on any screen width.
- [ ] CV button is full-width on mobile.

## Out of scope

- Tablet-specific layout (landscape) — treated as "small desktop".
- Print styles.
