# Bugs conocidos — Alonso Suárez Reza Portfolio

# Known bugs — Alonso Suárez Reza Portfolio

Last scan: 2026-06-25 (Session ?)
Total: 4 FAIL(s), 20 WARN(s) — see details per section

## 🔴 Unfixed

### Mixed-language on initial load with EN saved — HIGH
- **File:** `src/scripts/client.js:136`
- **Source:** check-js-logic.ps1 + [MANUAL]
- **Detected:** Session 8
- **Description:** `init()` calls `translateUI()` but never `renderAll()`. Visitor with English saved in localStorage sees skills, projects, education, experience, certificates in Spanish. Only nav and headings are translated.
- **Proposed fix:** Call `changeLanguage(savedLang)` at end of `init()` or `renderAll()` if `savedLang !== 'es'`
- **Status:** ⏳ Pending

### CV PDF does not exist (404) — MEDIUM
- **File:** `src/components/Contact.astro:9`, `src/components/Profile.astro:22`
- **Source:** check-paths.ps1
- **Detected:** Session 8
- **Description:** The href points to `assets/Alonso_Reza_CV.pdf` but the file does not exist in `public/assets/`. All visitors get 404.
- **Proposed fix:** Place the PDF in `public/assets/Alonso_Reza_CV.pdf` or update the paths
- **Status:** ⏳ Pending

### 📄 icon destroyed on language switch — MEDIUM
- **File:** `src/components/Contact.astro:10`
- **Source:** [MANUAL]
- **Detected:** Session 8
- **Description:** The 📄 icon is inside the `<span data-i18n="cv-text-f">`. `translateUI()` does `el.innerHTML = langData[key]` and the `lang.json` strings do not include the icon. In `Profile.astro` it is correctly separated.
- **Proposed fix:** Separate icon from data-i18n span: `<span class="icon">📄</span><span data-i18n="cv-text-f">Download...</span>`
- **Status:** ⏳ Pending

### btn-primary undefined in CSS — LOW
- **File:** `src/components/Projects.astro:18`, `src/scripts/client.js:61`
- **Source:** check-js-logic.ps1, check-css-logic.ps1
- **Detected:** Session 8
- **Description:** Class `btn-primary` used in project buttons but no CSS definition.
- **Proposed fix:** Define `.btn-primary` in CSS or remove the class
- **Status:** ⏳ Pending

### target=_blank without rel=noopener (×4) — LOW
- **File:** `Contact.astro:13,17`, `Projects.astro:18`, `client.js:61`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8
- **Description:** LinkedIn, GitHub, project links (SSR + client) without `rel="noopener noreferrer"`.
- **Proposed fix:** Add `rel="noopener noreferrer"` to all 4 links
- **Status:** ⏳ Pending

### changeLanguage without early return — LOW
- **File:** `src/scripts/client.js:93`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8
- **Description:** Clicking already-active language runs full `renderAll()` unnecessarily.
- **Proposed fix:** Add `if (lang === currentLang) return;`
- **Status:** ⏳ Pending

### getElementById without null guard (×2) — LOW
- **File:** `src/scripts/client.js:97,142`
- **Source:** check-js-logic.ps1
- **Detected:** Session 8
- **Description:** `document.getElementById(...).classList.add('active')` throws TypeError if lang is unexpected.
- **Proposed fix:** `const btn = document.getElementById(...); if (btn) btn.classList.add('active')`
- **Status:** ⏳ Pending

### #1a1f26 hardcoded in .badge — LOW
- **File:** `src/styles/global.css:195`
- **Source:** check-css-logic.ps1, check-frontend-design.ps1
- **Detected:** Session 8
- **Description:** `background-color: #1a1f26` hardcoded. Should use `var(--color-bg-card)`.
- **Proposed fix:** Replace `#1a1f26` with `var(--color-bg-card)`
- **Status:** ⏳ Pending

### Inconsistent asset paths — LOW
- **File:** `profile.json`, `Contact.astro:9`
- **Source:** check-paths.ps1
- **Detected:** Session 8
- **Description:** Relative CV paths (`assets/...`) vs absolute (`/assets/...`) for favicon/profile.
- **Proposed fix:** Use consistent `/assets/Alonso_Reza_CV.pdf`
- **Status:** ⏳ Pending

