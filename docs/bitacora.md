# Bitácora — Alonso Suárez Reza Portfolio

Global workflow summary. Each entry links to the detailed day log.

---

## 2026-06-25

[Detailed log →](logs/2026-06-25.md)

### Session 1: MCP Refactoring
**Prompt:** Align the code with Astro 5 best practices.
**Plan:** Replace inline script `is:inline set:html` with `data-data` attribute on `<body>`. Migrate `onclick` to `data-lang` + `addEventListener`. Remove `window.changeLanguage`. Add `tsconfig.json` and `.agents/` directory.

### Session 2: Design Refactoring
**Prompt:** Apply the frontend-design skill to improve portfolio aesthetics.
**Plan:** Choose Space Grotesk + Inter as the typographic system. Refine palette (accent `#7fc1fe`, secondary `#f0a030`). Add computational grid as hero background. Reformulate subtitle as professional thesis. Remove emojis from headings.

### Session 3: Color and subtitle fix
**Prompt:** The page renders white, hovers are invisible, the subtitle is too narrative.
**Plan:** Critical bugfix in `:root` (self-referential variables → real dark theme values). Migrate `.btn-outline` from light-theme to dark-theme colors. Simplify hero-sub to "Desarrollador de software" + "Full Stack · IA · Agentes".

### Session 4: Automatic logging system
**Prompt:** Create an automatic log system that records all agent sessions (detailed plan, changes, build) and a global summary. Apply retroactively.
**Plan:** Create `docs/logs/YYYY-MM-DD.md` with detailed sessions, `docs/bitacora.md` with global summary, modify `AGENTS.md` with mandatory logging workflow.

### Session 5: Context anchoring and log update
**Prompt:** Question "What did we do so far?" — structured summary provided. Then it is noted that the current session log was not updated following the protocol.
**Plan:** Create missing Session 5 entry in `docs/logs/2026-06-25.md` and `docs/bitacora.md`. No portfolio changes — only logging correction.

### Session 6: MCP and Frontend Design Tests
**Prompt:** Add two tests: one for Astro MCP compliance and one for frontend-design skill compliance. Display failures on screen and propose action plan.
**Plan:** Create `.agents/tests/check-mcp.ps1` (16 checks) and `.agents/tests/check-frontend-design.ps1` (21→22 checks). Hybrid option: scripts for mechanical checks + manual semantic review. Update AGENTS.md with `## Tests`. Create missing `.gitkeep` and `skills-lock.json`. Afterwards, fix WARN 1 (`#ffffff` → `var(--color-text-bright)`) and verify with successful build.

### Session 7: Full SDD restructure
**Prompt:** Complete project documentation following SDD.
**Plan:** Create `spec/constitution/` (5 metadocs), `spec/features/` (index + 13 modular specs), `spec/template/` (spec-template + AGENTS_TEMPLATE), `spec/glossary.md`. Move `certificates/` → `docs/certificates/`. Update `.gitignore` and structure in `AGENTS.md`.

### Session 8: Orphan certificate cleanup
**Prompt:** Root `certificates/` still had PDFs after SDD migration.
**Plan:** Move PDFs to `docs/certificates/`, delete root, verify gitignore + no downloads. Confirm AGENTS.md workflow is well defined.

### Session 9: Modular tests + bug tracking
**Prompt:** Create modular test suite (6 scripts + run-all.ps1), bug tracking system in bugs.md, expand AGENTS.md with workflows.
**Plan:** check-js-logic, check-css-logic, check-json-schema, check-paths, run-all.ps1. bugs.md with 11 bugs. Bug tracking protocol in AGENTS.md + feature 14 spec. Debug script issues.

## 2026-06-26

[Detailed log →](logs/2026-06-26.md)

### Session 10: SDD Spec Refactor — flat files → template structure
**Prompt:** Refactor `spec/` to match the new `spec_template/` structure. Every feature must have `spec.md` + `plan.md` + `tasks.md`. Constitution restructured per template. No information loss.
**Plan:** Constitution: README, mission, tech-stack, roadmap (Done/Next/Backlog), keep changelog + bugs. Features: 14 folders × 3 files (42 total), thin features filled from source code. Remove 18 old flat files. Clean bugs.md duplicates. Update AGENTS.md project structure.

