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

## 15. `transition: none` on `sidebar-midpoint-mode` (not on `lang-switcher-delayed`)
- **File:** `src/styles/global.css` L1332-1344, `src/scripts/client.js` L852-854
- **Session:** 119, 121, 122
- **Decision:** `transition: none` lives on `sidebar-midpoint-mode` rule (specificity 0,2,1), not on `lang-switcher-delayed` rule. `lang-switcher-delayed` only carries `opacity: 0`. After 340ms, `lang-switcher-delayed` is removed — `sidebar-midpoint-mode`'s `transition: none` applies, making the opacity change 0→1 atomic (no transition). This matches the automatic path behavior (crossing 1235px via `handleMobileProfile`), where the lang-switcher appears instantly as part of the mobile layout.
- **Bug fixed:** Lang-switcher popped in without fade on midpoint entry. Three root causes: (1) `lang-switcher-reveal` was never cleaned up on exit, so on re-entry both `delayed` and `reveal` were present with same specificity — reveal won (later source order), making delayed dead. (2) `transition` and `opacity` changed atomically when swapping delayed→reveal, causing browsers to swallow the transition. (3) With `transition: none` on `lang-switcher-delayed`, the atomic class removal caused `transition: opacity 0.3s ease` + `opacity: 1` to apply in the same recalc — browser swallowed the transition.
- **Revert consequence:** Lang-switcher appearance breaks — opacity jumps from 0 to 1 with base `transition: opacity 0.3s ease`, but both change atomically so browser swallows it. Lang-switcher stays invisible or appears inconsistently.

## 16. Midpoint setup before `updateMobileProfile()` in `init()`
- **File:** `src/scripts/client.js` L782-790
- **Session:** 120
- **Decision:** Move `const initW = window.innerWidth` and midpoint class setup (`sidebar-init-mobile`, `sidebar-no-transition`, `sidebar-midpoint-mode`) to BEFORE the first `updateMobileProfile()` call in `init()`. Remove the 350ms `setTimeout` that re-called `updateMobileProfile()`.
- **Bug fixed:** Mobile profile delayed 350ms on F5 reload in midpoint zone (1236-1285px). Previously, `updateMobileProfile()` ran before `sidebar-midpoint-mode` was added, so `shouldShow` evaluated to `false`. The 350ms `setTimeout` repaired this but created a visible delay.
- **Revert consequence:** Mobile profile returns to appearing with a 350ms delay on F5 reload in the midpoint zone.

## 17. `@keyframes sidebar-entrance` animation (not CSS transitions)
- **File:** `src/styles/global.css` L84-96, `src/scripts/client.js` L584-594
- **Session:** 124
- **Decision:** Use `@keyframes sidebar-entrance` animation instead of CSS transitions for the initial sidebar appearance when `sidebar-delayed` is removed. CSS animations are NOT suppressed by `transition: none !important` from `is-resizing` — they're a separate mechanism. Captures `--sidebar-fade` value at animation start as `--entrance-target` (static CSS custom property on sidebar element). On `animationend`, cleans up and re-calls `snapSidebarFade()` to set correct inline value.
- **Bug fixed:** Sidebar appeared suddenly (no animation) during any resize from mobile to desktop. `is-resizing` suppressed all CSS transitions, so the sidebar couldn't animate from 0→visible during the brief window between timer firing and next resize event.
- **Revert consequence:** Sidebar returns to jumping from invisible to visible without animation during resize.

## 18. Standalone `lang-switcher-delayed` + midpoint timing pattern for PC-to-mobile
- **File:** `src/styles/global.css` L68-70, `src/scripts/client.js` L597-616
- **Session:** 129
- **Decision:** Replicate midpoint timing pattern for direct PC-to-mobile crossing. Both `sidebar-locked` and `lang-switcher-delayed` removed simultaneously at T=340ms. `animateMobileProfile(true)` deferred to T=350ms via `sidebarLockTimer` (was: called immediately at T=0). Add standalone CSS rule `html.lang-switcher-delayed .lang-switcher-floating { opacity: 0; }` (specificity 0,2,1) that works without `sidebar-midpoint-mode`. Clear `snapProfileTimer` to prevent conflicts with midpoint path.
- **Bug fixed:** Lang-switcher appeared at the exact moment mobile profile animation finished (T=350ms), creating an abrupt pop-in. Root cause: (1) `animateMobileProfile(true)` called immediately at T=0 in mobile but deferred to T=350ms in midpoint. (2) `sidebar-locked` (specificity 0,2,1) blocked lang-switcher even after `lang-switcher-delayed` was removed, because it beats the media query (0,1,0).
- **Revert consequence:** Lang-switcher returns to popping in abruptly at animation end. The timing synchronization with midpoint is broken.
