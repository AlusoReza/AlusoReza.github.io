# 11 · MCP Tests

**Status:** implemented ✅

## What it does

Defines the modular test system that verifies the portfolio's compliance with Astro 5 best practices, JavaScript logic, CSS standards, JSON schemas, and file paths.

### Architecture
```
.agents/tests/
├── run-all.ps1               ← Master: executes all and summarizes, saves to bugs.md
├── check-astro-mcp.ps1       ← 16 checks — Astro 5 compliance
├── check-frontend-design.ps1 ← 22 checks — design system compliance
├── check-js-logic.ps1        ← ~7 checks — JS flaws (null guards, noopener, etc.)
├── check-css-logic.ps1       ← ~5 checks — hardcoded colors, undefined classes
├── check-json-schema.ps1     ← ~13 checks — JSON schema validation
└── check-paths.ps1           ← ~7 checks — file path integrity
```

### Master runner (`run-all.ps1`)
- Runs the 6 scripts sequentially.
- Collects all FAILs and WARNs.
- Prints `[MANUAL]` section with deep logic items the agent must review.
- **Automatically saves findings to `spec/constitution/bugs.md`** under `🔴 Sin arreglar`.

## Why

Automated verification catches mechanical bugs before they reach production. The modular structure allows running individual checks during development and the full suite before deployment.

## Acceptance criteria

- [ ] `run-all.ps1` executes all 6 modules and produces a summary.
- [ ] Each check prints `[PASS]`, `[FAIL]` or `[WARN]` with file, line, and suggested action.
- [ ] FAILs are automatically saved to `bugs.md`.
- [ ] All 6 modules exist and are executable.

## Out of scope

- Unit tests for individual JS functions — coverage is provided by logic checks.
- End-to-end browser tests — the site is simple enough for static analysis.
