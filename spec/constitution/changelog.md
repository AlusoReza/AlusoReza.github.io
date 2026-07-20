# Changelog — Alonso Suárez Reza Portfolio

## 2026-06-25 — Sessions 1-7

### Session 1 — MCP Refactoring
- Replaced inline script `is:inline set:html` with `data-data` attribute on `<body>`
- Migrated `onclick` to `data-lang` + `addEventListener`
- Removed `window.DATA` and `window.changeLanguage`
- Added `tsconfig.json` (extends `astro/tsconfigs/base`)
- Created `.agents/skills/frontend-design/SKILL.md`

### Session 2 — Design Refactoring
- Typography: Space Grotesk (display) + Inter (body)
- Palette: accent `#7fc1fe`, 11 `:root` variables with real values
- Computational grid as hero background
- Subtitle reformulated as professional thesis
- Removed emojis from headings

### Session 3 — Color and subtitle fix
- Critical bugfix: self-referential `:root` variables → real values
- `.btn-outline` migrated from light theme to dark theme
- Hero simplified: "Desarrollador de software / Software developer"
- Tags: "Backend · Datos · Sistemas" → "Full Stack · IA · Agentes"

### Session 4 — Automatic logging system
- Created `docs/logs/` with `YYYY-MM-DD.md` format
- Created `docs/bitacora.md` as global summary
- AGENTS.md updated with build-driven workflow

### Session 5 — Context anchoring and log update
- Structured summary of all work done
- Corrected logging protocol

### Session 6 — MCP and Frontend Design Tests
- Created `.agents/tests/check-mcp.ps1` (16 checks)
- Created `.agents/tests/check-frontend-design.ps1` (22 checks)
- Added missing `skills-lock.json`
- AGENTS.md: added `## Tests` section
- Fixed 7 `color: #ffffff` → `var(--color-text-bright)`

### Session 7 — SDD Restructure
- Created `spec/` with `constitution/`, `features/`, `template/`
- Moved root `certificates/` → `docs/certificates/`
- Moved `spec_template/AGENTS_TEMPLATE.md` → `spec/template/`
- Created 21 SDD specification files
- AGENTS.md: updated project structure and certificate paths
- `.gitignore`: updated `certificates/` → `docs/certificates/`

## 2026-06-26 — Sessions 8-14

### Session 8 — Test suite + bug detection
- Created `check-js-logic.ps1`, `check-css-logic.ps1`, `check-paths.ps1`
- First full test run: 14 PASS, 7 FAIL, 3 WARN
- Identified: mixed-language load, CV 404, emoji icon destruction, undefined CSS classes

### Session 9-11 — Bug fixes
- Fixed `target=_blank` without `rel=noopener` (×4)
- Fixed `changeLanguage` without early return
- Fixed `#1a1f26` hardcoded in `.badge`
- Fixed inconsistent asset paths

### Session 12 — Critical bug batch
- Fixed mixed-language on initial load with EN saved
- Fixed CV PDF 404 (user placed at `public/assets/`)
- Fixed emoji icon destruction on language switch
- Replaced `btn-primary` with `btn-outline`

### Session 13-14 — Test cleanup + maintenance
- Updated AGENTS.md with all project rules
- Created feature spec templates

## 2026-07-13 — Sessions 19-20

### Session 19 — Mobile hamburger nav
- Fixed `.project-links` overflow
- Created hamburger drawer on mobile (toggle + overlay)
- Fixed z-index for link clicks, CV button compression

### Session 20 — Complete redesign (brittanychiang.com inspired)
- 2-column layout (fixed sidebar + content pages with slide-in)
- Canvas particle background with dimming zones
- SPA navigation with animated page transitions
- Skills redesigned with logo+name via CDN

### Session 20b — Layout centering + positioning
- Removed Contact section (redundant)
- Moved CV below nav, centered layout with `max-width: 1250px`
- `scrollTop` on page navigation

### Session 20g — Restore i18n + scroll fix
- Restored all render functions (accidentally deleted)
- Fixed scroll accumulation across pages

## 2026-07-14 — Sessions 21-25

### Session 21 — Dynamic sidebar compact mode
- `ResizeObserver` + `.sidebar-compact` CSS class
- Sidebar scroll + content expansion animation

### Session 22 — Fluid responsive
- `--sidebar-width: clamp(240px, 23vw, 320px)`
- Removed compact mode JS (~100 lines CSS removed)

### Session 23 — Sidebar padding fix
- Reduced horizontal padding to `clamp(30px, 3vw, 50px)`
- Raised mobile breakpoint to 1050px

### Session 24 — Dynamic breakpoint
- Calculated from sidebar content area minimum (190px → 1118px)

### Session 25 — CV button compression fix
- Increased threshold to 210px → breakpoint at 1235px

## 2026-07-14 — Sessions 26-31

### Session 26 — Fluid sidebar fade
- `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)`

