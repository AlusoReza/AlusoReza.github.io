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


### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
- **Status:** ⏳ Pending

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (98 single vs 48 double)
- **Status:** ⏳ Pending

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (98 single vs 48 double)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: profile-text, text, badges, section — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: profile-text, text, badges, section
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: profile-text, text, badges, section — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: profile-text, text, badges, section
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

## 📡 Automatic findings (Session ? — 2026-07-09)

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: profile-text, text, badges, section — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*


### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 650px)
- **Status:** ⏳ Pending

### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 650px)
- **Status:** ⏳ Pending

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 480px)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 480px)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (98 single vs 48 double)
- **Status:** ⏳ Pending

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (98 single vs 48 double)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: whitespace-nowrap, mx-auto, rounded-full, font-[family-name:var(--font-display)], edu-date, bg-none, m-0, mt-5, lang-switcher, mb-2, inline-block, text, mt-0, mt-1, edu-header, edu-list, mb-5, ml-1.5, sticky, edu-description, rounded-lg, grid, relative, badges, mb-7, text-justify, contact-subtitle, text-[1.2em], edu-institution, mb-1, mt-[100px], divider, text-xs, education-item, project-card, size-[170px], mb-[25px], lang-btn, mb-2.5, project-links, flex, skill-item, mt-[25px] — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: whitespace-nowrap, mx-auto, rounded-full, font-[family-name:var(--font-display)], edu-date, bg-none, m-0, mt-5, lang-switcher, mb-2, inline-block, text, mt-0, mt-1, edu-header, edu-list, mb-5, ml-1.5, sticky, edu-description, rounded-lg, grid, relative, badges, mb-7, text-justify, contact-subtitle, text-[1.2em], edu-institution, mb-1, mt-[100px], divider, text-xs, education-item, project-card, size-[170px], mb-[25px], lang-btn, mb-2.5, project-links, flex, skill-item, mt-[25px]
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --color-bg-hover — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --color-bg-hover
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: whitespace-nowrap, mx-auto, rounded-full, font-[family-name:var(--font-display)], edu-date, bg-none, m-0, mt-5, lang-switcher, mb-2, inline-block, text, mt-0, mt-1, edu-header, edu-list, mb-5, ml-1.5, sticky, edu-description, rounded-lg, grid, relative, badges, mb-7, text-justify, contact-subtitle, text-[1.2em], edu-institution, mb-1, mt-[100px], divider, text-xs, education-item, project-card, size-[170px], mb-[25px], lang-btn, mb-2.5, project-links, flex, skill-item, mt-[25px] — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: whitespace-nowrap, mx-auto, rounded-full, font-[family-name:var(--font-display)], edu-date, bg-none, m-0, mt-5, lang-switcher, mb-2, inline-block, text, mt-0, mt-1, edu-header, edu-list, mb-5, ml-1.5, sticky, edu-description, rounded-lg, grid, relative, badges, mb-7, text-justify, contact-subtitle, text-[1.2em], edu-institution, mb-1, mt-[100px], divider, text-xs, education-item, project-card, size-[170px], mb-[25px], lang-btn, mb-2.5, project-links, flex, skill-item, mt-[25px]
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --color-bg-hover — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --color-bg-hover
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

## 📡 Automatic findings (Session ? — 2026-07-09)

### Falta @media (max-width: 650px) — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
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

### Predominantly single quotes (98 single vs 48 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: whitespace-nowrap, mx-auto, rounded-full, font-[family-name:var(--font-display)], edu-date, bg-none, m-0, mt-5, lang-switcher, mb-2, inline-block, text, mt-0, mt-1, edu-header, edu-list, mb-5, ml-1.5, sticky, edu-description, rounded-lg, grid, relative, badges, mb-7, text-justify, contact-subtitle, text-[1.2em], edu-institution, mb-1, mt-[100px], divider, text-xs, education-item, project-card, size-[170px], mb-[25px], lang-btn, mb-2.5, project-links, flex, skill-item, mt-[25px] — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --color-bg-hover — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*


### Falta reset de .reveal en prefers-reduced-motion — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta reset de .reveal en prefers-reduced-motion
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

