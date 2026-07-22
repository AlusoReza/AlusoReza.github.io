# Glossary — Alonso Suárez Reza Portfolio

## A
- **animateMobileProfile()**: JS function in `client.js` that animates MobileProfile height with explicit `scrollHeight` measurement. Replaced CSS `grid-template-rows` animation (Session 109).
- **Astro 5**: Static web framework (SSG) used to build the portfolio. Compiles HTML at build-time and sends minimal JS to the client.
- **addEventListener**: Standard JS method for assigning events. Replaces inline `onclick`.

## B
- **Build-driven logging**: Logging strategy where `npm run build` is the automatic trigger to review and complete the session log.

## C
- **changeLanguage()**: JS function in `client.js` that changes the active language and re-renders all dynamic sections.

## D
- **data-data**: Attribute on `<body>` that serializes all project JSONs. Read via `document.body.dataset.data`.
- **data-i18n**: HTML attribute for marking translatable elements. The value is the key in `lang.json`.
- **data-lang**: Attribute on language buttons. `client.js` selects it with `querySelectorAll('[data-lang]')`.

## E
- **ES**: Spanish (language code).
- **EN**: English (language code).

## F
- **Frontend-design skill**: opencode skill with frontend design instructions (CSS palettes, typography, spacing system, responsive).

## G
- **git diff**: Command used in the initial snapshot and post-build to detect changes.

## H
- **handleMobileProfile()**: JS function that orchestrates sequential animations when crossing the 1235px breakpoint. Manages `sidebar-locked`/`sidebar-delayed` classes and calls `animateMobileProfile()`.

## I
- **i18n**: Internationalization. Translation system based on `data-i18n` + `lang.json`.

## J
- **JSON.stringify()**: Method used in `BaseLayout.astro` to serialize the `dataBundle` into the `data-data` attribute on `<body>`.

## L
- **localStorage**: Stores the preferred language under the `preferredLang` key. Default: `es`.

## M
- **MCP**: Model Context Protocol / Astro MCP. Set of Astro 5 best practices (no inline events, data via attributes, no globals).
- **mqlBreakpoint**: `window.matchMedia('(max-width: 1235px)')` — JS media query listener aligned with CSS `@media (max-width: 1235px)`. Drives MobileProfile show/hide logic.
- **motionOK**: Boolean variable in `client.js` that detects `prefers-reduced-motion`. If `false`, it skips the scroll reveal.

## P
- **prefers-reduced-motion**: CSS media query for accessibility. Also detected in JS via `window.matchMedia()`.

## R
- **.reveal**: CSS class for scroll-triggered entrance animation. Has a reset in `prefers-reduced-motion`.

## S
- **SDD**: Specification-Driven Development. Approach where specifications (`spec/`) are the project's source of truth.
- **set:html**: Astro directive for rendering HTML in elements. Correctly used in Astro components (not in `<script>`).
- **Skill**: opencode plugin that provides specialized instructions for specific tasks (e.g., `frontend-design`).
- **snapProfileTimer**: Named timer in `client.js` that schedules `animateMobileProfile(true)` 350ms after `snapSidebarFade()` midpoint entry. Gated on `sidebar-midpoint-mode` to prevent re-expanding collapsed profile.
- **snapSidebarFade()**: JS function called on mouseup or 1000ms fallback timer. Snaps `--sidebar-fade` to 0 or 1 based on viewport position in fade zone (1236-1336px).
- **sidebar-delayed**: CSS class that delays sidebar transitions 350ms while MobileProfile collapses. Applied when growing past 1235px.
- **sidebar-locked**: CSS class that freezes `--sidebar-fade` at 0 during MobileProfile slide-in animation. Applied when shrinking past 1235px.
- **sidebar-midpoint-mode**: CSS class that duplicates `@media (max-width:1235px)` rules, allowing JS to activate mobile layout in the 1236-1285px range.

## T
- **t()**: Helper function that resolves bilingual fields: `t({ es: "...", en: "..." })` → returns the current language value.
- **toggleSection()**: JS function that hides/shows sections based on whether their data array is empty.
