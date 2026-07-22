# Code decisions — Alonso Suarez Reza Portfolio

Critical code decisions in `client.js` and `global.css`. Each entry documents what was decided, why, what bug it fixes, and what happens if reverted.

## 1. `sidebar-no-transition` double rAF technique
- **File:** `src/scripts/client.js` L806-810, `src/styles/global.css` L76-82
- **Session:** 86
- **Decision:** Suppress CSS transitions for 2 rAF frames (~33ms) when the 1235px media query changes, using `sidebar-no-transition` class.
- **Bug fixed:** Sidebar panel flashes on top of all content when resizing past 1235px. The `transition: transform 0.3s ease` in the media query animates `none → translateX(-100%)` over 0.3s, leaving sidebar visible at opacity:1 during the transition.
- **Revert consequence:** Sidebar flash returns on every 1235px crossing.

## 2. `mqlBreakpoint` aligned to 1235px
- **File:** `src/scripts/client.js` L490
- **Session:** 112
- **Decision:** `mqlBreakpoint = window.matchMedia('(max-width: 1235px)')` — aligned with CSS `@media (max-width: 1235px)`.
- **Bug fixed:** 1px misalignment between CSS (1235px) and JS (1234px) caused: mobile profile missing at 1235px on initial load, flash on resize 1236→1235px, midpoint mode missing 7 sidebar rules.
- **Revert consequence:** 1px dead zone returns. Mobile profile disappears at wrong breakpoint.

## 3. `animateMobileProfile()` in `snapSidebarFade()` midpoint branch
- **File:** `src/scripts/client.js` L857
- **Session:** 110
- **Decision:** `snapSidebarFade()` midpoint branch calls `animateMobileProfile(true)` instead of `updateMobileProfile()`.
- **Bug fixed:** When stopping resize at ~1250px (midpoint zone), mobile profile appeared instantly without animation.
- **Revert consequence:** Midpoint entry loses animation — profile pops in instantly.

## 4. `window.innerWidth > 1235` guard in resize handler
- **File:** `src/scripts/client.js` L875
- **Session:** 112
- **Decision:** Resize handler checks `window.innerWidth > 1235` before hiding mobile profile when leaving midpoint mode.
- **Bug fixed:** Mobile profile was hidden even when viewport was still in mobile territory (<1235px), causing flicker.
- **Revert consequence:** Mobile profile flickers on resize within mobile range.

## 5. JS-driven height animation (not CSS `grid-template-rows`)
- **File:** `src/scripts/client.js` L519-562
- **Session:** 109
- **Decision:** Use `animateMobileProfile(show, duration)` with explicit `scrollHeight` measurement and px height transitions, instead of CSS `grid-template-rows: 0fr/1fr`.
- **Bug fixed:** `height: auto → 0` is not transitionable. `grid-template-rows` was overridden by flex `min-height: auto` on PC.
- **Revert consequence:** Mobile profile animation breaks — no height transition on resize.

## 6. `height: 0` base state on `.mobile-profile`
- **File:** `src/styles/global.css` L242
- **Session:** 109
- **Decision:** `.mobile-profile` has `height: 0` in CSS base state (PC layout). JS drives height via inline styles.
- **Bug fixed:** Without explicit `height: 0`, the element takes space in PC flex layout even when hidden.
- **Revert consequence:** Mobile profile pushes content down on PC layouts.

## 7. `sidebar-midpoint-mode` CSS class (~140 lines duplication)
- **File:** `src/styles/global.css` L1282-1460
- **Session:** 87
- **Decision:** Duplicate all essential `@media (max-width:1235px)` rules under `html.sidebar-midpoint-mode` selector.
- **Bug fixed:** Dead zone (1236-1285px) where sidebar is nearly invisible but mobile layout isn't active.
- **Revert consequence:** Sidebar stuck at ~0% fade in 1236-1285px range. Mobile layout never activates in midpoint.
- **Trade-off:** ~140 lines of CSS duplication. Must be kept in sync with `@media (max-width:1235px)` rules.

## 8. `sidebar-locked` `!important` freeze
- **File:** `src/styles/global.css` L54-66
- **Session:** 63-66
- **Decision:** `html.sidebar-locked { --sidebar-fade: 0; transition: none !important }` on sidebar + sidebar-inner.
- **Bug fixed:** Sidebar appeared during MobileProfile slide-in animation, creating overlapping elements.
- **Revert consequence:** Sidebar and MobileProfile overlap during transitions.

## 9. `sidebar-delayed` 350ms timer
- **File:** `src/styles/global.css` L76-82, `src/scripts/client.js` L575-579
- **Session:** 63-66, adjusted 112
- **Decision:** `sidebar-delayed` delays sidebar transitions 350ms while MobileProfile collapses.
- **Bug fixed:** Sidebar expanded before MobileProfile finished collapsing, causing layout jump.
- **Revert consequence:** Layout jump on desktop→mobile transition.

