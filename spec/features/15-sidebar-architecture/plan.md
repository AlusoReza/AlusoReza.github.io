# 15 · Sidebar Architecture — Plan

## Approach

CSS-driven sidebar fade via a single `clamp()` variable, with JS orchestration for snap behavior, sequential animations, and state management. The CSS handles the continuous fade; the JS handles the discrete state transitions (snap, midpoint mode, MobileProfile sequencing).

## Architecture decisions

### CSS-only fade (Sessions 26–27)
The `--sidebar-fade` variable drives opacity, width, and flex simultaneously. This ensures the sidebar shrinks and fades in sync without any JS involvement during normal resize. The `clamp()` formula provides linear interpolation over 100px.

### Sequential animations (Sessions 63–66)
When crossing the 1234px breakpoint, two things must happen in order:
1. MobileProfile collapses/expands (350ms)
2. Sidebar appears/disappears (after MobileProfile finishes)

`sidebar-locked` freezes the sidebar during MobileProfile slide-in. `sidebar-delayed` delays sidebar transitions during MobileProfile collapse. This prevents overlapping elements.

### Midpoint mode (Session 87)
The CSS media query at 1235px creates a dead zone (1236–1285px) where the sidebar is nearly invisible but the mobile layout isn't active. `sidebar-midpoint-mode` duplicates the media query rules under a class selector, allowing JS to activate mobile layout in this range.

**Trade-off:** ~140 lines of CSS duplication. Must be kept in sync with `@media (max-width:1235px)` rules.

### Snap on mouseup (Session 87)
OS window resize captures the mouse, making `pointerdown`/`pointerup` unreliable. `mouseup` on `document` is the best available signal. A 1000ms fallback timer covers keyboard resize and cases where `mouseup` doesn't fire.

### Init classes (Session 87)
When the page loads in the fade zone, `sidebar-init-mobile/desktop` prevent a flash by setting `--sidebar-fade` before the first paint. `sidebar-midpoint-mode` is also added for loads in the lower half.

### JS-driven height animation (Session 109)
CSS `height: auto → 0` is not transitionable. `grid-template-rows: 0fr/1fr` was overridden by flex `min-height: auto` on PC. Solution: `animateMobileProfile()` with explicit `scrollHeight` measurement and px height transitions. `height: 0` on `.mobile-profile` CSS base state ensures PC layout stability.

### `animateMobileProfile()` in `snapSidebarFade()` (Session 110)
`snapSidebarFade()` midpoint branch calls `animateMobileProfile(true)` instead of `updateMobileProfile()` to provide smooth animation when stopping resize at midpoint.

### Breakpoint alignment (Session 112)
CSS `@media (max-width: 1235px)` and JS `mqlBreakpoint` must be aligned. Changed `mqlBreakpoint` from 1234px to 1235px. Added `window.innerWidth > 1235` guard in resize handler. Adjusted `sidebar-delayed` timer from 400ms to 350ms.

### Timer architecture (Session 113)
Three named timers (`mobileProfileTimer`, `snapProfileTimer`, `adjustTimer`) prevent race conditions. All cleared in `updateMobileProfile()`, `animateMobileProfile()`, and resize handler. `snapProfileTimer` stores the midpoint snap callback (was fire-and-forget). Micro-adjustment: re-measure after main animation, smooth 150ms adjust if >2px diff.

### Dead zone fix via `snapSidebarFade()` call (Session 114)
`handleMobileProfile()` growing path now calls `snapSidebarFade()` instead of manually managing sidebar state. Eliminates `clearTimeout(resizeTimer)` that killed the 1000ms fallback timer. Ensures `sidebar-midpoint-mode` is always added when entering 1236-1285px range.

### `snapProfileTimer` gated on midpoint mode (Session 115-116)
`snapProfileTimer` callback checks `sidebar-midpoint-mode` before calling `animateMobileProfile(true)`. Prevents re-expanding mobile profile that `handleMobileProfile()` just collapsed on slow resize.

## Implementation sequence

1. **Session 26:** Created `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)`
2. **Session 27:** Synced sidebar width with `--sidebar-fade` via `calc()`
3. **Session 28:** Added `.sidebar-inner` with `mask-image` gradient
4. **Session 36:** Synced lang-switcher opacity with `--sidebar-fade`
5. **Session 40:** Added `is-resizing` debounce, `matchMedia` listener
6. **Session 63:** Added `sidebar-locked` for sequential animations
7. **Session 66:** Added `sidebar-locked` in both directions
8. **Session 85:** Removed snap system, made sidebar CSS-only
9. **Session 86:** Added `sidebar-no-transition` for breakpoint flash fix
10. **Session 87:** Added `snapSidebarFade()`, midpoint mode, mouseup snap
11. **Session 109:** JS-driven `animateMobileProfile()` replaces CSS grid animation
12. **Session 110:** `snapSidebarFade()` calls `animateMobileProfile(true)` at midpoint
13. **Session 112:** Aligned `mqlBreakpoint` to 1235px, completed midpoint mode, adjusted timers
14. **Session 113:** Timer architecture (3 named timers), micro-adjustment, `snapProfileTimer`
15. **Session 114:** Dead zone fix via `snapSidebarFade()` call in `handleMobileProfile()`
16. **Session 115-116:** `snapProfileTimer` gated on `sidebar-midpoint-mode`

## Risks

- **CSS duplication:** `sidebar-midpoint-mode` must mirror `@media (max-width:1235px)`. Any change to mobile layout requires updating both.
- **`mouseup` reliability:** May not fire for OS window resize on all platforms. Fallback timer covers this.
- **Timer race conditions:** 3 named timers must be cleared in all code paths that modify mobile profile state. See `code-decisions.md` #11.
- **`snapProfileTimer` timing:** 350ms delay must be long enough for `handleMobileProfile()` to complete its collapse before re-expanding. Gated on `sidebar-midpoint-mode` as safety net.
