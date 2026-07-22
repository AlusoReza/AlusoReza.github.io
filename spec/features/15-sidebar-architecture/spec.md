# 15 · Sidebar Architecture

**Status:** implemented ✅

## What it does

Manages the sidebar's transition between desktop (fixed column) and mobile (off-screen drawer) layouts. The system uses a CSS-driven fade zone with JS orchestration for snap behavior, sequential animations, and page-load initialization.

## Core mechanism

### CSS variable: `--sidebar-fade`

```
--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)
```

This single CSS variable drives three sidebar properties simultaneously:
- `opacity: var(--sidebar-fade)` — visual fade
- `flex: 0 0 calc(var(--sidebar-width) * var(--sidebar-fade))` — layout space
- `width: calc(var(--sidebar-width) * var(--sidebar-fade))` — explicit width

The clamp formula linearly interpolates from 0 to 1 over a 100px viewport range (1236px → 1336px).

### Fade zone ranges

| Viewport | `--sidebar-fade` | Behavior |
|----------|------------------|----------|
| ≥1336px | 1 | Sidebar fully visible (desktop) |
| 1286–1336px | 0.55–1 | Sidebar shrinks and fades |
| 1236–1285px | 0–0.55 | Sidebar nearly invisible |
| ≤1235px | 0 | Media query activates mobile layout |

### Media query: `@media (max-width: 1235px)`

At ≤1235px, the sidebar switches from `position: relative` (flex child) to `position: fixed` (off-screen drawer):
- `transform: translateX(-100%)` — hidden off-screen left
- `.sidebar.open` → `transform: translateX(0)` — slides into view
- Hamburger toggle (`.sidebar-toggle`) appears
- Dark overlay (`.sidebar-overlay`) activates
- Content goes full-width (`margin-left: 0`)

## JS state classes

All classes are applied to `<html>`.

### `sidebar-locked`
- **Purpose:** Freezes `--sidebar-fade` at 0 during MobileProfile slide-in animation
- **CSS:** `--sidebar-fade: 0; transition: none !important` on sidebar + sidebar-inner
- **Duration:** 350ms (set by `handleMobileProfile()`)
- **Trigger:** Shrinking past 1235px (`mqlBreakpoint`)

### `sidebar-delayed`
- **Purpose:** Delays sidebar transitions 350ms while MobileProfile collapses
- **CSS:** `flex: 0 0 0 !important; width: 0 !important; opacity: 0 !important`
- **Duration:** 350ms
- **Trigger:** Growing past 1235px (`mqlBreakpoint`)

### `sidebar-no-transition`
- **Purpose:** Suppresses CSS transitions for 2 rAF frames (~33ms)
- **CSS:** `transition: none !important` on sidebar + sidebar-inner
- **Trigger:** Media query change (1235px crossing) or snap entry

### `is-resizing`
- **Purpose:** Suppresses all sidebar transitions during active viewport resize
- **CSS:** `transition: none !important` on sidebar + sidebar-inner + overlay
- **Duration:** Until mouseup or 1000ms fallback timer
- **Trigger:** Every `resize` event

### `sidebar-midpoint-mode`
- **Purpose:** Activates mobile layout in the 1236–1285px range (below midpoint)
- **CSS:** Duplicates all essential `@media (max-width:1235px)` rules (~140 lines)
- **Duration:** Until next resize event or snap
- **Trigger:** `snapSidebarFade()` when viewport is in 1236–1285px

### `sidebar-init-mobile` / `sidebar-init-desktop`
- **Purpose:** Prevents flash when page loads in the fade zone (1236–1336px)
- **CSS:** `--sidebar-fade: 0` / `--sidebar-fade: 1`
- **Duration:** Until first resize event (`{ once: true }`)
- **Trigger:** `init()` when `window.innerWidth` is in fade zone

## JS functions