## 2026-06-29

[Detailed log →](logs/2026-06-29.md)

### Session 11: Add BIG SCHOOL certificate
**Prompt:** Replace `Guia-Markdown...PDF` with actual certificate (`Certificado-Alonso-Jose-Suarez-Reza-32z2bo0a.pdf`), extract metadata, add to `certificates.json`.
**Plan:** Read PDF (image-based, no extractable text), ask user for details, insert entry as 2nd element in JSON array. Build + verify.

### Session 12: Bug fix sprint
**Prompt:** Review bugs.md and roadmap.md, elaborate plan to fix all bugs, and execute.
**Plan:** 9 fixes in 6 files: init() renderAll, 📄 icon, btn-primary→btn-outline, noopener, early return, #1a1f26→var(--color-bg-card), CV absolute paths, lang switcher overflow, social buttons width. Build + tests + clean bugs.md.

### Session 13: Badges + certificate addition
**Prompt:** Add LaTeX, Overleaf, Excel badges. Add Bootcamp Metodologías Ágiles as 3rd certificate (info from CV).
**Plan:** profile.json +3 badges, global.css +3 CSS classes, certificates.json +1 entry. Build + tests.

### Session 14: XML/JSON + Batch/Bash badges; rename AI Agents; subtitle
**Prompt:** Add XML/JSON and Batch/Bash badges (2+2). Change AI Agents → OpenCode/Claude (naranja). Change subtitle to Full Stack · Agentes · Data.
**Plan:** profile.json +2 badges, rename AI Agents; global.css +2 classes, rename .b-aiagents; lang.json hero-sub.

### Session 15: Deep bug review
**Prompt:** Complete project check for more bugs.
**Plan:** Run tests + deep manual review. Fix stale fallback in Profile.astro. Update [MANUAL] section in test suite.

### Session 16: Conditional nav links
**Prompt:** Hide "Experiencia" in nav when no data. Apply same for "Certificados".
**Plan:** Nav.astro conditional links via experience.length and certificates.length.

### Session 17: Nav flexbox + lang-switcher inline + box-sizing social buttons
**Prompt:** Lang-switcher escapes nav on small screens; social buttons overflow viewport.
**Plan:** Move lang-switcher inside nav (eliminar position:fixed), restructure nav with flexbox, add box-sizing:border-box to social buttons and CV button, fix responsive rules. Update tests. Clean bugs.md.

### Session 18: Workflow template with docs/logs protocol
**Prompt:** Create a template with the complete action plan so any AI can replicate the working methodology. Include how docs/bitacora.md and docs/logs/ interact.
**Plan:** Create `spec/template/workflow-template.md` (9 sections) covering session lifecycle, plan-first, build-driven logging with file hierarchy, bug tracking, testing, commits, language policy, context recovery, quality gates. Update spec template README.

## 2026-07-09

[Detailed log →](logs/2026-07-09.md)

### Session 19: Mobile hamburger nav + responsive refinements + test sweep
**Prompt:** Fix `.project-links` overflow, make nav a hamburger drawer on mobile, fix overlay click, fix z-index for link clicks, fix CV button compression, run tests, clean bugs.md, update logs.
**Plan:** 10-step plan covering CSS fixes, nav restructure (toggle + drawer + overlay), z-index fixes, CV button padding, test suite run, bugs.md cleanup (eliminated ~1000 duplicate lines), log update.