### Falta reset de .reveal en prefers-reduced-motion — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta reset de .reveal en prefers-reduced-motion
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

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 480px)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta @media (max-width: 480px)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Predominantly single quotes (108 single vs 62 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (108 single vs 62 double)
- **Status:** ⏳ Pending

### Predominantly single quotes (108 single vs 62 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (108 single vs 62 double)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mb-[25px], text-justify, grid, mb-2, whitespace-nowrap, mb-7, rounded-lg, font-[family-name:var(--font-display)], mb-5, inline-block, lang-switcher, flex, text-[1.2em], sticky, mt-[100px], mx-auto, ml-1.5, rounded-full, mt-[25px], mb-2.5, text, contact-subtitle, text-xs, relative, size-[170px], badges, mt-5, mt-0, mb-1, mt-1, bg-none, lang-btn, divider, m-0 — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: mb-[25px], text-justify, grid, mb-2, whitespace-nowrap, mb-7, rounded-lg, font-[family-name:var(--font-display)], mb-5, inline-block, lang-switcher, flex, text-[1.2em], sticky, mt-[100px], mx-auto, ml-1.5, rounded-full, mt-[25px], mb-2.5, text, contact-subtitle, text-xs, relative, size-[170px], badges, mt-5, mt-0, mb-1, mt-1, bg-none, lang-btn, divider, m-0
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-slide-in-left, --color-bg-hover, --animate-fade-in, --animate-fade-in-up — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --animate-slide-in-left, --color-bg-hover, --animate-fade-in, --animate-fade-in-up
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mb-[25px], text-justify, grid, mb-2, whitespace-nowrap, mb-7, rounded-lg, font-[family-name:var(--font-display)], mb-5, inline-block, lang-switcher, flex, text-[1.2em], sticky, mt-[100px], mx-auto, ml-1.5, rounded-full, mt-[25px], mb-2.5, text, contact-subtitle, text-xs, relative, size-[170px], badges, mt-5, mt-0, mb-1, mt-1, bg-none, lang-btn, divider, m-0 — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: mb-[25px], text-justify, grid, mb-2, whitespace-nowrap, mb-7, rounded-lg, font-[family-name:var(--font-display)], mb-5, inline-block, lang-switcher, flex, text-[1.2em], sticky, mt-[100px], mx-auto, ml-1.5, rounded-full, mt-[25px], mb-2.5, text, contact-subtitle, text-xs, relative, size-[170px], badges, mt-5, mt-0, mb-1, mt-1, bg-none, lang-btn, divider, m-0
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-slide-in-left, --color-bg-hover, --animate-fade-in, --animate-fade-in-up — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --animate-slide-in-left, --color-bg-hover, --animate-fade-in, --animate-fade-in-up
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

## 📡 Automatic findings (Session ? — 2026-07-09)

### Falta reset de .reveal en prefers-reduced-motion — ERROR
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

### Falta @media (max-width: 480px) — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .skill-item strong, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
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

### Predominantly single quotes (108 single vs 62 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mb-[25px], text-justify, grid, mb-2, whitespace-nowrap, mb-7, rounded-lg, font-[family-name:var(--font-display)], mb-5, inline-block, lang-switcher, flex, text-[1.2em], sticky, mt-[100px], mx-auto, ml-1.5, rounded-full, mt-[25px], mb-2.5, text, contact-subtitle, text-xs, relative, size-[170px], badges, mt-5, mt-0, mb-1, mt-1, bg-none, lang-btn, divider, m-0 — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-slide-in-left, --color-bg-hover, --animate-fade-in, --animate-fade-in-up — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*


### Falta reset de .reveal en prefers-reduced-motion — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta reset de .reveal en prefers-reduced-motion
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta if (motionOK) en event listener
- **Status:** ⏳ Pending

### Falta reset de .reveal en prefers-reduced-motion — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta reset de .reveal en prefers-reduced-motion
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta if (motionOK) en event listener
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta botón back-to-top
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta --font-display en: h2, .profile-text h1, .edu-header strong
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables
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

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ?
- **Description:** Falta botón back-to-top
- **Status:** ⏳ Pending

### Predominantly single quotes (108 single vs 54 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (108 single vs 54 double)
- **Status:** ⏳ Pending

### Predominantly single quotes (108 single vs 54 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ?
- **Description:** Predominantly single quotes (108 single vs 54 double)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mx-auto, flex, text-justify, text-xs — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: mx-auto, flex, text-justify, text-xs
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-fade-in, --animate-fade-in-up, --animate-slide-in-left — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --animate-fade-in, --animate-fade-in-up, --animate-slide-in-left
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mx-auto, flex, text-justify, text-xs — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** Classes referenced but missing CSS: mx-auto, flex, text-justify, text-xs
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-fade-in, --animate-fade-in-up, --animate-slide-in-left — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ?
- **Description:** CSS variables defined but possibly unused: --animate-fade-in, --animate-fade-in-up, --animate-slide-in-left
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

## 📡 Automatic findings (Session ? — 2026-07-09)

### Falta reset de .reveal en prefers-reduced-motion — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta if (motionOK) en event listener — ERROR
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Falta --font-display en: h2, .profile-text h1, .edu-header strong — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Colores de marca en badges: #3776ab (2 use(s)), #e76f00 (2 use(s)), #f7df1e (2 use(s)), #00758f (3 use(s)), #734f96 (2 use(s)), #007acc (1 use(s)), #2c2255 (1 use(s)), #1a6ac9 (1 use(s)), #710900 (1 use(s)) - intencionales pero no normalizables — WARNING
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

### Falta botón back-to-top — WARNING
- **Source:** check-frontend-design.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Predominantly single quotes (108 single vs 54 double) — WARNING
- **Source:** check-js-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### Classes referenced but missing CSS: mx-auto, flex, text-justify, text-xs — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### CSS variables defined but possibly unused: --animate-fade-in, --animate-fade-in-up, --animate-slide-in-left — WARNING
- **Source:** check-css-logic.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

### experience.json empty — WARNING
- **Source:** check-json-schema.ps1
- **Detected:** Session ? (automatic)
- **Status:** ⏳ Pending

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