### Session 27 — Width+opacity sync
- Sidebar width scales with `--sidebar-fade` via `calc()`

### Session 28 — Sidebar gradient mask
- `.sidebar-inner` with `mask-image: linear-gradient`

### Session 29 — Fix inverted gradient
- Fixed mask formula direction

### Session 30-31 — Content edge gradient
- Sidebar overhang with mask fade (60px overlap)

## 2026-07-15 — Sessions 32-36

### Session 32 — Restore width: 115% pattern
- `.page` width + lang-switcher positioning

### Session 33-34 — Content tuning
- Verified no issues, reduced sidebar-content gap

### Session 35 — Skills heading alignment
- Added `section-heading h1` to Skills component

### Session 36 — Lang-switcher fluid fade
- Synced lang-switcher opacity with `--sidebar-fade`

## 2026-07-15 — Sessions 37-40

### Session 37 — Design refinement
- Darker palette (#0a1527), scroll-reveal re-triggers
- Sidebar transparent desktop/solid mobile
- Particle dimming with flat trough at CV button

### Session 38-39 — Loading system
- `<html class="js-loading">` + spinner + 300ms timer
- Fixed IntersectionObserver leak

### Session 40 — Mobile responsive polish
- `100dvh` fallback, sidebar toggle slide+X morph
- `matchMedia` listener for 1236px, `is-resizing` debounce

## 2026-07-16 — Sessions 42-50

### Session 42-43 — Sidebar padding
- Inner top padding tuning to `clamp(80px, 6vh, 77px)`

### Session 44 — About section merge
- Merged sobre-p1/p2/p3 into single `sobre-text` field

### Session 45 — CSS cleanup
- Removed ~90 lines dead CSS, reorganized into 19 sections

### Session 46-48 — Content compression fix
- Dynamic right padding via `clamp()` formula
- Content width constant at 940px across ≥1400px

### Session 49-50 — CSS custom properties
- `--content-pad-*` and `--app-max-width` in `:root`
- Per-breakpoint content padding overrides

## 2026-07-17 — Sessions 51-53

### Session 51 — MobileProfile split
- Created `MobileProfile.astro` above content
- Sidebar nav-only on mobile

### Session 52 — Sidebar mask fix
- `mask-image: none; overflow-y: auto` for mobile sidebar

### Session 53 — Page entry transition
- Double `requestAnimationFrame` for animation trigger

## 2026-07-17 — Sessions 54-66

### Session 54-62 — MobileProfile animation journey
- CSS transitions → clip-path → position:absolute → dual breakpoint → `grid-template-rows: 0fr/1fr`
- Final: `max-height` transition + `.mobile-profile--visible` class

### Session 63 — Two-phase disappear
- `sidebar-locked` class + `transitionend` for sequential animation

### Session 64 — Hybrid zone fix
- Synced `mqlExit` with `@media`, replaced `transitionend` with `setTimeout(250)`

### Session 65 — Grid animation
- `grid-template-rows: 0fr/1fr` + `overflow: clip`

### Session 66 — Lang-switcher flash
- `sidebar-locked` hides lang-switcher during transition

## 2026-07-18 — Sessions 67-69

### Session 67-68 — Sidebar close animation
- Fixed CSS cascade bug (`.sidebar:not(.open)` specificity)
- Removed conflicting rule, base mobile CSS handles both directions

### Session 69 — Opacity snapping fix
- Added `opacity: 1` to mobile `.sidebar` rule

## 2026-07-19 — Sessions 70-83

### Session 70-72 — Responsive MobileProfile
- 3-state layout via ResizeObserver (vertical/row/inline)
- Photo dimensions: 120×150 (vertical), 100×125 (row), 200×225 (inline)

### Session 75 — Dual-desc
- Show/hide inline vs standalone description per state

### Session 78 — FLIP animation
- Layout switch animation with `transition: transform 0.3s ease`

### Session 79-82 — Name FLIP fixes
- Removed separate name FLIP, CSS `flex-direction` transition handles layout

### Session 83 — Name Y-compensation
- Reverted to `7be97f1`, added `translateY(dy)` animation

## 2026-07-20 — Sessions 84-87

### Session 84 — Snap safety net
- `snapSidebarIfStuck()` for intermediate states

### Session 85 — CSS-only sidebar
- Removed snap system + dead zone (~56 lines removed)
- Kept `handleMobileProfile()` with `sidebar-delayed`/`sidebar-locked`

### Session 86 — Breakpoint flash fix
- `sidebar-no-transition` for 2 rAF frames on media query change

### Session 87 — Snap on resize end + midpoint mode
- `snapSidebarFade()` with upper/lower half logic
- `sidebar-midpoint-mode` CSS class (duplicates `@media (max-width:1235px)` rules)
- `is-resizing` transition suppression
- `mouseup` snap trigger + 1000ms fallback timer
- Init code: `sidebar-init-mobile` + `sidebar-midpoint-mode` for fade zone page loads
