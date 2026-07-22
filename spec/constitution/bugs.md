# Bugs known — Alonso Suarez Reza Portfolio

Last scan: 2026-07-22 (Session 120)
Status: All previously identified bugs fixed. 1 partially fixed (Session 118). Test scripts updated to match current project structure. Code decisions documented in `code-decisions.md`.

## Fixed (Session 12 — 2026-06-26)

### Mixed-language on initial load with EN saved — HIGH
- **File:** `src/scripts/client.js`
- **Source:** check-js-logic.ps1 + [MANUAL]
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `if (savedLang !== 'es') renderAll();` at end of `init()`

### CV PDF does not exist (404) — MEDIUM
- **File:** `src/components/Contact.astro`, `src/components/Profile.astro`
- **Source:** check-paths.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** User placed PDF at `public/assets/Alonso_Reza_CV.pdf`; paths updated to `/assets/...`

### Icon destroyed on language switch — MEDIUM
- **File:** `src/components/Contact.astro`
- **Source:** [MANUAL]
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Separated icon into `<span class="icon">` outside `data-i18n` span

### btn-primary undefined in CSS — LOW
- **File:** `src/components/Projects.astro`, `src/scripts/client.js`
- **Source:** check-js-logic.ps1, check-css-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Replaced `btn-primary` with `btn-outline` (existing defined class)

### target=_blank without rel=noopener (x4) — LOW
- **File:** `Contact.astro`, `Projects.astro`, `client.js`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `rel="noopener noreferrer"` to all 4 external links

### changeLanguage without early return — LOW
- **File:** `src/scripts/client.js`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `if (lang === currentLang) return;`

### #1a1f26 hardcoded in .badge — LOW
- **File:** `src/styles/global.css`
- **Source:** check-css-logic.ps1, check-frontend-design.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Replaced `#1a1f26` with `var(--color-bg-card)`

### Inconsistent asset paths — LOW
- **File:** `profile.json`, `Contact.astro`
- **Source:** check-paths.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Changed both to absolute `/assets/Alonso_Reza_CV.pdf`

### Lang switcher overflow on very small screens — LOW
- **File:** `src/styles/global.css`
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Lang-switcher moved inside `<nav>` as inline flex element

### Social buttons width at ~480-550px — LOW
- **File:** `src/styles/global.css`
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Added `box-sizing: border-box` and responsive width rules

## Fixed (Session 19 — 2026-07-13)

### .project-links missing flex-wrap (mobile overflow) — LOW
- **File:** `src/styles/global.css`
- **Source:** Mobile responsive analysis
- **Detected:** Session 18 | **Fixed:** Session 19
- **Fix:** Added `flex-wrap: wrap` to `.project-links`

### nav-overlay not covering full viewport — MEDIUM
- **File:** `src/components/Nav.astro`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Moved `.nav-overlay` outside `<nav>` to escape `backdrop-filter` containing block

### nav-links unclickable on mobile (z-index conflict) — HIGH
- **File:** `src/styles/global.css`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Changed `.nav-bar` z-index from 50 to 100

### CV button text compressed on mobile — LOW
- **File:** `src/styles/global.css`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Added `height: auto; min-height: 45px; padding: 12px 20px` to `.cv-btn` mobile rule

## Fixed (Sessions 85-87 — 2026-07-20)

### Sidebar stuck at intermediate state on resize — HIGH
- **File:** `src/scripts/client.js`, `src/styles/global.css`
- **Source:** [MANUAL]
- **Detected:** Session 84 | **Fixed:** Session 85-87
- **Fix:** Removed snap system, made sidebar CSS-only via `clamp()`. Added `snapSidebarFade()` for mouseup snap. Added `sidebar-midpoint-mode` for dead zone. Added `is-resizing` transition suppression.

