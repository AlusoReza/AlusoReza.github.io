# 11 · MCP Tests — Plan

## Approach

Modular PowerShell scripts, each responsible for one concern (Astro MCP, design, JS, CSS, JSON, paths). A master runner orchestrates them, collects results, and saves findings to `bugs.md`.

## Implementation

1. **check-astro-mcp.ps1** — Greps for forbidden patterns (`onclick=`, `window.DATA`, `is:inline`) and required patterns (`data-data`, `data-lang`, `addEventListener`).
2. **check-frontend-design.ps1** — Greps CSS/JS/HTML for design token usage, font loading, grid motif, breakpoints, `!important` rule, emoji prohibition.
3. **check-js-logic.ps1** — Greps for missing `noopener`, missing null guards, undefined CSS classes referenced in JS.
4. **check-css-logic.ps1** — Greps for hardcoded colors, undefined classes, `!important` outside reduced-motion block.
5. **check-json-schema.ps1** — Parses each JSON and validates required fields, bilingual format, `url` prohibition.
6. **check-paths.ps1** — Verifies existence of referenced files (CV.pdf, perfil.jpg, favicon).
7. **run-all.ps1** — Runs all 6 scripts, parses output for FAIL/WARN counts, appends findings to `bugs.md`.

## Decisions

- **PowerShell over bash** — The project runs on Windows; PowerShell is the native shell.
- **Grep-based checks over unit tests** — Most checks verify absence of patterns (no hardcoded colors, no `onclick`) or presence of patterns (design tokens defined). Grep is simpler than a test framework.
- **Modular scripts over a single monolithic test** — Each layer can be run independently during development. The master runner provides the full picture.

## Risks

- **False positives in grep** — Grep patterns must be precise to avoid matching comments or unrelated strings. Mitigated by reviewing `[MANUAL]` items.
- **Test drift** — If a new hardcoded color is added, the test catches it. But if the CSS structure changes significantly, grep patterns may need updating.
