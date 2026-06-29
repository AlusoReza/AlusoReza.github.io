# 12 · Design tests — Plan

## Approach

Each design rule from the frontend-design skill is translated into a grep check. The script is self-contained (no dependencies beyond PowerShell) and uses regex to scan CSS, JS, and Astro files.

## Implementation

1. Each check is a self-contained block that outputs `[PASS]`, `[FAIL]`, or `[WARN]` with context.
2. Checks are organized by concern: tokens, accessibility, responsive, typography, colors, components.
3. The script counts PASS/FAIL/WARN and prints a summary at the end.

## Decisions

- **Grep over AST parsing** — PowerShell has no CSS/JS parser built in. Grep with careful patterns is adequate for the depth of checking needed.
- **FAIL vs WARN distinction** — FAIL = objectively wrong (hardcoded color that should be var). WARN = aesthetic judgment (brand colors in badges — intentional but flagged).
- **No automatic fixes** — Design decisions require human judgment. The script flags issues, the agent proposes a fix plan, the user approves.

## Risks

- **False positives** — Grep patterns may match non-applicable lines. Mitigated by reviewing the output.
- **Pattern drift** — If CSS naming changes (e.g., `.badge` renamed), the corresponding check must be updated.
