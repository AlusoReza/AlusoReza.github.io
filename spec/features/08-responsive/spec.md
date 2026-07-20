# 08 · Responsive

**Status:** implemented ✅

## What it does

Defines breakpoints and layout changes for all screen sizes. Desktop-first with media queries scaling down. The primary breakpoint is 1235px (sidebar/mobile switch), with secondary breakpoints at 650px/800px (MobileProfile internal layout) and 480px (smallest screens).

### 1235px — Sidebar / Mobile switch (primary)
| Element | Change |
|---------|--------|
| `.sidebar` | `position: fixed; transform: translateX(-100%); z-index: 9` — off-screen drawer |
| `.sidebar.open` | `transform: translateX(0)` — slide into view |
| `.sidebar-toggle` | `display: flex` — hamburger button appears |
| `.sidebar-inner` | `width: 100%; mask-image: none; overflow-y: auto` — full-width scrollable |
| `.content` | `margin-left: 0; --content-pad-top: max(56px, 4vh)` — full-width |
| `.lang-switcher-floating` | `position: fixed; top/right: 16px; z-index: 100` — floating top-right |
| `.sidebar-overlay` | `display: block; position: fixed; inset: 0` — dark backdrop |
| Sidebar sub-elements | Hide profile img, social, CV btn; hide name/desc on about page |
| Sidebar nav | Compact pill items (`gap: 2px; padding: 8px 12px`) |
| `.skills-personality-grid` | 1 column |

### 800px — MobileProfile row layout
| Element | Change |
|---------|--------|
| `.mobile-profile-inner--row` | `grid-template-columns: auto 1fr auto` — horizontal row layout |
| Photo | 200×225px |

### 650px — MobileProfile two-row layout
| Element | Change |
|---------|--------|
| `.mobile-profile-inner--row` | `grid-template-columns: 1fr` — stacked vertical |
| Photo | 100×125px |

### 480px — Smallest screens
| Element | Change |
|---------|--------|
| `.content` | `--content-pad-top: 56px; --content-pad-right/left: 16px` — tighter padding |
| `.about-skill-badge` | `font-size: 0.81rem; padding: 4px 11px` — smaller badges |

### Fade zone (1236–1336px) — CSS-driven sidebar fade
| Range | Behavior |
|-------|----------|
| ≥1336px | `--sidebar-fade: 1` — sidebar fully visible (desktop layout) |
| 1286–1336px | `--sidebar-fade` fades 1→0.55 — sidebar shrinks and fades |
| 1236–1285px | `--sidebar-fade` fades 0.55→0 — sidebar nearly invisible |
| ≤1235px | `--sidebar-fade: 0` — media query activates mobile layout |

**Snap behavior** (JS-driven, see `15-sidebar-architecture`):
- Stop at 1286–1336px → snap to 1 (full sidebar)
- Stop at 1236–1285px → snap to 0 + midpoint mode (mobile layout)
- During resize → `is-resizing` suppresses all transitions
- On mouseup → snap fires; 1000ms fallback timer for keyboard resize

## Why

The portfolio must be legible and functional on all screen sizes. Recruiters may view it on any device. The fade zone provides a smooth visual transition between desktop sidebar and mobile drawer.

## Acceptance criteria

- [x] At 1235px and below, sidebar becomes fixed-position drawer with hamburger toggle
- [x] Between 1236-1336px, sidebar fades smoothly via `--sidebar-fade` clamp
- [x] Stopping in fade zone snaps to nearest extreme (desktop or mobile)
- [x] MobileProfile appears above content on mobile (about page only)
- [x] At 650px/800px, MobileProfile switches between vertical and row layout
- [x] At 480px, padding reduces for smallest screens
- [x] No horizontal scroll on any screen width
- [x] `prefers-reduced-motion` disables all transitions

## Out of scope

- Tablet-specific layout (landscape) — treated as "small desktop".
- Print styles.
