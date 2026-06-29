# 12 · Design tests

**Status:** implemented ✅

## What it does

Defines the 22 checks in `check-frontend-design.ps1` that verify compliance with the frontend-design skill. Each check greps for a specific design element or anti-pattern.

### Check list
| # | Check | Method |
|---|-------|--------|
| 1 | Design tokens defined in `:root` | grepCss `--color-` |
| 2 | No circular variable references | grepCss for self-referencing `var()` |
| 3 | `!important` only inside reduced-motion block | grepCss for `!important` |
| 4 | `prefers-reduced-motion` CSS exists | grepCss media query |
| 5 | `prefers-reduced-motion` JS detection exists | grepJs `prefers-reduced-motion` |
| 6 | `.reveal` reset inside reduced-motion | grepCss `.reveal` inside @media |
| 7 | Responsive breakpoint at 650px exists | grepCss `max-width: 650px` |
| 8 | Font variables defined (`--font-display`, `--font-body`) | grepCss `--font-` |
| 9 | No `#58a6ff` hardcoded (old accent) | grepCss `#58a6ff` |
| 10 | No `#ffffff` hardcoded | grepCss `#ffffff` |
| 11 | `#1a1f26` hardcoded in badges | grepCss `#1a1f26` |
| 12 | Brand colors preserved (Python, Java, JS) | grepCss `.b-python` etc. |
| 13 | Grid motif on `#inicio` | grepCss `background-image` on `#inicio` |
| 14 | No emojis in headings | grepCss/grepAstro for emoji patterns |
| 15 | `.btn-outline` uses dark theme colors | grepCss `.btn-outline` |
| 16 | Nav is sticky | grepCss `position: sticky` |
| 17 | No redundant color declarations | grepCss for duplicates |
| 18 | Lang switcher is fixed | grepCss `.lang-switcher` position |
| 19 | Back-to-top button exists | grepCss `#back-to-top` |
| 20 | AI Agents badge color (`#10a37f`) | grepCss `#10a37f` |
| 21-22 | Google Fonts loaded (Space Grotesk + Inter) | grepAstro font names in `<link>` |

## Why

Design consistency is hard to maintain manually. Automated checks catch regressions (e.g., someone adds `#58a6ff` instead of `var(--color-accent)`).

## Acceptance criteria

- [ ] All 22 checks run successfully.
- [ ] Each check prints `[PASS]`, `[FAIL]` or `[WARN]` with a suggested action.
- [ ] FAILs require a correction plan; WARNs require aesthetic review.

## Out of scope

- Visual regression tests — checking rendered appearance is not covered.
- Cross-browser design checks — only code-level analysis.
