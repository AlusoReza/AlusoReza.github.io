# Bugs conocidos — Alonso Suárez Reza Portfolio

# Known bugs — Alonso Suárez Reza Portfolio

Last scan: 2026-06-29 (Session 18 — workflow template + docs/logs protocol)
Total: 0 FAIL(s), 8 WARN(s) — all intentional/neutral

## ✅ Fixed (Session 12 — 2026-06-29)

### Mixed-language on initial load with EN saved — HIGH
- **File:** `src/scripts/client.js:136`
- **Source:** check-js-logic.ps1 + [MANUAL]
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `if (savedLang !== 'es') renderAll();` at end of `init()`

### CV PDF does not exist (404) — MEDIUM
- **File:** `src/components/Contact.astro:9`, `src/components/Profile.astro:22`
- **Source:** check-paths.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** User placed PDF at `public/assets/Alonso_Reza_CV.pdf`; paths updated to `/assets/...` (absolute)

### 📄 icon destroyed on language switch — MEDIUM
- **File:** `src/components/Contact.astro:10`
- **Source:** [MANUAL]
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Separated icon into `<span class="icon">📄</span>` outside `data-i18n` span

### btn-primary undefined in CSS — LOW
- **File:** `src/components/Projects.astro:18`, `src/scripts/client.js:61`
- **Source:** check-js-logic.ps1, check-css-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Replaced `btn-primary` with `btn-outline` (existing defined class)

### target=_blank without rel=noopener (×4) — LOW
- **File:** `Contact.astro:13,17`, `Projects.astro:18`, `client.js:61`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `rel="noopener noreferrer"` to all 4 external links

### changeLanguage without early return — LOW
- **File:** `src/scripts/client.js:93`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Added `if (lang === currentLang) return;`

### #1a1f26 hardcoded in .badge — LOW
- **File:** `src/styles/global.css:195`
- **Source:** check-css-logic.ps1, check-frontend-design.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Replaced `#1a1f26` with `var(--color-bg-card)`

### Inconsistent asset paths — LOW
- **File:** `profile.json`, `Contact.astro:9`
- **Source:** check-paths.ps1
- **Detected:** Session 8 | **Fixed:** Session 12
- **Fix:** Changed both to absolute `/assets/Alonso_Reza_CV.pdf`

### Lang switcher overflow on very small screens — LOW
- **File:** `src/styles/global.css` (old `position: fixed` approach)
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Lang-switcher moved inside `<nav>` as inline flex element (no `position: fixed`)

### Social buttons width at ~480-550px — LOW
- **File:** `src/styles/global.css`
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Added `box-sizing: border-box` to `.social-btns a` and `.cv-cta-button`; `flex: 1 1 200px` at 650px; `width: 100%; max-width: 280px; flex: none` at 480px

## 🔴 Open (non-bug — intentional/neutral)

### Brand colors in badges — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Tool brand colors (#3776ab, #e76f00, etc.) are intentional design choices per `.b-python`, `.b-java`, etc. Not normalizable.
- **Status:** ⏳ Intentional — no fix needed

### Quote style preference — INFO
- **Source:** check-js-logic.ps1
- **Description:** Predominantly single quotes (98 vs 48 double). Style preference only, no functional impact.
- **Status:** ⏳ Low priority — unify if desired

### HTML classes without direct CSS selector — INFO
- **Source:** check-css-logic.ps1
- **Description:** `badges`, `section`, `profile-text`, `text` used as parent containers for compound selectors. Functional CSS applied via children/nested selectors. Not a bug.
- **Status:** ⏳ Intentional — no fix needed

### Empty experience.json — INFO
- **Source:** check-json-schema.ps1
- **Description:** No work experience to list yet. Section auto-hides.
- **Status:** ⏳ Intentional — no fix needed
