# 15 · Sidebar Architecture — Tasks

- [x] Implement `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)` CSS variable
- [x] Sync sidebar width/flex with `--sidebar-fade` via `calc()`
- [x] Add `.sidebar-inner` with `mask-image` gradient fade
- [x] Add `@media (max-width: 1235px)` for mobile layout (position:fixed, hamburger, overlay)
- [x] Add `sidebar-locked` class for sequential animation freeze
- [x] Add `sidebar-delayed` class for sequential animation delay
- [x] Add `sidebar-no-transition` class for breakpoint flash suppression
- [x] Add `is-resizing` class for transition suppression during resize
- [x] Implement `handleMobileProfile()` for 1234px breakpoint sequencing
- [x] Implement `updateMobileProfile()` with midpoint-mode awareness
- [x] Implement `sidebar-midpoint-mode` CSS class (duplicates media query rules)
- [x] Implement `snapSidebarFade()` with upper/lower half logic
- [x] Implement mouseup snap trigger + 1000ms fallback timer
- [x] Implement `sidebar-init-mobile/desktop` for fade zone page loads
- [x] Add midpoint mode activation to init code for 1236-1285px loads
- [x] Implement `animateMobileProfile()` with scrollHeight measurement and px height transitions
- [x] Add `height: 0` to `.mobile-profile` CSS base state
- [x] Call `animateMobileProfile(true)` in `snapSidebarFade()` midpoint branch
- [x] Align `mqlBreakpoint` to 1235px (from 1234px)
- [x] Add `window.innerWidth > 1235` guard in resize handler
- [x] Add 7 missing sidebar rules to `sidebar-midpoint-mode` CSS block
- [x] Adjust `sidebar-delayed` timer from 400ms to 350ms
- [x] Implement 3 named timer architecture (`mobileProfileTimer`, `snapProfileTimer`, `adjustTimer`)
- [x] Add micro-adjustment (re-measure after 350ms, smooth 150ms adjust if >2px diff)
- [x] Gate `snapProfileTimer` on `sidebar-midpoint-mode`
- [x] Replace manual sidebar transition block with `snapSidebarFade()` call in `handleMobileProfile()`

## Maintenance

- [ ] When modifying `@media (max-width:1235px)` rules, also update `html.sidebar-midpoint-mode` rules
- [ ] When adding new sidebar sub-elements, verify behavior at all fade zone ranges
- [ ] When changing `handleMobileProfile()` timing, verify sequential animation sync
- [ ] When modifying timer callbacks, verify all 3 timers are cleared in all code paths
- [ ] When changing `animateMobileProfile()`, verify micro-adjustment still works for dynamic content