### HTML classes without CSS definition — LOW
- **File:** `src/styles/global.css`, multiple components
- **Source:** check-css-logic.ps1
- **Detected:** Session 9
- **Description:** `badges`, `text`, `section`, `profile-text` used as HTML classes without direct CSS selector. May be intentional (compound selectors) or residual.
- **Proposed fix:** Verify and define if needed or remove references
- **Status:** ⏳ Pending

## 🟡 Partially fixed
*(empty)*

## ✅ Fixed
*(empty)*


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

### CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf — ERROR
- **Source:** check-paths.ps1
- **Detected:** Session ?
- **Description:** CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf
- **Status:** ⏳ Pending

### CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf — ERROR
- **Source:** check-paths.ps1
- **Detected:** Session ?
- **Description:** CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado: — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** #1a1f26 hardcodeado:
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)), #10a37f (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)), #10a37f (1 use(s)) - intencionales pero no normalizables
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado: — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** #1a1f26 hardcodeado:
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)), #10a37f (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)), #10a37f (1 use(s)) - intencionales pero no normalizables
- **Status:** ⏳ Pending

### changeLanguage has no early return — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** changeLanguage has no early return
- **Status:** ⏳ Pending

### target=_blank sin rel=noopener: — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank sin rel=noopener:
- **Status:** ⏳ Pending

### btn-primary used in client.js, 1 componente(s) Astro but NOT defined in CSS — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** btn-primary used in client.js, 1 componente(s) Astro but NOT defined in CSS
- **Status:** ⏳ Pending

### Predominantly single quotes (96 single vs 46 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (96 single vs 46 double)
- **Status:** ⏳ Pending

### changeLanguage has no early return — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** changeLanguage has no early return
- **Status:** ⏳ Pending

### target=_blank sin rel=noopener: — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** target=_blank sin rel=noopener:
- **Status:** ⏳ Pending

### btn-primary used in client.js, 1 componente(s) Astro but NOT defined in CSS — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** btn-primary used in client.js, 1 componente(s) Astro but NOT defined in CSS
- **Status:** ⏳ Pending

### Predominantly single quotes (96 single vs 46 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (96 single vs 46 double)
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado en 1 sitio(s): — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** #1a1f26 hardcodeado en 1 sitio(s):
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: badges, profile-text, text, section, btn-primary (usado en HTML/JS pero sin CSS) — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: badges, profile-text, text, section, btn-primary (usado en HTML/JS pero sin CSS)
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado en 1 sitio(s): — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** #1a1f26 hardcodeado en 1 sitio(s):
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: badges, profile-text, text, section, btn-primary (usado en HTML/JS pero sin CSS) — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: badges, profile-text, text, section, btn-primary (usado en HTML/JS pero sin CSS)
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

### Relative CV paths (inconsistent with absolute favicon): — WARNING
- **Source:** check-paths.ps1
- **Detected:** Session ?
- **Description:** Relative CV paths (inconsistent with absolute favicon):
- **Status:** ⏳ Pending

### Relative CV paths (inconsistent with absolute favicon): — WARNING
- **Source:** check-paths.ps1
- **Detected:** Session ?
- **Description:** Relative CV paths (inconsistent with absolute favicon):
- **Status:** ⏳ Pending

## 📡 Automatic findings (Session ? — 2026-06-25)

### init() does NOT call renderAll() - visitor with EN saved sees mixed ES/EN sections — ERROR
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf — ERROR
- **Source:** check-paths.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado: — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)), #10a37f (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### changeLanguage has no early return — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### target=_blank sin rel=noopener: — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### btn-primary used in client.js, 1 componente(s) Astro but NOT defined in CSS — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Predominantly single quotes (96 single vs 46 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### #1a1f26 hardcodeado en 1 sitio(s): — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: badges, profile-text, text, section, btn-primary (usado en HTML/JS pero sin CSS) — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Relative CV paths (inconsistent with absolute favicon): — WARNING
- **Source:** check-paths.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
