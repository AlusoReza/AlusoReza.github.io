# Alonso Suárez Reza — Portfolio

Static portfolio site built with **Astro 5** (static output), vanilla CSS, and vanilla JS. Data-driven bilingual (ES/EN) single-page site hosted on GitHub Pages.

## Stack
- **Framework:** Astro 5 (static, no SSR)
- **Languages:** HTML (Astro `.astro`), CSS3 (vanilla, imported), JavaScript (vanilla ES module)
- **Runtime:** Build-time (Node) + Browser (client JS)
- **Database:** None
- **Tests:** None

## Commands
- `npm run dev` — Start Astro dev server (usually `http://localhost:4321`)
- `npm run build` — Build to `dist/`
- `npm run preview` — Preview the built `dist/` folder
- `npm run update` — `astro build && npx live-server dist/ --port=5501`
- **Deploy:** Push to `main` — GitHub Pages auto-serves from root at `https://alusoreza.github.io/`

## Project structure
```
src/
├── components/       — 10 Astro components (Nav, LangSwitcher, Profile, About,
│                       Skills, Education, Projects, Experience, Certificates, Contact)
├── layouts/
│   └── BaseLayout.astro  — HTML shell, Nav, LangSwitcher, window.DATA inline script,
│                           client.js bundle
├── pages/
│   └── index.astro       — Single-page entry (imports all components)
├── scripts/
│   └── client.js         — Client-side JS (i18n, rendering, scroll-reveal, back-to-top)
├── styles/
│   └── global.css        — Dark GitHub theme (imported by layout → Astro bundles it)
└── data/                 — 7 JSON files (unchanged bilingual format)
    ├── lang.json
    ├── profile.json
    ├── skills.json
    ├── education.json
    ├── projects.json
    ├── experience.json
    └── certificates.json

public/
├── assets/               — perfil.jpg, favicon.ico (CV.pdf optional)
├── certificates/.gitkeep — Folder for certificate PDFs (contents ignored by git)
templates/                — AGENTS_TEMPLATE.md (structure reference)
assets/                   — Original static assets (to be removed)
css/                      — Original CSS (to be removed)
js/                       — Original JS (to be removed)
data/                     — Original data JSONs (to be removed)
index.html                — Original single-page (to be removed)
```

## Conventions
- **Data-driven:** All sections render from `src/data/*.json`. Edit a JSON file — no component changes needed.
- **Bilingual fields:** Every translatable field uses `{ "es": "...", "en": "..." }`. Plain strings for language-neutral values.
- **i18n static UI:** Nav, about paragraphs, contact use `data-i18n` attributes on HTML elements, keyed to `src/data/lang.json`.
- **i18n dynamic content:** Use `t()` helper: `t({ es: "Hola", en: "Hello" })` resolves to current language.
- **Language:** Persists in `localStorage` (`preferredLang`). Default: `es`. Switch via ES/EN buttons.
- **Auto-hide:** Experience and certificates sections auto-hide when empty array (Astro renders `display:none` + JS `toggleSection()`).
- **Design:** Dark theme (`#0d1117` bg, `#c9d1d9` text), accent blue `#58a6ff`, scroll-triggered reveal (`.reveal`), responsive at 650px.
- **Badges:** Language badges (border-left accent) + tool badges (solid background, glow hover). AI Agents badge in tool badges (green `#10a37f`). Rendered at build time by Astro Profile component.
- **window.DATA:** All JSONs stringified into a global `window.DATA` object via an inline `<script is:inline set:html>` in BaseLayout. Client JS reads from this, no fetch calls.

## Architecture
1. **Build time (Astro):** Renders all sections statically in Spanish. `data-i18n` attributes preserved in HTML for client-side translation. Profile badges rendered by Astro. Empty experience/certificates arrays render section with `style="display:none"`.
2. **Client side (client.js):** On page load, runs `init()` which loads saved language from `localStorage`. If non-default, calls `changeLanguage()` which re-renders all dynamic sections from `window.DATA`. ES/EN buttons call `changeLanguage()` directly — no page reload.

## Don'ts
- **No `url` field in certificates** — do not include URLs in `src/data/certificates.json`.
- **No touching Astro components for content** — all dynamic content comes from JSON.
- **No committing certificate PDFs** — everything inside `public/certificates/` except `.gitkeep` is gitignored.
- **No removing `public/certificates/.gitkeep`** — keeps the empty folder tracked.
- **No frameworks or build tools beyond Astro** — no npm packages beyond Astro & its deps.

## Workflow
- Before a non-trivial task, propose a plan and wait for approval.
- One task at a time; when finished, state what was changed for review.
- If not at least 80% sure, ask. Do not guess or invent.
- **Adding a certificate:**
  1. Drop the PDF into `public/certificates/`
  2. Ask: "Add the certificate from `certificates/file-name.pdf`"
  3. Agent reads the PDF with `pypdf` (`PdfReader`), extracts `title`, `institution`, `date`, `description`
  4. Agent writes the entry to `src/data/certificates.json` using the bilingual format
  5. Section auto-appears on page reload (hidden if array is empty)
- **Adding content:** Edit the corresponding JSON file in `src/data/` — no component changes required.

## Documentation
- [README.md](./README.md) — project overview and social links
- [LICENSE](./LICENSE) — MIT license