### `snapSidebarFade()`
Called on mouseup or 1000ms fallback timer. Three branches:
1. **1286–1336px:** Remove midpoint mode, set `--sidebar-fade: 1` (snap to desktop)
2. **1236–1285px:** Add `sidebar-no-transition` for 2 frames, set `--sidebar-fade: 0`, add `sidebar-midpoint-mode`, add `lang-switcher-delayed` (340ms → `lang-switcher-reveal`), schedule `snapProfileTimer` (350ms) to call `animateMobileProfile(true)` if midpoint mode still active
3. **Outside fade zone:** Remove midpoint mode, remove inline `--sidebar-fade`

### `handleMobileProfile()`
Orchestrates sequential animations when crossing the 1235px breakpoint:
- **Growing past 1235px:** Add `sidebar-delayed` (350ms), hide MobileProfile via `animateMobileProfile(false)`, then remove `sidebar-delayed` + `is-resizing` + call `snapSidebarFade()`
- **Shrinking past 1235px:** Add `sidebar-locked` (350ms), show MobileProfile via `animateMobileProfile(true)`

### `updateMobileProfile()`
Shows/hides MobileProfile based on:
- `mqlBreakpoint.matches` (≤1235px) OR `sidebar-midpoint-mode` active
- `currentPage === 'sobre'`
- Clears all 3 timers (`mobileProfileTimer`, `snapProfileTimer`, `adjustTimer`) on call

### `animateMobileProfile(show, duration = 350)`
JS-driven height animation for MobileProfile:
- **Show:** Measure `scrollHeight`, set explicit px height, transition to target, micro-adjust if >2px diff after main animation
- **Hide:** Capture current height, transition to 0, cleanup
- Clears all 3 timers on call. Uses `mobileProfileTimer` for main animation, `adjustTimer` for micro-adjustment.

## Event flow

### Resize (during drag)
1. Remove inline `--sidebar-fade` → CSS clamp takes over
2. Add `is-resizing` → suppress all transitions
3. If was in midpoint mode → remove it, hide MobileProfile instantly (only if `window.innerWidth > 1235`)

### Mouseup (snap)
1. Clear fallback timer
2. Remove `is-resizing` → transitions re-enable
3. Call `snapSidebarFade()` → snap to nearest extreme

### `snapSidebarFade()` midpoint entry
1. Add `sidebar-no-transition` for 2 frames
2. Set `--sidebar-fade: 0` inline
3. Add `sidebar-midpoint-mode`
4. Add `lang-switcher-delayed` (340ms fade-in)
5. Schedule `snapProfileTimer` (350ms) → `animateMobileProfile(true)` if midpoint mode still active

### Page load in fade zone
1. Add `sidebar-init-mobile` or `sidebar-init-desktop` → prevent flash
2. If below midpoint: also add `sidebar-no-transition` + `sidebar-midpoint-mode`
3. Delayed `updateMobileProfile()` at 350ms
4. First resize event removes all init classes

## CSS location

- **State classes** (`sidebar-locked`, `sidebar-delayed`, `sidebar-no-transition`, `is-resizing`): `global.css` lines 54–82
- **Init classes** (`sidebar-init-mobile/desktop`): `global.css` line 68–69
- **Midpoint mode** (`sidebar-midpoint-mode`): `global.css` lines 1282–1460
- **Base sidebar**: `global.css` lines 453–468
- **Mobile media query**: `global.css` lines 1530–1575
- **MobileProfile base**: `global.css` lines 242–256 (`height: 0`, opacity transition)

## Why

The sidebar is the primary navigation element. The fade zone provides a smooth visual transition between desktop and mobile layouts without jarring layout jumps. The sequential animation system (sidebar first, then MobileProfile) prevents overlapping elements during the transition.

## Acceptance criteria

- [x] Sidebar fades smoothly between 1236–1336px via `--sidebar-fade`
- [x] At ≤1235px, sidebar switches to fixed-position drawer with hamburger
- [x] Stopping in fade zone snaps to nearest extreme (desktop or mobile)
- [x] MobileProfile appears/disappears in correct sequence with sidebar
- [x] Page load in fade zone shows correct layout without flash
- [x] During resize, sidebar follows clamp() smoothly with no jitter
- [x] `prefers-reduced-motion` disables all sidebar transitions

## Out of scope

- Light theme sidebar variant
- Sidebar width customization beyond `--sidebar-width`
- Multi-level navigation
