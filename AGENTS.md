# AGENTS.md

**Static portfolio site** — vanilla HTML/CSS/JS, no build tools, no dependencies.

## Quick start
- **Preview locally:** Open `index.html` with Live Server (port 5501 per `.vscode/settings.json`) or any static file server
- **Deploy:** Push to `main` — GitHub Pages serves from root at `https://alusoreza.github.io/`

## Project structure
```
index.html            — Single-page portfolio (Spanish default, `lang="es"`)
css/style.css         — Dark GitHub theme
js/script.js          — Data-driven i18n, rendering, scroll-reveal, back-to-top
data/lang.json        — Static UI strings only (nav, about, contact)
data/profile.json     — Name, badges
data/skills.json      — Skill items (bilingual)
data/education.json   — Education entries (bilingual)
data/projects.json    — Featured projects (bilingual)
data/experience.json  — Work experience (bilingual, empty = hidden)
data/certificates.json— Certificates (bilingual, empty = hidden)
certificates/.gitkeep — Folder for certificate PDFs (contents ignored by git)
assets/               — perfil.jpg, favicon.ico, CV.pdf
```

## Data-driven sections
- Skills, education, projects, experience, certificates render from their JSON files.
- Experience and certificates sections auto-hide when their array is empty (`toggleSection()` in JS).
- To add content, edit the corresponding JSON file — no HTML changes needed.
- Every bilingual field uses `{ "es": "...", "en": "..." }`; plain strings for language-neutral values.

## i18n
- Static UI (nav, about paragraphs, contact) is in `data/lang.json` with `data-i18n` attributes.
- Dynamic content uses the `t()` helper: `t({ es: "Hola", en: "Hello" })` resolves to current language.
- Language persists in `localStorage` (`preferredLang`). Default: `es`.

## Adding a certificate
1. Drop the PDF into `certificates/`
2. Ask the agent: "Add the certificate from `certificates/mi-cert.pdf`"
3. Agent reads the PDF with `pypdf` (`PdfReader`), extracts:
   - `title` — course/program name
   - `institution` — issuing entity
   - `date` — completion/issue date
   - `description` — brief summary of what was covered (duration, topics)
4. Agent writes the entry to `data/certificates.json` in this format:
   ```json
   {
     "title": { "es": "...", "en": "..." },
     "institution": { "es": "...", "en": "..." },
     "date": { "es": "...", "en": "..." },
     "description": { "es": "...", "en": "..." }
   }
   ```
5. **Do NOT include `url` field** — the user does not want URLs in certificates.
6. Section appears automatically on page reload. If no certificates exist, section is hidden.

## Design conventions
- Dark theme (`#0d1117` background, `#c9d1d9` text, GitHub-inspired)
- Accent blue: `#58a6ff`
- Scroll-triggered reveal animations (class `.reveal`)
- Responsive breakpoint at 650px
- Skills section has two `.personality-note` paragraphs: one about work approach (`hab-note`), one about AI/LLM/agents (`hab-ai`)
- Education no longer includes courses/certifications sub-section (removed)
- Badges include an **AI Agents** tool badge (green `#10a37f`); AI is also mentioned in the `hab-ai` paragraph

## What is NOT here
- No package.json, no npm/yarn, no build step
- No tests, no lint, no typecheck
- No CI/CD workflows
- No backend or server-side code