### Sidebar flash when crossing 1235px breakpoint — HIGH
- **File:** `src/styles/global.css`, `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 86 | **Fixed:** Session 86
- **Fix:** `sidebar-no-transition` class for 2 rAF frames on media query change

### Mobile profile not appearing in midpoint mode — MEDIUM
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 87 | **Fixed:** Session 87
- **Fix:** `updateMobileProfile()` now checks `sidebar-midpoint-mode` in addition to `mqlBreakpoint.matches`

### Page load in fade zone shows wrong layout — MEDIUM
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 87 | **Fixed:** Session 87
- **Fix:** Init code now adds `sidebar-midpoint-mode` + `updateMobileProfile()` for loads in 1236-1285px

## Fixed (Session 109 — 2026-07-21)

### Mobile-profile animation broken on resize — HIGH
- **File:** `src/scripts/client.js`, `src/styles/global.css`
- **Source:** [MANUAL]
- **Detected:** Session 109 | **Fixed:** Session 109
- **Root cause:** `height: auto → 0` is not transitionable in CSS. `grid-template-rows: 0fr/1fr` was overridden by flex `min-height: auto` on PC.
- **Fix:** Added `height: 0` to `.mobile-profile` CSS base state. New `animateMobileProfile(show, duration)` function with `scrollHeight` measurement and explicit px height animation. Updated `handleMobileProfile()` and `updateMobileProfile()` callers.
- **Code decision:** See `code-decisions.md` #5 (JS-driven height animation) and #6 (`height: 0` base state).

## Fixed (Session 110 — 2026-07-21)

### SnapSidebarFade midpoint entry animation missing — MEDIUM
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 110 | **Fixed:** Session 110
- **Root cause:** `snapSidebarFade()` called `updateMobileProfile()` (instant show) instead of `animateMobileProfile(true)`.
- **Fix:** Single-line change in `snapSidebarFade()` midpoint branch: `updateMobileProfile()` → `animateMobileProfile(true)`.
- **Code decision:** See `code-decisions.md` #3 (`animateMobileProfile()` in `snapSidebarFade()`).

## Fixed (Session 111 — 2026-07-21)

### LangSwitcher flicker on slow PC→mobile resize — MEDIUM
- **File:** `src/styles/global.css`, `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 111 | **Fixed:** Session 111
- **Root cause:** Lang-switcher CSS mobile breakpoint was at 1234px (aligned with old `mqlBreakpoint`) while sidebar/hamburger were at 1235px. During slow resize, lang-switcher flickered between states.
- **Fix:** Changed lang-switcher CSS media query to `@media (max-width: 1235px)`. Added `lang-switcher-delayed` class in `snapSidebarFade()` midpoint entry.

## Fixed (Session 112 — 2026-07-21)

### Breakpoint misalignment (1px gap) — HIGH
- **File:** `src/scripts/client.js`, `src/styles/global.css`
- **Source:** [MANUAL]
- **Detected:** Session 112 | **Fixed:** Session 112
- **Root cause:** CSS `@media (max-width: 1235px)` and JS `mqlBreakpoint (max-width: 1234px)` were misaligned by 1px. Mobile profile missing at 1235px on initial load, flash on resize 1236→1235px, midpoint mode missing 7 sidebar rules, sidebar-delayed timing gap.
- **Fix:** Aligned `mqlBreakpoint` to 1235px. Removed dead zone handler. Added 7 missing midpoint-mode sidebar rules. Adjusted sidebar-delayed timer 400→350ms.
- **Code decision:** See `code-decisions.md` #2 (`mqlBreakpoint` at 1235px) and #11 (timer architecture).

## Fixed (Session 113 — 2026-07-21)

### Mobile profile pop-to-height on large→small resize — MEDIUM
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 113 | **Fixed:** Session 113
- **Root cause:** `animateMobileProfile()` measured `scrollHeight` once at start. During 350ms animation, viewport continued resizing and content height changed. After animation ended, content popped to new `height: auto`. Also: `snapSidebarFade()` untacked setTimeout could re-trigger `animateMobileProfile(true)` on already-visible profile.
- **Fix:** Micro-transition adjustment (re-measure after 350ms, smooth 150ms adjust if >2px diff). Track `snapProfileTimer`. Clear all 3 timers in `updateMobileProfile()`, `animateMobileProfile()`, and resize handler.
- **Code decision:** See `code-decisions.md` #11 (timer architecture).

## Fixed (Session 114 — 2026-07-21)

### Sidebar stuck in PC layout at 1236-1240px (dead zone) — HIGH
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 112 | **Fixed:** Session 114
- **Root cause:** `handleMobileProfile()` L578 `clearTimeout(resizeTimer)` cancelled the 1000ms timer that would call `snapSidebarFade()`. When crossing from <1235px to 1236-1240px, the sequence was:
  1. `mqlBreakpoint` change → `handleMobileProfile()` adds `sidebar-delayed`, starts 350ms timer
  2. `resize` handler → adds `is-resizing`, starts 1000ms timer → `snapSidebarFade()`
  3. At 350ms: removes `sidebar-delayed`, removes `is-resizing`, **`clearTimeout(resizeTimer)` kills the 1000ms timer**
  4. `snapSidebarFade()` never runs → `sidebar-midpoint-mode` never added → sidebar stays in PC layout with `--sidebar-fade ≈ 0`
