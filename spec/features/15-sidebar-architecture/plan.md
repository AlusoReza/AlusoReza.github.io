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

## Risks

- **CSS duplication:** `sidebar-midpoint-mode` must mirror `@media (max-width:1235px)`. Any change to mobile layout requires updating both.
- **`mouseup` reliability:** May not fire for OS window resize on all platforms. Fallback timer covers this.
- **1234px vs 1235px gap:** `mqlBreakpoint` (1234px) and `mql` (1235px) are 1px apart. This is intentional: `mql` handles the media query flash, `mqlBreakpoint` handles MobileProfile sequencing.
