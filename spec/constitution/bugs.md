# Bugs conocidos — Alonso Suárez Reza Portfolio

Last scan: 2026-07-15 (Session 36 — lang-switcher fade + mobile sidebar fix)
Total: 0 FAIL(s), 4 WARN(s) — all false positives or intentional

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
- **File:** `src/styles/global.css` (old approach)
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Lang-switcher moved inside `<nav>` as inline flex element

### Social buttons width at ~480-550px — LOW
- **File:** `src/styles/global.css`
- **Source:** roadmap.md (manual review)
- **Detected:** Session 12 | **Fixed:** Session 17
- **Fix:** Added `box-sizing: border-box` and responsive width rules

## ✅ Fixed (Session 19 — 2026-07-09)

### .project-links missing flex-wrap (mobile overflow) — LOW
- **File:** `src/styles/global.css`
- **Source:** Mobile responsive analysis
- **Detected:** Session 18 | **Fixed:** Session 19
- **Fix:** Added `flex-wrap: wrap` to `.project-links`

### nav-overlay not covering full viewport (backdrop-filter containing block) — MEDIUM
- **File:** `src/components/Nav.astro`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Moved `.nav-overlay` outside `<nav>` to escape `backdrop-filter` containing block

### nav-links unclickable on mobile (z-index conflict) — HIGH
- **File:** `src/styles/global.css`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Changed `.nav-bar` z-index from 50 to 100 (above overlay's 99)

### CV button text compressed on mobile — LOW
- **File:** `src/styles/global.css`
- **Source:** Manual testing
- **Detected:** Session 19 | **Fixed:** Session 19
- **Fix:** Added `height: auto; min-height: 45px; padding: 12px 20px` to `.cv-btn` mobile rule

## 🔴 Open (non-bug — intentional/neutral)

### Brand colors in badges — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Tool brand colors (#3776ab, #e76f00, etc.) are intentional design choices. Not normalizable.
- **Status:** ⏳ Intentional — no fix needed

### Quote style preference — INFO
- **Source:** check-js-logic.ps1
- **Description:** Predominantly single quotes (~142 vs ~54 double). Style preference only.
- **Status:** ⏳ Low priority — unify if desired

### Tailwind utility classes flagged as "missing CSS" — INFO
- **Source:** check-css-logic.ps1
- **Description:** `mx-auto`, `flex`, `text-xs`, `text-justify` are Tailwind v4 utilities, not custom CSS. Test script doesn't filter Tailwind-generated classes.
- **Status:** ⏳ False positive — update test to ignore Tailwind classes

### Empty experience.json — INFO
- **Source:** check-json-schema.ps1
- **Description:** No work experience to list yet. Section auto-hides.
- **Status:** ⏳ Intentional — no fix needed

### prefers-reduced-motion false positive — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Test flags "Falta reset de .reveal en prefers-reduced-motion" and "Falta if (motionOK) en event listener" but both are correctly handled.
- **Status:** ⏳ False positive — update test

### btn-outline vs link-outline naming — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Test looks for `.btn-outline` but the class was renamed to `.link-outline` during migration.
- **Status:** ⏳ False positive — update test

### CSS variables in @theme no longer duplicated in :root — INFO
- **Source:** check-css-logic.ps1
- **Description:** `--animate-fade-in`, `--animate-fade-in-up`, `--animate-slide-in-left` exist only in `@theme`.
- **Status:** ⏳ False positive — confirmed used by Tailwind at build time

### frontend-design test reports "sticky" and "back-to-top" missing — INFO
- **Source:** check-frontend-design.ps1
- **Description:** Both `.nav-bar` (sticky + backdrop-filter) and `.back-to-top` button exist and are functional. Test regex may not match after Tailwind migration.
- **Status:** ⏳ False positive — update test patterns

### Test scripts encoding corruption — INFO
- **Source:** run-all.ps1
- **Description:** All `.ps1` test scripts under `.agents/tests/` contain non-ASCII characters (emojis, long dashes) that break PowerShell parsing on Windows (en pwsh 7). Cannot be run until encoding is fixed.
- **Status:** ⏳ Fix: convert files to UTF-8 without BOM and remove/replace non-ASCII characters in string literals


### Faltan variables en :root: --color-green — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Faltan variables en :root: --color-green
- **Status:** ⏳ Pending

### !important fuera del bloque prefers-reduced-motion: — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** !important fuera del bloque prefers-reduced-motion:
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta if (motionOK) en event listener
- **Status:** ⏳ Pending

### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 650px)
- **Status:** ⏳ Pending

### Faltan variables en :root: --color-green — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Faltan variables en :root: --color-green
- **Status:** ⏳ Pending

### !important fuera del bloque prefers-reduced-motion: — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** !important fuera del bloque prefers-reduced-motion:
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta if (motionOK) en event listener
- **Status:** ⏳ Pending

### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 650px)
- **Status:** ⏳ Pending

### init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections — ERROR
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections
- **Status:** ⏳ Pending

### init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections — ERROR
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections
- **Status:** ⏳ Pending

### lang.json not found or invalid — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** lang.json not found or invalid
- **Status:** ⏳ Pending

### profile.json incomplete: name, badges — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** profile.json incomplete: name, badges
- **Status:** ⏳ Pending

### skills.json has non-bilingual fields:  (title),  (description) — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** skills.json has non-bilingual fields:  (title),  (description)
- **Status:** ⏳ Pending

### lang.json not found or invalid — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** lang.json not found or invalid
- **Status:** ⏳ Pending

### profile.json incomplete: name, badges — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** profile.json incomplete: name, badges
- **Status:** ⏳ Pending

### skills.json has non-bilingual fields:  (title),  (description) — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** skills.json has non-bilingual fields:  (title),  (description)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### No se detecta cuadrícula computacional en #inicio — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** No se detecta cuadrícula computacional en #inicio
- **Status:** ⏳ Pending

### Falta gradiente de desvanecimiento en #inicio::after — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta gradiente de desvanecimiento en #inicio::after
- **Status:** ⏳ Pending

### No se encuentra .btn-outline — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** No se encuentra .btn-outline
- **Status:** ⏳ Pending

### Falta sticky o backdrop-filter en nav — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta sticky o backdrop-filter en nav
- **Status:** ⏳ Pending

### LangSwitcher sin margin-left — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** LangSwitcher sin margin-left
- **Status:** ⏳ Pending

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta botón back-to-top
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### No se detecta cuadrícula computacional en #inicio — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** No se detecta cuadrícula computacional en #inicio
- **Status:** ⏳ Pending

### Falta gradiente de desvanecimiento en #inicio::after — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta gradiente de desvanecimiento en #inicio::after
- **Status:** ⏳ Pending

### No se encuentra .btn-outline — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** No se encuentra .btn-outline
- **Status:** ⏳ Pending

### Falta sticky o backdrop-filter en nav — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta sticky o backdrop-filter en nav
- **Status:** ⏳ Pending

### LangSwitcher sin margin-left — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** LangSwitcher sin margin-left
- **Status:** ⏳ Pending

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta botón back-to-top
- **Status:** ⏳ Pending

### Predominantly single quotes (212 single vs 68 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (212 single vs 68 double)
- **Status:** ⏳ Pending

### Predominantly single quotes (212 single vs 68 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (212 single vs 68 double)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: nav-link, text-xs, nav-overlay, nav-bar, nav-toggle, nav-links, lang-switcher, nav-container, lang-btn, sidebar-name-first, mx-auto — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: nav-link, text-xs, nav-overlay, nav-bar, nav-toggle, nav-links, lang-switcher, nav-container, lang-btn, sidebar-name-first, mx-auto
- **Status:** ⏳ Pending

### !important outside block: — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** !important outside block:
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --content-max-width — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: nav-link, text-xs, nav-overlay, nav-bar, nav-toggle, nav-links, lang-switcher, nav-container, lang-btn, sidebar-name-first, mx-auto — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: nav-link, text-xs, nav-overlay, nav-bar, nav-toggle, nav-links, lang-switcher, nav-container, lang-btn, sidebar-name-first, mx-auto
- **Status:** ⏳ Pending

### !important outside block: — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** !important outside block:
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --content-max-width — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --content-max-width
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** experience.json empty
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ?
- **Description:** experience.json empty
- **Status:** ⏳ Pending

## 📡 Automatic findings (Session ? — 2026-07-15)

### Faltan variables en :root: --color-green — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### !important fuera del bloque prefers-reduced-motion: — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections — ERROR
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### lang.json not found or invalid — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### profile.json incomplete: name, badges — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### skills.json has non-bilingual fields:  (title),  (description) — ERROR
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### No se detecta cuadrícula computacional en #inicio — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta gradiente de desvanecimiento en #inicio::after — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### No se encuentra .btn-outline — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta sticky o backdrop-filter en nav — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### LangSwitcher sin margin-left — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Predominantly single quotes (212 single vs 68 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: nav-link, text-xs, nav-overlay, nav-bar, nav-toggle, nav-links, lang-switcher, nav-container, lang-btn, sidebar-name-first, mx-auto — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### !important outside block: — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --content-max-width — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