- **Why intermittent:** `mouseup` handler also calls `snapSidebarFade()` if `is-resizing` is active, but `handleMobileProfile()` clears `is-resizing` at L577 before `mouseup` fires (if user releases mouse after 350ms).
- **Fix:** Replaced 17-line manual sidebar transition block (L575-592) with 3-line block: remove `sidebar-delayed`, remove `is-resizing`, call `snapSidebarFade()`. This eliminates `clearTimeout(resizeTimer)`, removes manual flex/width transition, and ensures `sidebar-midpoint-mode` is always added when entering the 1236-1285px range.

## Fixed (Session 115 — 2026-07-21)

### Tech grid FLIP/transition attempts archived — LOW
- **File:** `src/styles/global.css`, `src/scripts/client.js`, `docs/archived/tech-grid-transitions.md`
- **Source:** [MANUAL]
- **Detected:** Session 102-111 | **Fixed:** Session 115
- **Root cause:** 5 different animation approaches tried on tech grid (FLIP ×3, opacity fade, scale pulse). All rejected due to conflicts with `.reveal` transforms, discrete `flex-direction`, or stale measurements.
- **Fix:** Removed all transition CSS/JS from `global.css` and `client.js`. Created `docs/archived/tech-grid-transitions.md` with full timeline, code snippets, and decision rationale.

## Partially fixed (Sessions 117-118 — 2026-07-22)

### Mobile profile half-height flash on large→small resize — MEDIUM
- **File:** `src/styles/global.css`, `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 117 | **Improved:** Session 118
- **Symptom:** When resizing from >1235px to <1235px, the top half of the mobile profile appears instantly (no animation), then the animation transitions the bottom half smoothly. The user described it as "an instant spacing corresponding to half the mobile profile."
- **Root cause:** `overflow: clip` on `.mobile-profile` does NOT establish a scroll container, causing `scrollHeight` to return an unreliable value (possibly `clientHeight` = 0 or a partial value). This triggered the fallback path in `animateMobileProfile(show=true)` which sets `height: auto` before the CSS transition is configured, causing instant content expansion.
- **Investigation process:**
  1. Session 117: Inverted operation order in `animateMobileProfile(show=true)` — set `style.height='0'` before `classList.add('--visible')`. Added `scrollHeight` fallback. **Result:** Did not fix the bug.
  2. User tried `grid-template-rows: minmax(0, 0fr)` — explicitly set row minimum to 0 instead of `auto`. **Result:** Did not fix the bug.
  3. User tried `min-height: 0` on `.mobile-profile` — prevented flex item expansion. **Result:** Did not fix the bug.
  4. Session 118: Changed `overflow: clip` → `overflow: hidden` — establishes scroll container, making `scrollHeight` reliably return full content height. **Result:** Visual behavior improved — no more instant appearance, animation is smoother. Not perfect but sufficient.
- **Fix:** Changed `overflow: clip` to `overflow: hidden` on `.mobile-profile` (global.css:245). Both clip at the content-box boundary identically, but `hidden` creates a scroll container needed for reliable `scrollHeight`. Reverted user's `minmax(0, 0fr)` and `min-height: 0` experiments.
- **Status:** Partially fixed — visual behavior significantly improved, animation covers more of the mobile profile. Remaining minor imperfection accepted as sufficient.

## Fixed (Session 120 — 2026-07-22)

### Mobile profile delayed 350ms on F5 reload in midpoint zone — MEDIUM
- **File:** `src/scripts/client.js`
- **Source:** [MANUAL]
- **Detected:** Session 120 | **Fixed:** Session 120
- **Root cause:** In `init()`, `updateMobileProfile()` at L782 ran BEFORE `sidebar-midpoint-mode` was added at L801. The condition `shouldShow = (mqlBreakpoint.matches || html.classList.contains('sidebar-midpoint-mode')) && currentPage === 'sobre'` evaluated to `false` because viewport was >1235px (mqlBreakpoint false) and sidebar-midpoint-mode not yet added. Mobile profile was hidden. A 350ms `setTimeout` at L810 re-called `updateMobileProfile()` after midpoint setup, but this delay was visible to the user.
- **Fix:** Moved midpoint setup block (`const initW` + class additions) from L795-803 to BEFORE `updateMobileProfile()` at L782. Removed the `setTimeout(() => { updateMobileProfile() }, 350)` at L810 — unnecessary because `sidebar-no-transition` suppresses sidebar transitions on fresh load. Kept the double-rAF `sidebar-no-transition` removal for subsequent resizes.

## Open (non-bug — intentional/neutral)

### Brand colors in badges — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Tool brand colors (#3776ab, #e76f00, etc.) are intentional design choices.
- **Status:** Intentional — no fix needed

### Empty experience.json — INFO
- **Source:** check-json-schema.ps1
- **Description:** No work experience to list yet. Section auto-hides.
- **Status:** Intentional — no fix needed

### Computational grid and fade gradient removed — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Checks for `#inicio` grid/gradient are stale — these were removed during the redesign.
- **Status:** Stale check — will be removed in next test maintenance

