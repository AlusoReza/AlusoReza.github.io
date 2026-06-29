# 05 · Design tokens

**Status:** implemented ✅

## What it does

Defines the CSS variables in `:root` that govern the portfolio's appearance. GitHub dark theme with electric blue accent. A set of 11 CSS variables covers background, text, accent, border, and font assignments.

## Why

Centralizing colors, fonts, and spacing in `:root` variables ensures visual consistency. Changing the entire theme means editing only the `:root` block — no hunting through 792 lines of CSS.

## Acceptance criteria

- [ ] All `:root` variables use real hex/rgb values (no self-referential `var()` like `--color-bg: var(--color-bg)`).
- [ ] No hardcoded colors outside `:root` — all color values use `var(--color-*)` except brand colors in badges.
- [ ] `#1a1f26` hardcoded in `.badge` (line 195) is the only known exception — flagged for migration.
- [ ] Brand colors in badges (Python `#3776ab`, Java `#e76f00`, JS `#f7df1e`, etc.) are intentional and not normalized.

## Out of scope

- Light theme — no light color tokens currently defined (planned for medium term).
- Dynamic theming — tokens are static CSS, not controlled by JavaScript.
