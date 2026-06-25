# Changelog — Alonso Suárez Reza Portfolio

## 2026-06-25 — Sessions 1-9

### Session 1 — MCP Refactoring
- Replaced inline script `is:inline set:html` with `data-data` attribute on `<body>`
- Migrated `onclick` to `data-lang` + `addEventListener`
- Removed `window.DATA` and `window.changeLanguage`
- Added `tsconfig.json` (extends `astro/tsconfigs/base`)
- Created `.agents/skills/frontend-design/SKILL.md`

### Session 2 — Design Refactoring
- Typography: Space Grotesk (display) + Inter (body)
- Palette: accent `#7fc1fe`, 11 `:root` variables with real values
- Computational grid as hero background
- Subtitle reformulated as professional thesis
- Removed emojis from headings

### Session 3 — Color and subtitle fix
- Critical bugfix: self-referential `:root` variables → real values
- `.btn-outline` migrated from light theme to dark theme
- Hero simplified: "Desarrollador de software / Software developer"
- Tags: "Backend · Datos · Sistemas" → "Full Stack · IA · Agentes"

### Session 4 — Automatic logging system
- Created `docs/logs/` with `YYYY-MM-DD.md` format
- Created `docs/bitacora.md` as global summary
- AGENTS.md updated with build-driven workflow

### Session 5 — Context anchoring and log update
- Structured summary of all work done
- Corrected logging protocol

### Session 6 — MCP and Frontend Design Tests
- Created `.agents/tests/check-mcp.ps1` (16 checks)
- Created `.agents/tests/check-frontend-design.ps1` (22 checks)
- Added missing `skills-lock.json`
- AGENTS.md: added `## Tests` section
- Fixed 7 `color: #ffffff` → `var(--color-text-bright)`

### Session 7 — SDD Restructure
- Created `spec/` with `constitution/`, `features/`, `template/`
- Moved root `certificates/` → `docs/certificates/`
- Moved `spec_template/AGENTS_TEMPLATE.md` → `spec/template/`
- Created 21 SDD specification files
- AGENTS.md: updated project structure and certificate paths
- `.gitignore`: updated `certificates/` → `docs/certificates/`
