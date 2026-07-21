# Bugs known — Alonso Suarez Reza Portfolio

Last scan: 2026-07-21 (Session ?)
Status: All previously identified bugs fixed. Test scripts updated to match current project structure.

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


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 90
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 90
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (464 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 90
- **Description:** Predominantly single quotes (464 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 90
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (464 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 90
- **Description:** Predominantly single quotes (464 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: tech-showcase, lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 90
- **Description:** Classes referenced but missing CSS: tech-showcase, lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 90
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: tech-showcase, lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 90
- **Description:** Classes referenced but missing CSS: tech-showcase, lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 90
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 90
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 90
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (462 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** Predominantly single quotes (462 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (462 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** Predominantly single quotes (462 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 91
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 91
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 91
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (462 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** Predominantly single quotes (462 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (462 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 91
- **Description:** Predominantly single quotes (462 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 91
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 91
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 91
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (472 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (472 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (472 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (472 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending


### !important outside prefers-reduced-motion block: -- ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** !important outside prefers-reduced-motion block:
- **Status:** Pending

### !important outside prefers-reduced-motion block: -- ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** !important outside prefers-reduced-motion block:
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### !important outside block: -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** !important outside block:
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### !important outside block: -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** !important outside block:
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 93
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 93
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 93
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 93
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (470 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** Predominantly single quotes (470 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 95
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 95
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 95
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (474 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** Predominantly single quotes (474 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (474 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 95
- **Description:** Predominantly single quotes (474 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 95
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 95
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 95
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (476 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** Predominantly single quotes (476 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (476 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** Predominantly single quotes (476 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 97
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 97
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 97
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 97
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 97
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 97
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 97
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (484 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** Predominantly single quotes (484 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (484 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** Predominantly single quotes (484 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 99
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 99
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 99
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (488 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** Predominantly single quotes (488 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (488 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 99
- **Description:** Predominantly single quotes (488 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** Classes referenced but missing CSS: lang-btn, lang-switcher, sidebar-name-first
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 99
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 99
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 99
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (492 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** Predominantly single quotes (492 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (492 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** Predominantly single quotes (492 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 101
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 101
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 101
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 101
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** Classes referenced but missing CSS: lang-switcher, sidebar-name-first, lang-btn
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 101
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 101
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 101
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 102
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 102
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 102
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 102
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 102
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 102
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 102
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 102
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 102
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 102
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 102
- **Description:** experience.json empty
- **Status:** Pending


### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Computational grid not detected in #inicio
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Missing fade gradient in #inicio::after
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** .btn-outline not found
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session 105
- **Description:** Missing sticky nav or sidebar
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 105
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 105
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 105
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session 105
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 105
- **Description:** Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 105
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 105
- **Description:** Classes referenced but missing CSS: lang-btn, sidebar-name-first, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session 105
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 105
- **Description:** experience.json empty
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session 105
- **Description:** experience.json empty
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

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (494 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (494 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
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

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
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

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: sidebar-name-first, lang-btn, lang-switcher
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

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank without rel=noopener:
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (478 single vs 88 double)
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

## Automatic findings (Session ? -- 2026-07-21)

### Computational grid not detected in #inicio -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### Missing fade gradient in #inicio::after -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### .btn-outline not found -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### Missing sticky nav or sidebar -- WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### target=_blank without rel=noopener: -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### Predominantly single quotes (478 single vs 88 double) -- WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### Classes referenced but missing CSS: sidebar-name-first, lang-switcher, lang-btn -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### CSS variables defined but possibly unused: --content-max-width -- WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

### experience.json empty -- WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
