# Roadmap

## Done ✅

1. **01 · Architecture** — Two-phase architecture (Astro build + client JS hydration via `data-data`)
2. **02 · Data contracts** — Schemas for all 7 JSONs with bilingual format
3. **03 · Data flow** — JSON → `data-data` → client.js render pipeline
4. **04 · i18n system** — `data-i18n`, `t()`, `changeLanguage()`, localStorage persistence
5. **05 · Design tokens** — CSS variables in `:root` (GitHub dark theme)
6. **06 · Typography** — Space Grotesk (display) + Inter (body)
7. **07 · Computational grid** — Graph paper background on hero section
8. **08 · Responsive** — Breakpoints at 650px and 480px
9. **09 · Accessibility** — `prefers-reduced-motion` in CSS + JS
10. **10 · Component tree** — 10 Astro components with props and relationships
11. **11 · MCP tests** — Modular test suite (6 modules, master runner)
12. **12 · Design tests** — 22 checks for frontend-design compliance
13. **13 · Logging system** — Build-driven session logging protocol
14. **14 · Bug tracking** — bugs.md lifecycle and regression tracking

### Sidebar redesign (Sessions 20-36)
15. **20 · Complete redesign** — 2-column layout (fixed sidebar + content pages), particle background, SPA navigation
16. **21 · Sidebar compact mode** — `ResizeObserver` + `.sidebar-compact` CSS class for overflow
17. **22 · Fluid responsive** — `--sidebar-width: clamp(240px, 23vw, 320px)`, removed compact mode
18. **23-25 · Breakpoint tuning** — Sidebar padding fix, dynamic breakpoint at 1235px (CV button threshold)
19. **26 · Sidebar fade** — `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)` CSS variable
20. **27 · Width+opacity sync** — Sidebar width scales with `--sidebar-fade` via `calc()`
21. **28-31 · Gradient mask** — `.sidebar-inner` with `mask-image` gradient fade, overhang pattern
22. **32-36 · Lang-switcher fade** — Fluid fade synced with sidebar, mobile sidebar visibility fix

### Loading and polish (Sessions 37-50)
23. **37 · Design refinement** — Darker palette, scroll-reveal re-triggers, particle dimming
24. **38-39 · Loading system** — `<html class="js-loading">`, spinner, IntersectionObserver leak fix
25. **40 · Mobile responsive** — `100dvh`, sidebar toggle slide+X morph, `matchMedia` listener, `is-resizing` debounce
26. **42-43 · Sidebar padding** — Inner top padding tuning
27. **44-45 · CSS cleanup** — Unified About section, removed ~90 lines dead CSS, 19-section reorganization
28. **46-50 · Content padding** — Dynamic right padding, CSS custom properties (`--content-pad-*`, `--app-max-width`)

### MobileProfile system (Sessions 51-83)
29. **51 · MobileProfile split** — Profile above content on mobile, nav-only sidebar
30. **52 · Sidebar mask fix** — `mask-image: none; overflow-y: auto` for mobile sidebar
31. **53 · Page transition** — Double `requestAnimationFrame` for entry animation
32. **54-62 · MobileProfile animation** — CSS transitions → dual breakpoint JS → `grid-template-rows: 0fr/1fr`
33. **63 · Two-phase disappear** — `sidebar-locked` + `transitionend` for sequential mobile↔desktop
34. **64 · Hybrid zone fix** — Synced `mqlExit` with `@media`, replaced `transitionend` with `setTimeout`
35. **65 · Grid animation** — `grid-template-rows: 0fr/1fr` + `overflow: clip`
36. **66 · Lang-switcher flash** — `sidebar-locked` hides lang-switcher during transition
37. **67-69 · Sidebar close animation** — Fixed CSS cascade bugs, opacity snapping, slide-out transition
38. **70-72 · Responsive MobileProfile** — 3-state layout (vertical/row/inline) via ResizeObserver
39. **75 · Dual-desc** — Show/hide inline vs standalone description per layout state
40. **78-83 · FLIP animations** — Layout switch animation, name Y-compensation, infinite loop fix

### Sidebar transition fixes (Sessions 84-87)
41. **84 · Snap safety net** — `snapSidebarIfStuck()` for intermediate states
42. **85 · CSS-only sidebar** — Removed snap system + dead zone, `clamp()`-driven transitions
43. **86 · Breakpoint flash fix** — `sidebar-no-transition` for 2 rAF frames on media query change
44. **87 · Snap on resize end** — `snapSidebarFade()` + midpoint mode (1236-1285px) + `is-resizing` + mouseup snap

### Sidebar refinement (Sessions 88-124)
45. **88 · Bugs.md cleanup** — Deduplication and triage of bug tracker
46. **89 · Test suite fix** — ASCII encoding + stale file references, 0 FAILs
47. **90 · About + Skills merge** — Unified page, eliminated Skills.astro (10 → 8 components)
48. **91-92 · Grid + title fixes** — Adaptive grid, personality render, title repositioning
49. **94-96 · FLIP animation** — Tech grid animation attempts, `.reveal` conflict resolution
50. **98-100 · Sidebar maximize animation** — JS-driven width transition, `sidebar-delayed` timing
51. **102 · Flex-basis fix** — Sidebar flex override + `is-resizing` coordination
52. **104 · Viewport-edge scrollbar** — MobileProfile inside `.content-body`, centered layout
53. **108 · FLIP revert** — Restored CSS grid centering, removed all FLIP effects
54. **109 · MobileProfile animation** — JS-driven `animateMobileProfile()` with `height: 0` base
55. **110 · Midpoint entry animation** — `snapSidebarFade()` calls `animateMobileProfile(true)`
56. **111 · LangSwitcher flicker** — Aligned CSS breakpoint, `lang-switcher-delayed` class
57. **112 · Breakpoint alignment** — `mqlBreakpoint` → 1235px, midpoint mode completion, timer adjustment
58. **113 · Timer safety** — 3 named timers, micro-adjustment, race condition fixes
59. **114 · Dead zone fix** — `snapSidebarFade()` call replaces manual sidebar transition
60. **115 · Tech grid archive** — Documented 5 animation approaches, removed transition code
61. **116 · Documentation overhaul** — bugs.md rewrite, code-decisions.md, spec updates
62. **117-118 · Mobile profile animation fix** — Inverted operation order + `overflow: hidden`
63. **119 · Lang-switcher fade-in** — CSS transition replaces `@keyframes lang-fade-in`, removed `animationend` listener
64. **120 · F5 midpoint fix** — Midpoint setup before `updateMobileProfile()`, removed 350ms setTimeout
65. **121 · Lang-switcher fade-in (final)** — Eliminated `lang-switcher-reveal`, moved `transition:none` to `delayed`
66. **122 · Intermediate-speed resize fix** — Remove inline `--sidebar-fade` after timer's snap in fade zone
67. **124 · Sidebar entrance animation** — `@keyframes sidebar-entrance` replaces CSS transitions (not blocked by `is-resizing`)
68. **128 · Midpoint padding fix** — Aligned midpoint `--content-pad-right` with mobile values

## Next 🔜

- Add more integration tests (build output, HTML snapshot)

## Backlog 💡

- Explore light theme toggle
- Migrate i18n to `@astrojs/netlify` or similar if SSR is ever needed
- Install MCP for all programming languages used in the project
