# Bitácora — Alonso Suárez Reza Portfolio

Global workflow summary. Each entry links to the detailed day log.

---

## 2026-06-25

[Detailed log →](logs/2026-06-25.md)

### Session 1: MCP Refactoring
**Prompt:** Align the code with Astro 5 best practices.
**Plan:** Replace inline script `is:inline set:html` with `data-data` attribute on `<body>`. Migrate `onclick` to `data-lang` + `addEventListener`. Remove `window.changeLanguage`. Add `tsconfig.json` and `.agents/` directory.

### Session 2: Design Refactoring
**Prompt:** Apply the frontend-design skill to improve portfolio aesthetics.
**Plan:** Choose Space Grotesk + Inter as the typographic system. Refine palette (accent `#7fc1fe`, secondary `#f0a030`). Add computational grid as hero background. Reformulate subtitle as professional thesis. Remove emojis from headings.

### Session 3: Color and subtitle fix
**Prompt:** The page renders white, hovers are invisible, the subtitle is too narrative.
**Plan:** Critical bugfix in `:root` (self-referential variables → real dark theme values). Migrate `.btn-outline` from light-theme to dark-theme colors. Simplify hero-sub to "Desarrollador de software" + "Full Stack · IA · Agentes".

### Session 4: Automatic logging system
**Prompt:** Create an automatic log system that records all agent sessions (detailed plan, changes, build) and a global summary. Apply retroactively.
**Plan:** Create `docs/logs/YYYY-MM-DD.md` with detailed sessions, `docs/bitacora.md` with global summary, modify `AGENTS.md` with mandatory logging workflow.

### Session 5: Context anchoring and log update
**Prompt:** Question "What did we do so far?" — structured summary provided. Then it is noted that the current session log was not updated following the protocol.
**Plan:** Create missing Session 5 entry in `docs/logs/2026-06-25.md` and `docs/bitacora.md`. No portfolio changes — only logging correction.

### Session 6: MCP and Frontend Design Tests
**Prompt:** Add two tests: one for Astro MCP compliance and one for frontend-design skill compliance. Display failures on screen and propose action plan.
**Plan:** Create `.agents/tests/check-mcp.ps1` (16 checks) and `.agents/tests/check-frontend-design.ps1` (21→22 checks). Hybrid option: scripts for mechanical checks + manual semantic review. Update AGENTS.md with `## Tests`. Create missing `.gitkeep` and `skills-lock.json`. Afterwards, fix WARN 1 (`#ffffff` → `var(--color-text-bright)`) and verify with successful build.

### Session 7: Full SDD restructure
**Prompt:** Complete project documentation following SDD.
**Plan:** Create `spec/constitution/` (5 metadocs), `spec/features/` (index + 13 modular specs), `spec/template/` (spec-template + AGENTS_TEMPLATE), `spec/glossary.md`. Move `certificates/` → `docs/certificates/`. Update `.gitignore` and structure in `AGENTS.md`.

### Session 8: Orphan certificate cleanup
**Prompt:** Root `certificates/` still had PDFs after SDD migration.
**Plan:** Move PDFs to `docs/certificates/`, delete root, verify gitignore + no downloads. Confirm AGENTS.md workflow is well defined.

### Session 9: Modular tests + bug tracking
**Prompt:** Create modular test suite (6 scripts + run-all.ps1), bug tracking system in bugs.md, expand AGENTS.md with workflows.
**Plan:** check-js-logic, check-css-logic, check-json-schema, check-paths, run-all.ps1. bugs.md with 11 bugs. Bug tracking protocol in AGENTS.md + feature 14 spec. Debug script issues.

## 2026-06-26

[Detailed log →](logs/2026-06-26.md)

### Session 10: SDD Spec Refactor — flat files → template structure
**Prompt:** Refactor `spec/` to match the new `spec_template/` structure. Every feature must have `spec.md` + `plan.md` + `tasks.md`. Constitution restructured per template. No information loss.
**Plan:** Constitution: README, mission, tech-stack, roadmap (Done/Next/Backlog), keep changelog + bugs. Features: 14 folders × 3 files (42 total), thin features filled from source code. Remove 18 old flat files. Clean bugs.md duplicates. Update AGENTS.md project structure.

## 2026-06-29

[Detailed log →](logs/2026-06-29.md)

### Session 11: Add BIG SCHOOL certificate
**Prompt:** Replace `Guia-Markdown...PDF` with actual certificate (`Certificado-Alonso-Jose-Suarez-Reza-32z2bo0a.pdf`), extract metadata, add to `certificates.json`.
**Plan:** Read PDF (image-based, no extractable text), ask user for details, insert entry as 2nd element in JSON array. Build + verify.

### Session 12: Bug fix sprint
**Prompt:** Review bugs.md and roadmap.md, elaborate plan to fix all bugs, and execute.
**Plan:** 9 fixes in 6 files: init() renderAll, 📄 icon, btn-primary→btn-outline, noopener, early return, #1a1f26→var(--color-bg-card), CV absolute paths, lang switcher overflow, social buttons width. Build + tests + clean bugs.md.

### Session 13: Badges + certificate addition
**Prompt:** Add LaTeX, Overleaf, Excel badges. Add Bootcamp Metodologías Ágiles as 3rd certificate (info from CV).
**Plan:** profile.json +3 badges, global.css +3 CSS classes, certificates.json +1 entry. Build + tests.

### Session 14: XML/JSON + Batch/Bash badges; rename AI Agents; subtitle
**Prompt:** Add XML/JSON and Batch/Bash badges (2+2). Change AI Agents → OpenCode/Claude (naranja). Change subtitle to Full Stack · Agentes · Data.
**Plan:** profile.json +2 badges, rename AI Agents; global.css +2 classes, rename .b-aiagents; lang.json hero-sub.

### Session 15: Deep bug review
**Prompt:** Complete project check for more bugs.
**Plan:** Run tests + deep manual review. Fix stale fallback in Profile.astro. Update [MANUAL] section in test suite.

### Session 16: Conditional nav links
**Prompt:** Hide "Experiencia" in nav when no data. Apply same for "Certificados".
**Plan:** Nav.astro conditional links via experience.length and certificates.length.

### Session 17: Nav flexbox + lang-switcher inline + box-sizing social buttons
**Prompt:** Lang-switcher escapes nav on small screens; social buttons overflow viewport.
**Plan:** Move lang-switcher inside nav (eliminar position:fixed), restructure nav with flexbox, add box-sizing:border-box to social buttons and CV button, fix responsive rules. Update tests. Clean bugs.md.

### Session 18: Workflow template with docs/logs protocol
**Prompt:** Create a template with the complete action plan so any AI can replicate the working methodology. Include how docs/bitacora.md and docs/logs/ interact.
**Plan:** Create `spec/template/workflow-template.md` (9 sections) covering session lifecycle, plan-first, build-driven logging with file hierarchy, bug tracking, testing, commits, language policy, context recovery, quality gates. Update spec template README.

## 2026-07-09

[Detailed log →](logs/2026-07-09.md)

### Session 19: Mobile hamburger nav + responsive refinements + test sweep
**Prompt:** Fix `.project-links` overflow, make nav a hamburger drawer on mobile, fix overlay click, fix z-index for link clicks, fix CV button compression, run tests, clean bugs.md, update logs.
**Plan:** 10-step plan covering CSS fixes, nav restructure (toggle + drawer + overlay), z-index fixes, CV button padding, test suite run, bugs.md cleanup (eliminated ~1000 duplicate lines), log update.
