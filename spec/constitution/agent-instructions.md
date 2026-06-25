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
├── constitution/    — Metaspec SDD, agent instructions, project overview,
│                       roadmap, changelog
├── features/        — 13 módulos detallados (contratos, flujo, diseño, tests…)
├── template/        — Plantillas (AGENTS_TEMPLATE.md, spec-template.md)
└── glossary.md      — Definiciones del dominio (SDD, MCP, data-data…)

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
├── bitacora.md          — Resumen global escaneable del flujo de trabajo
├── certificates/        — PDFs de certificados (ignorados por git, solo .gitkeep)
└── logs/                — Logs detallados por día (YYYY-MM-DD.md)

.agents/
├── skills/              — Skills instaladas (frontend-design)
├── tests/               — Scripts de verificación (check-mcp.ps1, check-frontend-design.ps1)
└── skills-lock.json     — Registro de skills

public/
├── assets/               — perfil.jpg, favicon.ico (CV.pdf optional)
└── certificates/.gitkeep — (mantenido por compatibilidad)
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
- **Contexto histórico:** Si el usuario pregunta o hace referencia a algo trabajado en sesiones anteriores y no está en tu ventana de contexto actual, escanea automáticamente `docs/logs/` y `docs/bitacora.md` para reconstruir el contexto antes de responder.
- **Session log (IMPORTANTE — SIEMPRE, build-driven):**
  1. **BEFORE — snapshot inicial**: antes del primer cambio de la sesión, ejecutar `git diff` y `git diff --stat` para capturar el estado limpio. Crear `docs/logs/YYYY-MM-DD.md` si no existe. Añadir `## Sesión N — Título descriptivo` con `### Prompt` (resumen de lo que pidió el usuario) y, si ya hay plan aprobado, `### Plan`.
  2. **AFTER EVERY BUILD** (inmediatamente después de `npm run build`, `npm run update` o cualquier comando que compile):
     - Capturar el output completo del build (éxito/fallo, tiempo, errors, warnings).
     - Ejecutar `git diff --stat` y `git diff` para identificar TODOS los archivos modificados desde el snapshot inicial.
     - Consultar `docs/logs/YYYY-MM-DD.md`:
       - **¿Hay una sesión activa?** — una sesión con `### Prompt` y `### Plan` pero que le falta `### Cambios` o `### Build`. → Completarla: rellenar `### Cambios` con cada archivo modificado (rutas, líneas, descripción del cambio y por qué) y `### Build` con el comando ejecutado, resultado, tiempo, y cualquier warning/error relevante.
       - **¿NO hay sesión activa?** (el build ocurrió sin que se creara previamente una cabecera de sesión) → Crear una nueva sesión desde cero: auto-generar `### Prompt` reconstruido del contexto reciente de la conversación, escribir `### Cambios` a partir del `git diff`, y escribir `### Build` con el comando y output capturados.
     - Actualizar `docs/bitacora.md` con una entrada resumida (fecha, sesión, prompt breve + plan en 2-3 líneas).
     - Resetear el snapshot inicial con `git diff --stat` para que el próximo build solo capture cambios nuevos.
  3. **No hay excepciones.** Este check se ejecuta después de CADA build, haya o no sesión previa. Si no hay cambios detectados por `git diff`, indicarlo explícitamente en `### Cambios`.

## Tests
- **"Comprueba MCP"** → el agente ejecuta `.agents/tests/check-mcp.ps1` y revisa los resultados. FAILs graves reciben plan de corrección; WARNs se discuten contigo.
- **"Comprueba skill"** → el agente ejecuta `.agents/tests/check-frontend-design.ps1` y revisa los resultados. FAILs graves reciben plan de corrección; WARNs requieren decisión estética tuya.
- **Output esperado:** cada test muestra PASS/FAIL/WARN por check, más un resumen y un plan de acción detallado para cada incumplimiento.
- **Protocolo:** el agente ejecuta el script, captura su output, y te propone el plan de acción. No aplica correcciones automáticas sin tu aprobación explícita.

## Documentation
- [README.md](../README.md) — project overview and social links
- [LICENSE](../LICENSE) — MIT license