## 10. Timer architecture (3 named timers)
- **File:** `src/scripts/client.js` L492-495
- **Session:** 113
- **Decision:** Three named timers: `mobileProfileTimer` (animation), `snapProfileTimer` (midpoint snap), `adjustTimer` (micro-adjustment). All cleared in `updateMobileProfile()`, `animateMobileProfile()`, and resize handler.
- **Bug fixed:** Race conditions from untimed `setTimeout` calls. `snapSidebarFade()` re-triggered animation on already-visible profile. Stale timers from `navigateTo()` overrode height state.
- **Revert consequence:** Race conditions return. Profile flickers, height pops, stale timers override state.

## 11. CSS clamp → JS inline handoff (`--sidebar-fade`)
- **File:** `src/scripts/client.js` L831-863, `src/styles/global.css` L453-468
- **Session:** 85-87
- **Decision:** CSS `clamp()` drives `--sidebar-fade` during normal resize. JS sets inline `--sidebar-fade` on mouseup snap. Inline removed when viewport exits fade zone.
- **Bug fixed:** Sidebar stuck at intermediate state (e.g. 44% at 1280px) when user stops resizing in fade zone.
- **Revert consequence:** Sidebar stuck at intermediate fade values.

## 12. `data-data` attribute (no fetch, no globals)
- **File:** `src/layouts/BaseLayout.astro`, `src/scripts/client.js` L752+
- **Session:** 1
- **Decision:** All JSONs serialized into `data-data` attribute on `<body>` via `JSON.stringify()`. Client JS reads from `document.body.dataset.data`.
- **Bug fixed:** N/A — architectural decision. Prevents fetch calls, avoids `window.DATA` global, keeps data flow explicit.
- **Revert consequence:** Would need fetch API or global variables for data access.

## 13. `snapProfileTimer` gated on `sidebar-midpoint-mode`
- **File:** `src/scripts/client.js` L855-859
- **Session:** 115-116
- **Decision:** `snapProfileTimer` callback checks `html.classList.contains('sidebar-midpoint-mode')` before calling `animateMobileProfile(true)`.
- **Bug fixed:** Mobile profile overlap on slow resize. `snapProfileTimer` (350ms) fires unconditionally after `snapSidebarFade()`, re-expanding mobile profile that `handleMobileProfile()` just collapsed. Chain: `a3559e7` removed `updateMobileProfile()` midpoint check → `d42e222` added `window.innerWidth > 1235` guard preventing collapse in midpoint zone → `8650255` introduced `snapProfileTimer` via `snapSidebarFade()`.
- **Revert consequence:** Mobile profile re-expands after being collapsed on slow resize through midpoint zone.

## 14. `overflow: hidden` on `.mobile-profile` (not `clip`)
- **File:** `src/styles/global.css` L245
- **Session:** 118
- **Decision:** Use `overflow: hidden` instead of `overflow: clip` on `.mobile-profile`.
- **Bug fixed:** Mobile profile half-height flash on large→small resize. `overflow: clip` doesn't establish a scroll container, making `scrollHeight` return unreliable values (0 or partial). This triggered the fallback path in `animateMobileProfile(show=true)` which sets `height: auto` before the transition is configured, causing instant content expansion. `overflow: hidden` establishes a scroll container for reliable `scrollHeight`.
- **Revert consequence:** `scrollHeight` may return incorrect values again, causing the half-height flash to reappear.

## 15. CSS `transition: opacity 0.3s ease` replaces `@keyframes lang-fade-in`
- **File:** `src/styles/global.css` L1346-1349, `src/scripts/client.js` L852-855
- **Session:** 119
- **Decision:** Use CSS `transition: opacity 0.3s ease` on `.lang-switcher-reveal` instead of `@keyframes lang-fade-in` animation. Removed `animationend` event listener from JS.
- **Bug fixed:** Lang-switcher popped in without a smooth fade-in when resizing to the midpoint zone. The `@keyframes` animation started after the opacity 0→1 jump, making the fade imperceptible. With CSS `transition`, the opacity change itself triggers the 0.3s fade — no flash, smooth transition.
- **Revert consequence:** Lang-switcher fade-in becomes imperceptible again (pops in instantly).

## 16. Midpoint setup before `updateMobileProfile()` in `init()`
- **File:** `src/scripts/client.js` L782-790
- **Session:** 120
- **Decision:** Move `const initW = window.innerWidth` and midpoint class setup (`sidebar-init-mobile`, `sidebar-no-transition`, `sidebar-midpoint-mode`) to BEFORE the first `updateMobileProfile()` call in `init()`. Remove the 350ms `setTimeout` that re-called `updateMobileProfile()`.
- **Bug fixed:** Mobile profile delayed 350ms on F5 reload in midpoint zone (1236-1285px). Previously, `updateMobileProfile()` ran before `sidebar-midpoint-mode` was added, so `shouldShow` evaluated to `false`. The 350ms `setTimeout` repaired this but created a visible delay.
- **Revert consequence:** Mobile profile returns to appearing with a 350ms delay on F5 reload in the midpoint zone.