### .btn-outline not found — INFO
- **Source:** check-frontend-design.ps1
- **Description:** `.btn-outline` was renamed during migration. Test still looks for the old name.
- **Status:** Stale check — will be removed in next test maintenance

### Missing sticky nav — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Sidebar architecture uses `position: relative`, not `sticky`. The sidebar is always visible.
- **Status:** Stale check — will be removed in next test maintenance

### target=_blank without rel=noopener (false positive) — INFO
- **Source:** check-js-logic.ps1
- **Description:** Test detects `target="_blank"` in a comment line (line 109) that mentions the attribute. Actual code (line 117) has `rel="noopener noreferrer"`.
- **Status:** False positive — comment text triggers regex

### Orphan CSS classes — INFO
- **Source:** check-css-logic.ps1
- **Description:** `lang-btn`, `sidebar-name-first`, `lang-switcher` are used in `LangSwitcher.astro` (orphaned component not included in layout).
- **Status:** Low priority — component not used in production

### Unused --content-max-width variable — INFO
- **Source:** check-css-logic.ps1
- **Description:** `--content-max-width: 800px` defined in `:root` but never referenced.
- **Status:** Low priority — dead code, can be removed

---

## Automatic test findings (consolidated)

All findings below are from `run-all.ps1` test runs across sessions 90–103. Each entry represents a unique finding. Session list shows where it was detected.

### Computational grid not detected in #inicio — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** Stale check — computational grid was removed during redesign. Should be removed from test suite.
- **Status:** Pending (stale check)

### Missing fade gradient in #inicio::after — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** Stale check — fade gradient was removed during redesign. Should be removed from test suite.
- **Status:** Pending (stale check)

### .btn-outline not found — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** Stale check — `.btn-outline` was renamed. Test still looks for old name.
- **Status:** Pending (stale check)

### Missing sticky nav or sidebar — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** Stale check — sidebar architecture uses `position: relative`, not `sticky`.
- **Status:** Pending (stale check)

### target=_blank without rel=noopener — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** False positive — test detects attribute in a comment line (L109). Actual code has `rel="noopener noreferrer"`.
- **Status:** Pending (false positive)

### Predominantly single quotes — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** JS file uses predominantly single quotes (464–536 single vs 88 double across sessions). Code style convention — not a bug.
- **Status:** Pending (code style, not a bug)

### Classes referenced but missing CSS — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** `lang-btn`, `lang-switcher`, `sidebar-name-first` (and `tech-showcase` in some sessions) are referenced in HTML but have no CSS definitions. These are used in `LangSwitcher.astro` which is not included in the current layout.
- **Status:** Pending (orphaned component)

### CSS variables defined but possibly unused: --content-max-width — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** `--content-max-width: 800px` defined in `:root` but never referenced.
- **Status:** Pending (dead code)

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** No work experience to list yet. Section auto-hides via `toggleSection()`.
- **Status:** Pending (intentional)

### !important outside prefers-reduced-motion block — ERROR
- **Source:** check-css-logic.ps1
- **Detected:** Sessions 90, 91, 93, 95, 97, 99, 103
- **Description:** `!important` used in sidebar state classes (`sidebar-locked`, `sidebar-delayed`, `sidebar-no-transition`, `is-resizing`). These are intentional — the state classes must override any inline transition. Excluded from the `prefers-reduced-motion` check by test filter.
- **Status:** Pending (intentional, test false positive — filtered in Session 89)


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, lang-btn, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: lang-switcher, lang-btn, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, lang-btn, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: lang-switcher, lang-btn, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (520 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (520 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (514 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (514 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (514 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118
- **Description:** Predominantly single quotes (514 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118
- **Description:** experience.json empty
- **Status:** Pending

## Automatic findings (Session 118 -- 2026-07-22)

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### Predominantly single quotes (514 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 118 (automatic)
- **Status:** Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
