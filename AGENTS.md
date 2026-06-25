# Alonso Su\u00e1rez Reza \u2014 Portfolio

Static portfolio site built with vanilla HTML, CSS, and JavaScript. No frameworks, no build tools, no dependencies. Hosted on GitHub Pages.

## Stack
- **Languages:** HTML5, CSS3, JavaScript (vanilla, no transpilers)
- **Runtime:** Browser only
- **Database:** None
- **Tests:** None

## Commands
- `npx live-server --port=5501` or open `index.html` with VS Code Live Server (port 5501 per `.vscode/settings.json`)
- **Deploy:** Push to `main` \u2014 GitHub Pages auto-serves from root at `https://alusoreza.github.io/`

## Project structure
```
index.html            \u2014 Single-page portfolio (Spanish default, lang="es")
css/style.css         \u2014 Dark GitHub theme (714 lines)
js/script.js          \u2014 Data-driven i18n, rendering, scroll-reveal, back-to-top
data/lang.json        \u2014 Static UI strings only (nav, about, contact)
data/profile.json     \u2014 Name, badges (language + tools)
data/skills.json      \u2014 Skill items (bilingual)
data/education.json   \u2014 Education entries (bilingual)
data/projects.json    \u2014 Featured projects (bilingual)
data/experience.json  \u2014 Work experience (bilingual, empty = hidden)
data/certificates.json\u2014 Certificates (bilingual, empty = hidden)
certificates/.gitkeep \u2014 Folder for certificate PDFs (contents ignored by git)
assets/               \u2014 perfil.jpg, favicon.ico, CV.pdf
```

## Conventions
- **Data-driven:** Skills, education, projects, experience, certificates render from their JSON files. Edit a JSON file to add content \u2014 no HTML changes.
- **Bilingual fields:** Every translatable field uses `{ "es": "...", "en": "..." }`. Plain strings for language-neutral values.
- **i18n static UI:** Nav, about paragraphs, contact use `data-i18n` attributes on HTML elements, keyed to `data/lang.json`.
- **i18n dynamic content:** Use the `t()` helper: `t({ es: "Hola", en: "Hello" })` resolves to the current language.
- **Language:** Persists in `localStorage` (`preferredLang`). Default: `es`. Switch via ES/EN buttons.
- **Auto-hide:** Experience and certificates sections auto-hide when their array is empty (`toggleSection()` in JS).
- **Design:** Dark theme (`#0d1117` bg, `#c9d1d9` text), accent blue `#58a6ff`, scroll-triggered reveal (`.reveal`), responsive at 650px.
- **Skills section:** Two `.personality-note` paragraphs \u2014 work approach (`hab-note`) and AI/LLM/agents (`hab-ai`).
- **Badges:** Language badges (border-left accent) + tool badges (solid background, glow hover). AI Agents badge in tool badges (green `#10a37f`).

## Don'ts
- **No frameworks or build tools** \u2014 no npm, no node_modules, no bundlers.
- **No `url` field in certificates** \u2014 do not include URLs in `data/certificates.json`.
- **No touching HTML for content** \u2014 all dynamic content comes from JSON files.
- **No committing certificate PDFs** \u2014 everything inside `certificates/` except `.gitkeep` is gitignored.
- **No removing `.gitkeep`** \u2014 it keeps the empty folder tracked in git.

## Workflow
- Before a non-trivial task, propose a plan and wait for approval.
- One task at a time; when finished, state what was changed for review.
- If not at least 80% sure, ask. Do not guess or invent.
- **Adding a certificate:**
  1. Drop the PDF into `certificates/`
  2. Ask: "Add the certificate from `certificates/file-name.pdf`"
  3. Agent reads the PDF with `pypdf` (`PdfReader`), extracts `title`, `institution`, `date`, `description`
  4. Agent writes the entry to `data/certificates.json` using the bilingual format
  5. Section auto-appears on page reload (hidden if array is empty)
- **Adding content:** Edit the corresponding JSON file in `data/` \u2014 no HTML changes required.

## Documentation
- [README.md](./README.md) \u2014 project overview and social links
- [LICENSE](./LICENSE) \u2014 MIT license
