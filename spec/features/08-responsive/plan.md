# 08 · Responsive — Plan

## Approach

Desktop-first base layout with multiple `@media (max-width: ...)` breakpoints plus a CSS-driven fade zone for the sidebar transition. The desktop layout is the full experience; mobile versions remove or simplify elements.

## Implementation

1. **global.css** defines the full desktop layout as the default (no `@media` wrapper).
2. **Fade zone (1236–1336px):** `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)` drives sidebar opacity, width, and flex simultaneously. No media query involvement.
3. **@media (max-width: 1235px)** — Sidebar becomes fixed-position drawer, hamburger toggle appears, content goes full-width, overlay activates.
4. **@media (max-width: 800px)** — MobileProfile switches to row layout (3 columns).
5. **@media (max-width: 650px)** — MobileProfile switches to vertical layout.
6. **@media (max-width: 480px)** — Tighter padding, smaller badges.
7. **JS midpoint mode** — `sidebar-midpoint-mode` class duplicates `@media (max-width:1235px)` rules for the 1236-1285px range, activated by `snapSidebarFade()` on mouseup.

## Decisions

- **Desktop-first over mobile-first** — The portfolio is a showcase site, most viewers use desktop. Mobile is the adapted version.
- **1235px primary breakpoint** — Calculated from sidebar content area minimum (CV button needs ~210px → `17vw = 210px → viewport = 1235px`).
- **100px fade zone** — Provides smooth visual transition without layout jump. The `clamp()` formula linearly interpolates over 100px.
- **Midpoint at 1286px** — Halfway through the fade zone. Above = snap to desktop. Below = snap to mobile.
- **`mouseup` snap trigger** — OS window resize captures mouse, making `pointerdown`/`pointerup` unreliable. `mouseup` on `document` is the best available signal, with 1000ms fallback timer.
- **`sidebar-midpoint-mode` CSS duplication** — Duplicates `@media (max-width:1235px)` rules under a class selector. Required because CSS media queries cannot be activated via JS. ~140 lines of CSS.

## Risks

- **`mouseup` may not fire for OS window resize on all platforms** — Fallback timer (1000ms) covers this case.
- **`sidebar-midpoint-mode` CSS duplication** — Must be kept in sync with media query rules. Any change to mobile layout requires updating both blocks.