### Session 20: Complete redesign — brittanychiang.com inspired
**Prompt:** Rediseño completo del portfolio inspirado en brittanychiang.com. Layout 2 columnas (sidebar fijo + páginas con slide-in). Fondo de partículas. Skills rediseñados con logo+name vía CDN.
**Plan:** Restructurar JSONs, nuevo CSS (paleta #0a192f/#64ffda), layout sidebar+content, navegación por páginas con animación, partículas canvas, responsive mobile. Build exitoso.

### Session 20b: Layout centering + contact removal + positioning fixes
**Prompt:** Eliminar Contact (redundante), mover CV abajo del nav, centrar layout en monitores grandes (max-width + margin auto), contenido con max-width para evitar textos alargados, scroll-to-top al cambiar de página.
**Plan:** CSS sidebar relative en desktop/fixed en mobile, max-width 1250px wrapper, content max-width 620px, scrollTop en navigateTo.

### Session 20g: Restore i18n render functions + fix scroll/display bug
**Prompt:** Al navegar entre páginas se acumula scroll (páginas ocultas con display:block acumulado). Al cambiar idioma, todas las secciones quedan en español porque los render functions fueron eliminados incorrectamente.
**Plan:** Restaurar renderSection/renderPersonalityItem/renderEducationItem/renderProjectItem/renderExperienceItem/renderCertificateItem/toggleSection. Agregar `oldPage.style.display=''` en navigateTo. Agregar data-section wrappers a 5 componentes. Build exitoso (577ms). Tests: 48 PASS, 8 FAIL (falsos positivos preexistentes), 10 WARN. Commit 5cb8a48.

## 2026-07-14

[Detailed log →](logs/2026-07-14.md)

### Session 21: Dynamic sidebar compact mode
**Prompt:** Fix sidebar overflow on desktop: when viewport height is too small, the sidebar needs vertical scroll. Switch to mobile layout dynamically with animated transitions. Hide scrollbar for clean transitions. Add coordinated content expansion animation.
**Plan:** Add `.sidebar-compact` CSS class + `ResizeObserver` overflow detection in JS. Hide sidebar scrollbar in desktop (`overflow-y: hidden`) + compact mode (`scrollbar-width: none`). Update `--sidebar-width` at each breakpoint. Add explicit `width` + `transition` to content for coordinated expansion. Build exitoso (544ms). 2 files changed, +191 lines.

### Session 22: Fluid responsive adaptation
**Prompt:** Replace hard compact-mode switch with fluid CSS adaptation. Sidebar and content adapt fluidly as viewport shrinks (reduce padding/margins smoothly). At minimum width (≤768px), switch to mobile layout. No more JS overflow detection.
**Plan:** `--sidebar-width` → `clamp(240px, 23vw, 320px)`. Sidebar/content padding → `clamp()` with viewport-relative values. Remove all `body.sidebar-compact` rules (~100 lines). Remove compact mode JS detection. Sidebar gets `overflow-y: auto` + `scrollbar-width: none` for internal scroll. Build exitoso (586ms). 2 files changed.

### Session 23: Fix sidebar padding overflow + raise mobile breakpoint
**Prompt:** Sidebar content must never change size. Fix sidebar horizontal padding overflow (6vw grows too fast). Raise mobile breakpoint to ~1050px so sidebar+content only coexist on larger viewports.
**Plan:** Reduce sidebar horizontal padding to `clamp(30px, 3vw, 50px)` (was `6vw/90px`). Raise mobile breakpoint from 768px to 1050px, desktop from 769px to 1051px. Update mobile content padding to fluid `clamp()` values. Build exitoso (605ms).

### Session 24: Dynamic mobile breakpoint based on sidebar content area
**Prompt:** Instead of hardcoded pixel breakpoint, switch to mobile when sidebar content area reaches 190px (minimum for CV button). Ensures sidebar content never resizes in desktop.
**Plan:** Calculate: `17vw = 190px → viewport = 1118px`. Change breakpoints from 1050/1051px to 1118/1119px. Keep mobile sidebar scaling rules. Build exitoso (562ms).

### Session 25: Fix CV button compression before breakpoint
**Prompt:** CV button changes shape before mobile breakpoint triggers. Button's natural width (~210px) exceeds 190px threshold.
**Plan:** Increase threshold from 190px to 210px: `17vw = 210px → viewport = 1235px`. Change breakpoints to 1235/1236px. Build exitoso (518ms).

### Session 26: Fluid sidebar-to-mobile transition
**Prompt:** Sidebar-to-mobile transition has visual "jump" — sidebar disappears and content jumps into place. Want gradual fade as viewport approaches breakpoint.
**Plan:** CSS variable `--sidebar-fade: clamp(0, (100vw - 1236px) / 100px, 1)` creates opacity fade over 100px before breakpoint. Sidebar fades to invisible before layout switch. Respects `prefers-reduced-motion`. Build exitoso (532ms).

### Session 27: Fix sidebar fade — scale width + opacity simultaneously
**Prompt:** Sidebar "reloads" visible at breakpoint then slides away, defeating fade. Two issues: `opacity: 1` override flashes sidebar, and sidebar width disappears from flex causing content jump.
**Plan:** Scale sidebar width using `calc(var(--sidebar-width) * var(--sidebar-fade))` so width and opacity shrink together. Remove `opacity: 1` from mobile `.sidebar`, add to `.sidebar.open` only. Content expands gradually as sidebar shrinks. Build exitoso (620ms).

### Session 28: Sidebar gradient fade with fixed content size
**Prompt:** Sidebar content compresses as sidebar shrinks. Want content to stay at original size and fade out like gradient.
**Plan:** Wrap sidebar content in `.sidebar-inner` (position absolute, fixed width). Apply `mask-image: linear-gradient` for gradient fade. Move padding to inner div. Restore original width in mobile for hamburger slide-in. Build exitoso (603ms).

### Session 29: Fix inverted sidebar gradient
**Prompt:** Sidebar gradient is inverted — disappears when large, appears when small.
**Plan:** Fix mask formula from `(1 - var(--sidebar-fade))` to `var(--sidebar-fade)`. Build exitoso (630ms).

### Session 30: Content edge gradient to smooth sidebar fade
**Prompt:** Content's hard left edge cuts through sidebar's gradient, creating ugly vertical line.
**Plan:** Add `.content::before` with 40px gradient as visual bridge. Build exitoso (531ms).

### Session 31: Sidebar overhang gradient instead of content gradient
**Prompt:** Content `::before` darkens content. Doesn't work. Revert and reformulate.
**Plan:** Remove `::before`. Extend `.sidebar-inner` width by 60px so it overlaps content's left edge. Mask fades the overlap. No content interference. Build exitoso (504ms).

## 2026-07-15

[Detailed log →](logs/2026-07-15.md)

### Session 32: Restore width: 115% pattern + fix lang-switcher
**Prompt:** Content areas too narrow; restore `width: 115%` feel without overflow.
**Plan:** `.page` `width: 100%; max-width: 115%`. Remove `.content-body` max-width bottleneck. Same on `.site-footer`. Restore lang-switcher `right: -15%`.

### Session 33: Verify content-body max-width removal
**Prompt:** Lang-switcher `right: -15%` pushes off-screen in some states. Verify no white-space issues.
**Plan:** No changes needed — pattern works correctly.

### Session 34: Reduce sidebar-content gap by 20%
**Prompt:** Sidebar and content feel too far apart at max expansion.
**Plan:** Reduce content max padding values ~20% (50px→40px base, large breakpoints similarly reduced).

### Session 35: Align Skills section heading
**Prompt:** Skills uses inline `margin-top: 40px` instead of `section-heading h1`.
**Plan:** Add `section-heading h1` to Skills.astro, `sec-hab` to sections.json, handle in i18n render.

### Session 36: Lang-switcher fluid fade + mobile sidebar fix
**Prompt:** Lang-switcher should fade like sidebar. Sidebar invisible on mobile.
**Plan:** Remove media query `display` control; use `--sidebar-fade` for opacity on both elements. Restore sidebar width fade + media query override at 1135px for mobile visibility.

### Session 37: Design refinement — darker palette, scroll-reveal, particle dimming
**Prompt:** Multiple visual improvements: darker background (intermediate), restore scroll-reveal, fix duplicate titles, whiter badges, transparent sidebar with particle dimming on desktop.
**Plan:** 8 files: darker palette (#0a1527), .reveal/.stagger-item system with IntersectionObserver (re-triggers on page switch), remove duplicate `<h1 class="section-heading">` from 5 components, sidebar transparent desktop/solid mobile, particle dimming with flat trough at CV button width. Commit `35be5cf`.

### Session 38: Loading system overhaul + page persistence + footer conditional
**Prompt:** Loading screen broken (content flashes visible), sidebar shows on mobile during load. Footer only on `sobre`/`hab` pages. Language and page persistence via localStorage.
**Plan:** `<html class="js-loading">` + 500ms timer, spinner, `.js-loading .reveal` override, localStorage for `currentPage`/`preferredLang`, footer toggle in `navigateTo()`. 3 files.

### Session 39: Spinner threshold + loading fix + IntersectionObserver leak
**Prompt:** Spinner appears too late (500ms→300ms). `.js-loading .reveal` override blocks future scroll-reveal permanently. Fix: remove override, hide sidebar during load.
**Plan:** Timer 500→300ms, remove `.js-loading .reveal` override, hide sidebar during load, `scrollObserver` global with `disconnect()` to fix leak, `.visible` reset on all `.reveal` elements. 3 files.

### Session 40: Mobile responsive polish + sidebar toggle slide + 10px gap
**Prompt:** Mobile viewport issues (100vh), sidebar toggle should slide+morph to X, 10px gap between sidebar and X.
**Plan:** `100dvh` fallback, `viewport-fit=cover`, safe-area insets, `.sidebar-toggle.open` slide to `calc(var(--sidebar-width) + 10px)` + X morph, `matchMedia` listener for 1236px, `is-resizing` debounce. Commits `6c06a60` + `f3cbcb4`.

### Session 42: Sidebar content top offset — margin-top → padding-top
**Prompt:** `margin-top: 50px` on `.sidebar` causes overflow (height 100dvh). Need sidebar content at ~50px from top.
**Plan:** Remove `margin-top` from `.sidebar`. Increase `.sidebar-inner` top padding: `clamp(30px, 4vh, 57px)` → `clamp(80px, 9vh, 107px)`.

### Session 43: Sidebar-inner top padding tuning
**Prompt:** Sidebar content offset visual balance. Tested `clamp(50px, 6vh, 77px)` but user preferred `clamp(80px, 6vh, 77px)`.
**Plan:** Adjust `.sidebar-inner` top padding. Final value: `clamp(80px, 6vh, 77px) clamp(30px, 3vw, 40px)`.

## 2026-07-17

[Detailed log →](logs/2026-07-17.md)

### Session 44: Unify "About me" into single block + fix language switch bug
**Prompt:** Merge sobre-p1/p2/p3 into a single sobre-text field with paragraph breaks controlled from component code. Fix bug where about text disappears on language switch.
**Plan:** Merge 3 JSON keys into `sobre-text` with `\n\n` separators. Render from About.astro via `split('\n\n').map()`. Handle same in `translateUI()`. Fix: remove duplicate `translateUI()` call in `changeLanguage()` that broke IntersectionObserver.

### Session 45: CSS cleanup — duplicates, dead code, reorganization
**Prompt:** Analyze full CSS, identify duplicates (`.content` was duplicated), merge rules, remove dead CSS, reorganize into 19 numbered sections with detailed comments.
**Plan:** Merge `.content` into one rule. Remove ~90 lines of dead CSS (Contact section, Tech Skills Grid, unused keyframes, redundant mobile overrides). Reorganize entire file into 19 sections with comments per selector. Net -14 lines.

### Session 46: Content compression threshold — fix right padding + add min-width
**Prompt:** On large screens, content compresses immediately on viewport resize because right padding (`4vw`) shrinks proportionally. User wants layout stable until space2 reaches minimum critical size.
**Plan:** Fix right padding to constant `40px` across all desktop breakpoints. Add `min-width: 940px` to `.content` at ≥1400px. Content stays stable ≥1400px, no compression.

### Session 47: Dynamic right padding — content constant until 40px threshold
**Prompt:** Content should not move at all while resizing. Right padding grows to absorb extra space; only when it reaches 40px does content compress.
**Plan:** Add `clamp(40px, calc(0.9vw - 342px), 110px)` to `.content` in `@media (min-width: 1400px)`. Remove redundant `.content` overrides from 1800px+ and 2600px+ blocks.

### Session 48: Fix broken dynamic padding formula
**Prompt:** Previous formula `calc(0.9vw - 342px)` resolved to 90px at ALL viewports (0.9vw too small). Content still compressing.
**Plan:** Correct formula: `clamp(58px, calc(13vw - 124px), 320px)`. Content width now constant at 940px across ≥1400px.

### Session 49: CSS custom properties for content padding + fix layout morphology bug
**Prompt:** User can no longer change content morphology by modifying padding. Wants to control content padding to expand/contract on screen.
**Plan:** Add CSS custom properties (`--content-pad-*`, `--app-max-width`) in `:root`. Remove `min-width: 940px` and `max-width: 115%` on `.page`. User now controls layout from one place.

### Session 50: Restore content padding overrides per breakpoint via CSS variables
**Prompt:** On large screens, user still can't modify content padding via media queries. Needs per-breakpoint control.
**Plan:** Add `.content { --content-pad-right: ... }` overrides in 1400px+, 1800px+, 2600px+ media queries using the same values from sessions 46-48.

### Session 51: Mobile profile split — profile above content, nav-only sidebar
**Prompt:** On mobile, photo/name/description/CV should appear above the content area. Hamburger sidebar should only contain navigation links + language switcher.
**Plan:** Create `MobileProfile.astro` component, add to `.content` as first child. CSS: hidden on desktop, centered flex layout on mobile. `.sidebar-top > :not(.sidebar-nav)` hidden on mobile to keep only nav in sidebar.

### Session 52: Fix mobile sidebar — mask-image + overflow-y
**Prompt:** Navigation bar broken on mobile. Sidebar content doesn't appear and X close button doesn't work.
**Root cause:** `.sidebar-inner` mask-image depends on `--sidebar-fade` which is 0 on mobile, making content invisible. Override was removed in session 45 refactor.
**Fix:** Added `mask-image: none; overflow-y: auto` to `.sidebar-inner` in mobile media query only.

### Session 53: Fix page entry transition — new content now animates in
**Prompt:** New page content appears instantly without animation when navigating. Old page slides out but new one pops in.
**Root cause:** `display: block` and `.active` class added in the same `requestAnimationFrame` — browser never painted the intermediate state (`opacity: 0, translateX: 40px`), so CSS transition never fired.
**Fix:** Double `requestAnimationFrame` in `client.js` to force the browser to render the initial state before triggering the transition.

### Sessions 54-62: MobileProfile animation — CSS transitions → dual breakpoint JS
**Prompt:** MobileProfile needs smooth animated transition synced with sidebar fade. No overlap, no layout jumps.
**Journey:** CSS transitions → clip-path → position:absolute → JS matchMedia → Web Animations API → dual breakpoint.
**Final approach (S62):** Two `matchMedia` breakpoints (1280px exit, 1180px enter) + `max-height` CSS transition. Element always in layout at 0 height on desktop (`max-height: 0; overflow: hidden`). JS adds/removes `.mobile-profile--visible` class. 100px transition zone ensures animations complete before layout changes.

### Session 63: Two-phase disappear — transitionend + sidebar lock
**Prompt:** MobileProfile disappears too slowly when viewport widens, overlapping with sidebar appearance. User requested: delay sidebar until content fully disappears.
**Plan:** CSS: `html.sidebar-locked { --sidebar-fade: 0; }` freezes sidebar. JS: On exit zone, adds `sidebar-locked` + `transitionend` listener on MobileProfile. When `opacity` transition ends → removes lock → sidebar appears via its own transitions. Two-phase: visual fade first (0.2s), then layout collapse (`max-height 0s 0.2s` delay), then sidebar appears.

### Session 64: Fix mobile→desktop — eliminate hybrid zone + setTimeout
**Prompt:** When widening from mobile to desktop, contents superimpose multiple times and page needs reload.
**Root cause:** 45px hybrid zone (1235-1280px) where sidebar is desktop mode but MobileProfile still visible + `transitionend` fragility + `sidebar-locked` discontinuity.
**Plan:** Changed `mqlExit` from 1280px to 1235px (synced with `@media`). Replaced `transitionend` with `setTimeout(250)`. Added `transition: none` on sidebar elements during lock. Changed `max-height` delay to 0.25s to sync with timer.

### Session 65: Fix MobileProfile — grid 0fr/1fr + overflow clip + remove transform
**Prompt:** MobileProfile content gets cut off in mobile mode and doesn't stay static after transition.
**Plan:** Changed from `max-height` to `display: grid; grid-template-rows: 0fr/1fr` for cross-browser height animation. Changed `overflow: hidden` → `overflow: clip` to eliminate scroll-container clipping. Removed `transform: translateY(-16px)` — grid + opacity alone is sufficient, no vertical slide needed.

### Session 66: Fix lang-switcher flash during desktop→mobile transition
**Prompt:** Floating lang-switcher appears momentarily in the sidebar area while the sidebar slides off-screen when resizing past 1235px.
**Plan:** Added `html.sidebar-locked .lang-switcher-floating { opacity: 0; transition: none; }` CSS rule. Applied `sidebar-locked` in both directions (mobile→desktop existing, desktop→mobile new) with timed removal (350ms/300ms).

### Session 67: Fix mobile sidebar close — add slide-out transition
**Prompt:** Clicking X to close mobile sidebar disappears instantly without animation. Close should match the open slide-in.
**Plan:** Added `.sidebar:not(.open)` CSS rule with explicit `transform: translateX(-100%); transition: transform 0.3s ease`. Added early return guard in `closeSidebar()` to prevent race condition from double-calls cancelling the animation.

### Session 68: Fix sidebar close — CSS cascade bug
**Prompt:** Sidebar still disappears without animation when clicking X. Previous session's `.sidebar:not(.open)` fix didn't solve it.
**Root cause:** `.sidebar:not(.open)` and `.sidebar.open` have same specificity (0,1,1). Source order wins → `.sidebar:not(.open)` overrides `.sidebar.open` even when `.open` IS present, so transform never changes.
**Fix:** Removed `.sidebar:not(.open)` rule. Base mobile `.sidebar` already sets `transform: translateX(-100%); transition: transform 0.3s ease`. `.sidebar.open` overrides to `0`. Both directions now animate.

### Session 69: Fix sidebar close — opacity snapping to 0
**Prompt:** Sidebar close still disappears without animation after removing `.sidebar:not(.open)`.
**Root cause:** Base `.sidebar` has `opacity: var(--sidebar-fade)` = 0 on mobile. Mobile media query doesn't override it. When `.open` removed, opacity snaps to 0 instantly (not animated), hiding the sidebar before transform animation is visible.
**Fix:** Added `opacity: 1` to mobile `.sidebar` rule. On mobile, visibility is controlled by `transform` only — `--sidebar-fade` opacity is irrelevant for the fixed drawer.

## 2026-07-19

[Detailed log →](logs/2026-07-19.md)

### Session 70: Responsive MobileProfile layout
**Prompt:** Redesign MobileProfile to be responsive within mobile range (0–1235px). Content should go horizontal at wider widths and progressively stack vertically. Don't touch PC↔mobile transition. Photo must not be too small.
**Plan:** 3-state flexbox system: STATE 3 (<500px) vertical centered (120×150px photo), STATE 2 (500–699px) two-row (100×125px photo), STATE 1 (700–1235px) full horizontal row. HTML restructured with `.mobile-profile-text` and `.mobile-profile-actions` wrappers. CSS comments for photo size customization.

### Session 71: JS-driven responsive MobileProfile layout
**Prompt:** User wants 3 layout states detected by JS ResizeObserver: (1) 4 columns Photo|Name|Title|Actions, (2) 3 columns Photo|Name/Title|Actions, (3) all vertical. Social buttons always above CV button.
**Plan:** Replace CSS media query breakpoints with JS-toggled classes. ResizeObserver on `.mobile-profile-inner` measures actual width. ≥650px → `.mobile-profile-inner--row` (3 cols). ≥800px → `.mobile-profile-text--row` (4 cols). Actions always `flex-direction: column`.

### Session 72: Fix mobile profile text positioning and reflow
**Prompt:** Title overlaps name, text changes size during resize, remove last name translateX, ensure texts don't reflow.
**Plan:** 4 CSS fixes: gap between name/desc, remove translateX, `white-space: nowrap` on name spans + desc, `flex: 0 0 auto` on name in text--row to prevent shrinking.

### Session 75: Dual-desc with show/hide
**Prompt:** STATE 1 and STATE 2 overlap, title stuck to name, name in STATE 2 vertical instead of horizontal. Solution: two desc elements — inline (STATE 2) and standalone (STATE 1) — with CSS show/hide per state.
**Plan:** HTML: add `--inline` desc inside text block, rename original to `--standalone`. CSS: default hide standalone, STATE 2 show inline + centered combined block + name horizontal, STATE 1 show standalone + commit layout. JS: measure standalone for threshold.

### Session 78: FLIP animation for mobile profile layout switch
**Prompt:** Add animated transition when MobileProfile switches between horizontal and vertical states on smaller screens.
**Plan:** FLIP technique — capture element positions before class toggle, apply inverted transforms, animate to final positions with `transition: transform 0.3s ease`. Photo dimensions animated via CSS `transition: width/height`. First measurement skipped (no animation on initial render). `prefers-reduced-motion` covered by existing CSS global rule.

### Session 79: Fix dynamic name layout breaking animations
**Prompt:** Dynamic name feature caused teleporting + jittering on resize. Two FLIPs fought over the same `name` element.
**Fix:** Removed separate name FLIP — CSS `flex-direction` transition handles name layout. Used `.mobile-profile-text` container for row FLIP instead of `name` child. Name no longer in FLIP `elements` array, so no `style.transform`/`style.transition` conflicts.

### Session 80: 3-state mobile profile layout
**Prompt:** Add medium viewport state between vertical and row+inline. Name should try inline first, stack when too wide. Row threshold uses stacked name width.
**Fix:** Two thresholds: `totalNeededStacked` (enters row) vs `totalNeededInline` (name goes inline in row). `shouldInline = shouldRow ? w >= totalNeededInline : nameFitsInline`. Fix `NodeList.map()` crash. FLIP cleanup with `animCount` + parent transition suppression.

### Session 81: Fix name FLIP infinite loop
**Prompt:** Content oscillates between top-right corner and original position in an infinite loop.
**Root cause:** `oldNameRect` captured AFTER measurement code that temporarily toggles `--inline`, always forcing name to stacked state. Created false position delta that triggered FLIP on every callback even when state hadn't changed.
**Fix:** Moved `oldNameRect` capture BEFORE measurement code to capture actual current state.

### Session 82: Remove name FLIP — CSS transition handles name layout
**Prompt:** Name appears to fly in from top-right instead of transitioning in place.
**Root cause:** FLIP calculates large delta between stacked (higher, centered) and inline (lower, wider) positions. Animation shows full displacement, producing unwanted "flight" effect.
**Fix:** Removed name FLIP entirely (25 lines + `nameFlipAnimating` flag + `oldNameRect`). Simple `if (shouldRow === wasRow) return` — CSS `transition: flex-direction 0.3s ease, gap 0.3s ease, align-items 0.3s ease` handles name layout change smoothly. Grid FLIP (vertical↔row) preserved.

### Session 83: Revert + name Y-compensation animation
**Prompt:** User wants to revert to commit `7be97f1` and add a proper animation for name layout changes. CSS transition doesn't work because `flex-direction` is discrete (doesn't interpolate).
**Fix:** Reverted `client.js` to `7be97f1`. Added `oldNameRect` capture before measurement (loop fix). Added Y-compensation: captures `dy` between stacked/inline positions, applies `translateY(dy)` instant, animates to `translateY(0)` with `0.2s ease-out`. Only compensates vertical axis — horizontal handled by CSS centering.
