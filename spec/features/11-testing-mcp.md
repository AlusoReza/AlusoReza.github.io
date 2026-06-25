# 11 — MCP Tests (full suite)

## Purpose

Defines the modular test system that verifies the portfolio's compliance with Astro 5 best practices, design, JavaScript logic, CSS, JSON schemas, and file paths.

## Architecture

Tests are modularized into independent scripts per layer, executed by a master runner:

```
.agents/tests/
├── run-all.ps1               ← Master: executes all and summarizes, saves to bugs.md
├── check-astro-mcp.ps1       ← 16 checks Astro MCP
├── check-frontend-design.ps1 ← 22 design checks
├── check-js-logic.ps1        ← JS logic flaws (null guards, noopener, etc.)
├── check-css-logic.ps1       ← CSS logic flaws (#1a1f26, undefined classes)
├── check-json-schema.ps1     ← JSON schema validation (bilingual contracts)
└── check-paths.ps1           ← File path integrity (CV.pdf, assets)
```

### Master runner (`run-all.ps1`)
- Runs the 6 scripts sequentially
- Collects all FAILs and WARNs
- Prints `[MANUAL]` section with deep logic items
- **Automatically saves findings to `spec/constitution/bugs.md`**

## Checks per module

### check-astro-mcp.ps1 (16 checks)
| # | Check | Método |
|---|-------|--------|
| 1 | No onclick | grepHtml `onclick=` |
| 2 | No is:inline | grepHtml `is:inline` |
| 3 | No window.DATA | grepJs `window\.DATA` |
| 4 | data-data | grepAstro `data-data=` |
| 5-16 | (ver script completo) | — |

### check-frontend-design.ps1 (22 checks)
CSS variables, circular refs, !important, prefers-reduced-motion, responsive, typography, color palette, grid, components.

### check-js-logic.ps1 (~7 checks)
Null guards, early returns, missing `noopener`, undefined CSS class references, `window.*` globals, `init()` flow.

### check-css-logic.ps1 (~5 checks)
Hardcoded colors (`#1a1f26`, residual `#ffffff`), undefined classes, `!important` outside reduced-motion, unused variables.

### check-json-schema.ps1 (~13 checks)
Contracts for all JSONs: required fields, bilingual format, `url` prohibition in certificates, dates.

### check-paths.ps1 (~7 checks)
Existence of referenced files (CV.pdf, perfil.jpg, favicon), path consistency, integrity of `docs/certificates/`.

## Output
Each check prints `[PASS]`, `[FAIL]` or `[WARN]` with the file, line and suggested action.

## Rules
- FAILs receive an automatic correction plan in the summary.
- WARNs are discussed with the user before taking action.
- All findings are saved to `spec/constitution/bugs.md` before any correction.

## Dependencies
- [Feature 14](14-bug-tracking.md) — Bug tracking (saves findings to bugs.md)

## Relevant code
- `.agents/tests/run-all.ps1` — master runner
- `.agents/tests/check-*-.ps1` — individual scripts
- `spec/constitution/bugs.md` — bug registry
