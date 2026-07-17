# Tech stack and conventions

## Technologies

- **Language:** HTML (Astro `.astro`), CSS3 (vanilla, imported), JavaScript (vanilla ES module)
- **Framework / runtime:** Astro 5 (static SSG, no SSR)
- **Database:** None
- **Tests:** `.agents/tests/run-all.ps1` (master runner — 6 modules)
- **Deployment:** GitHub Pages — auto-serves from root at `https://alusoreza.github.io/` on push to `main`

## Key files / modules

- `src/layouts/BaseLayout.astro` — HTML shell, Nav, LangSwitcher, `data-data` attribute on `<body>`, client.js bundle
- `src/scripts/client.js` — Client-side JS (i18n, rendering, scroll-reveal, back-to-top)
- `src/styles/global.css` — Dark GitHub theme (imported by layout, bundled by Astro)
- `src/data/*.json` — 7 JSON files (bilingual data contracts)
- `src/components/*.astro` — 10 Astro components (rendering only, no business logic)
- `.agents/tests/` — Test scripts (`run-all.ps1` + 6 check modules)
- `docs/logs/` — Session logs by day (`YYYY-MM-DD.md`)
- `docs/bitacora.md` — Global scannable workflow summary

## Commands

- `npm run dev` — Start Astro dev server (port 4321)
- `npm run build` — Build to `dist/`
- `npm run preview` — Preview the built `dist/` folder
- `npm run update` — `astro build && npx live-server dist/ --port=5501`
- **Deploy:** Push to `main` — GitHub Pages auto-serves

## Conventions

- **Data-driven:** All sections render from `src/data/*.json`. Edit a JSON file — no component changes needed.
- **Bilingual fields:** Translatable fields: `{ "es": "...", "en": "..." }`. Plain strings for language-neutral values.
- **i18n static UI:** Use `data-i18n` attributes on HTML elements, keyed to `src/data/lang.json`.
- **i18n dynamic content:** Use `t()` helper: `t({ es: "Hola", en: "Hello" })` resolves to current language.
- **Language:** Persists in `localStorage` (`preferredLang`). Default: `es`. Switch via ES/EN buttons.
- **Auto-hide:** Experience and certificates sections auto-hide when their data array is empty.
- **data-data:** All JSONs serialized into `data-data` attribute on `<body>` via `JSON.stringify()`. Client JS reads from `document.body.dataset.data` (browser auto-decodes HTML entities), no fetch calls or globals.
- **No inline event handlers** — Use `data-lang` + `addEventListener` instead of `onclick`.
- **No globals** — `window.DATA` and `window.changeLanguage` are not exposed.

## Design tokens

| Token | Value | Usage |
|-------|-------|-------|
| `--color-bg` | `#0d1117` | Main background (GitHub dark) |
| `--color-bg-card` | `#161b22` | Card and section background |
| `--color-bg-hover` | `#1c2128` | Card hover background |
| `--color-border` | `#30363d` | Borders and separators |
| `--color-text` | `#c9d1d9` | Main text |
| `--color-text-bright` | `#f0f6fc` | Bright text (headings, hover) |
| `--color-text-muted` | `#8b949e` | Secondary text, metadata |
| `--color-accent` | `#7fc1fe` | Electric blue (links, hover, name) |
| `--color-green` | `#3fb950` | Accent green (badges, skill hover) |
| `--font-display` | `'Space Grotesk', sans-serif` | Display (h1, h2, badges, labels) |
| `--font-body` | `'Inter', -apple-system, ...` | Body text |

## Visual design

- **Theme:** Dark GitHub theme, no light theme toggle (planned).
- **Layout:** Single column, max-width 850px, centered. Sticky nav with backdrop blur.
- **Signature motif:** Computational grid on hero (28px spacing, 2% white opacity, linear-gradient fade).
- **Badges:** Language badges (border-left accent) + tool badges (solid background, glow hover). AI Agents badge in `#10a37f`.
- **Reveal animations:** Scroll-triggered `.reveal` / `.reveal.active` with 0.8s ease-out, 30px Y offset.
- **Responsive:** 650px (tablet) and 480px (small mobile) breakpoints.
- **Accessibility:** `prefers-reduced-motion` respected in CSS (universal `!important` override) and JS (no scroll listener).

## Hard limits

- **No `url` field in certificates** — do not include URLs in `src/data/certificates.json`.
- **No touching Astro components for content** — all dynamic content comes from JSON.
- **No committing certificate PDFs** — everything inside `docs/certificates/` except `.gitkeep` is gitignored.
- **No removing `docs/certificates/.gitkeep`** — keeps the empty folder tracked.
- **No frameworks or build tools beyond Astro** — no npm packages beyond Astro & its deps.
- **No `!important` outside the `prefers-reduced-motion` block** — the universal `!important` override is intentional and exclusive to that block.
- **No hardcoded color values outside `:root`** — use `var(--color-*)` throughout.
- **No commits without user approval** — never run `git commit`, `git push`, `gh pr create`, or any git operation that modifies remote state without the user's explicit, prior written approval.
- **No extrapolating commit approval** — even if the user approves a commit in one session, that approval does NOT carry over. Every commit requires fresh, explicit approval.
