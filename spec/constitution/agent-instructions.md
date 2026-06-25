# Alonso Suárez Reza — Portfolio

Static portfolio site built with **Astro 5** (static output), vanilla CSS, and vanilla JS. Data-driven bilingual (ES/EN) single-page site hosted on GitHub Pages.

## Stack
- **Framework:** Astro 5 (static, no SSR)
- **Languages:** HTML (Astro `.astro`), CSS3 (vanilla, imported), JavaScript (vanilla ES module)
- **Runtime:** Build-time (Node) + Browser (client JS)
- **Database:** None
- **Tests:** `.agents/tests/check-mcp.ps1` (MCP) + `.agents/tests/check-frontend-design.ps1` (frontend-design skill)

## Commands
- `npm run dev` — Start Astro dev server (usually `http://localhost:4321`)
- `npm run build` — Build to `dist/`
- `npm run preview` — Preview the built `dist/` folder
- `npm run update` — `astro build && npx live-server dist/ --port=5501`
- **Deploy:** Push to `main` — GitHub Pages auto-serves from root at `https://alusoreza.github.io/`

## Project structure
```
spec/
├── constitution/    — SDD metadocs: project overview, agent instructions,
│                       roadmap, changelog, bugs
├── features/        — 14 detailed feature specs (contracts, flow, design, tests…)
├── template/        — Templates (AGENTS_TEMPLATE.md, spec-template.md)
└── glossary.md      — Domain definitions (SDD, MCP, data-data…)

src/
├── components/       — 10 Astro components (Nav, LangSwitcher, Profile, About,
│                       Skills, Education, Projects, Experience, Certificates, Contact)
├── layouts/
│   └── BaseLayout.astro  — HTML shell, Nav, LangSwitcher, data-data attribute on body,
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

docs/
├── bitacora.md          — Global scannable workflow summary
├── certificates/        — Certificate PDFs (ignored by git, only .gitkeep)
└── logs/                — Detailed logs by day (YYYY-MM-DD.md)

.agents/
├── skills/              — Installed skills (frontend-design)
├── tests/               — Verification scripts (check-mcp.ps1, check-frontend-design.ps1)
└── skills-lock.json     — Skill registry

public/
├── assets/               — perfil.jpg, favicon.ico (CV.pdf optional)
└── certificates/.gitkeep — (kept for compatibility)
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
- **data-data:** All JSONs serialized into a `data-data` attribute on `<body>` via `JSON.stringify()`. Client JS reads from `document.body.dataset.data` (browser auto-decodes HTML entities), no fetch calls or globals.

## Architecture
1. **Build time (Astro):** Renders all sections statically in Spanish. `data-i18n` attributes preserved in HTML for client-side translation. Profile badges rendered by Astro. Empty experience/certificates arrays render section with `style="display:none"`. All JSON data serialized into `data-data` attribute on `<body>`.
2. **Client side (client.js):** On page load, reads `JSON.parse(document.body.dataset.data)`, loads saved language from `localStorage`. If non-default or dynamic content needed, calls `changeLanguage()` which re-renders all sections from the data object. ES/EN buttons use `addEventListener` via `data-lang` attributes — no inline handlers.

## Don'ts
- **No `url` field in certificates** — do not include URLs in `src/data/certificates.json`.
- **No touching Astro components for content** — all dynamic content comes from JSON.
- **No committing certificate PDFs** — everything inside `docs/certificates/` except `.gitkeep` is gitignored.
- **No removing `docs/certificates/.gitkeep`** — keeps the empty folder tracked.
- **No frameworks or build tools beyond Astro** — no npm packages beyond Astro & its deps.

## Workflow
- Before a non-trivial task, propose a plan and wait for approval.
- One task at a time; when finished, state what was changed for review.
- If not at least 80% sure, ask. Do not guess or invent.
- **Adding a certificate:**
  1. Drop the PDF into `docs/certificates/`
  2. Ask: "Add the certificate from `docs/certificates/file-name.pdf`"
  3. Agent reads the PDF with `pypdf` (`PdfReader`), extracts `title`, `institution`, `date`, `description`
  4. Agent writes the entry to `src/data/certificates.json` using the bilingual format
  5. Section auto-appears on page reload (hidden if array is empty)
- **Adding content:** Edit the corresponding JSON file in `src/data/` — no component changes required.
- **Historical context:** If the user asks about or references work from previous sessions that is not in your current context window, automatically scan `docs/logs/` and `docs/bitacora.md` to reconstruct the context before responding.
- **Session log (IMPORTANT — ALWAYS, build-driven):**
  1. **BEFORE — initial snapshot**: before the first change of the session, run `git diff` and `git diff --stat` to capture the clean state. Create `docs/logs/YYYY-MM-DD.md` if it does not exist. Add `## Session N — Descriptive title` with `### Prompt` (summary of what the user requested) and, if a plan was approved, `### Plan`.
  2. **AFTER EVERY BUILD** (immediately after `npm run build`, `npm run update` or any compile command):
     - Capture the full build output (success/failure, time, errors, warnings).
     - Run `git diff --stat` and `git diff` to identify ALL files modified since the initial snapshot.
     - Check `docs/logs/YYYY-MM-DD.md`:
       - **Is there an active session?** — a session with `### Prompt` and `### Plan` but missing `### Changes` or `### Build`. → Complete it: fill in `### Changes` with each modified file (paths, lines, change description and why) and `### Build` with the command, result, time, and any relevant warnings/errors.
       - **Is there NO active session?** (the build occurred without a prior session header) → Create a new session from scratch: auto-generate `### Prompt` reconstructed from recent conversation context, write `### Changes` from `git diff`, and write `### Build` with the command and captured output.
     - Update `docs/bitacora.md` with a summary entry (date, session, brief prompt + plan in 2-3 lines).
     - Reset the initial snapshot with `git diff --stat` so the next build only captures new changes.
  3. **No exceptions.** This check runs after EVERY build, whether or not a prior session exists. If no changes are detected by `git diff`, state this explicitly in `### Changes`.

## Tests
- **"Comprueba MCP"** → the agent runs `.agents/tests/run-all.ps1` and reviews results. Critical FAILs receive a fix plan; WARNs are discussed with you.
- **Output expected:** each test shows PASS/FAIL/WARN per check, plus a summary and detailed action plan for each violation.
- **Protocol:** the agent runs the script, captures its output, and proposes the action plan. Does not apply automatic fixes without your explicit approval.

## Language Policy
- **AI documentation language:** All content in `AGENTS.md`, `spec/`, `.agents/tests/`, and `docs/bitacora.md` must be written in English, regardless of the conversation language with the user.
- **Session logs:** `docs/logs/` preserve the original chat language (entries are written in whatever language the conversation was held).
- **Future additions:** Any new file created under `spec/`, `.agents/tests/`, or `docs/bitacora.md` must be written in English. If the user requests content in another language for these files, translate it to English before writing.

## Documentation
- [README.md](../README.md) — project overview and social links
- [LICENSE](../LICENSE) — MIT license
