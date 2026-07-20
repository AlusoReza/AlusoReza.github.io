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

## Maintenance

- [ ] When modifying `@media (max-width:1235px)` rules, also update `html.sidebar-midpoint-mode` rules
- [ ] When adding new sidebar sub-elements, verify behavior at all fade zone ranges
- [ ] When changing `handleMobileProfile()` timing, verify sequential animation sync
