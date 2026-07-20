# 08 · Responsive — Tasks

- [x] Implement desktop-first base layout
- [x] Add 1235px media query (sidebar drawer, hamburger, overlay, content full-width)
- [x] Add `--sidebar-fade` clamp variable (1236-1336px fade zone)
- [x] Add 800px/650px MobileProfile layout states (row/vertical)
- [x] Add 480px media query (tighter padding, smaller badges)
- [x] Make lang-switcher fixed-position on mobile
- [x] Implement `sidebar-midpoint-mode` CSS class (duplicates media query for JS activation)
- [x] Implement `is-resizing` transition suppression
- [x] Implement `snapSidebarFade()` with mouseup trigger + 1000ms fallback
- [x] Implement `sidebar-init-mobile/desktop` for fade zone page loads
- [x] Implement `sidebar-no-transition` for breakpoint crossing flash fix
- [ ] Fix known bug: lang switcher overflow on screens < 360px
- [ ] Fix known bug: social buttons exceed section width on small phones
- [ ] Test all breakpoints in browser devtools
- [ ] Verify no horizontal scroll on any screen width

## Maintenance

- [ ] When adding a new element, verify its responsive behavior at all breakpoints
- [ ] When modifying `@media (max-width:1235px)` rules, also update `html.sidebar-midpoint-mode` rules
