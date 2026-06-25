# 12 — Design tests

## Purpose

Defines the checks in the `.agents/tests/check-frontend-design.ps1` script that verify compliance with the frontend-design skill.

## Checks (22 total)

| # | Check | Description | Method |
|---|-------|-------------|--------|
| 1 | Design tokens defined | `:root` has design variables | grepCss `--color-` |
| 2 | No circular refs | No var() refers to itself | grepCss `var(--color-bg): var(--color-bg)` |
| 3 | !important only in reduced-motion | There is only `!important` inside `prefers-reduced-motion` | advanced grepCss |
| 4 | prefers-reduced-motion CSS | Media query exists in CSS | grepCss `prefers-reduced-motion` |
| 5 | prefers-reduced-motion JS | Detection exists in JS | grepJs `prefers-reduced-motion` |
| 6 | .reveal reset | `.reveal` reset exists inside the media query | grepCss `.reveal` |
| 7 | Responsive breakpoints | `@media (max-width: 650px)` exists | grepCss `max-width` |
| 8 | Typography vars | `--font-display` and `--font-body` defined | grepCss `--font-` |
| 9 | `#58a6ff` hardcoded | Looks for the old color in CSS (should be `#7fc1fe`) | grepCss `#58a6ff` |
| 10 | `#ffffff` hardcoded | Looks for hardcoded white in CSS (should be var) | grepCss `#ffffff` |
| 11 | `#1a1f26` hardcoded | Looks for the color in badges (possible migration) | grepCss `#1a1f26` |
| 12 | Brand colors preserved | Python, Java, JS badges have their colors | grepCss `b-python` |
| 13 | Grid motif | `#inicio` has background-image with gradients | grepCss `background-image` |
| 14 | No emojis in headings | Headings don't have hardcoded emojis | grepCss `🇪🇸` / grepAstro `📍` |
| 15 | btn-outline dark theme | `.btn-outline` uses dark theme colors | grepCss `.btn-outline` |
| 16 | nav sticky | `nav` uses `position: sticky` | grepCss `sticky` |
| 17 | Redundant color removed | No duplicate `color:` in specific selectors | specific grepCss |
| 18 | lang-switcher fixed | Lang switcher has `position: fixed` | grepCss `lang-switcher` |
| 19 | back-to-top | Back-to-top button exists | grepCss `back-to-top` |
| 20 | Specific named color | Verifies specific brand colors | grepCss `#10a37f` |
| 21-22 | Google Fonts loaded | Space Grotesk and Inter are in the layout | grepAstro `Space+Grotesk` / `Inter` |

## Output
Each check prints `[PASS]`, `[FAIL]` or `[WARN]` with a suggested action.

## Rules
- FAILs require a correction plan.
- WARNs require aesthetic decision from the user.
- Do not apply automatic corrections without approval.

## Relevant code
- `.agents/tests/check-frontend-design.ps1` — full script
