# 05 · Design tokens — Plan

## Approach

All visual properties are controlled via CSS custom properties in `:root`. Components use `var(--color-*)` and `var(--font-*)` exclusively. Brand colors in tool badges are the only hardcoded exception.

## Implementation

1. Define 11 variables in `:root` (9 color + 2 font). All values are real hex codes.
2. Use `var(--color-*)` throughout `global.css` for all color assignments.
3. Badge system: language badges use `border-left` accent + hover; tool badges use solid background + glow hover.
4. Keep brand-specific colors as hardcoded values in badge selectors (`.b-python`, `.b-java`, etc.) — these are not part of the design system.

## Decisions

- **GitHub dark palette** — Professional, familiar, low-contrast. `#0d1117` background is easy on the eyes for long viewing.
- **`#7fc1fe` accent over `#58a6ff`** — After Session 3 review, the accent was brightened for better contrast against `#0d1117`.
- **No self-referential variables** — Session 3 critical bug: `--color-bg: var(--color-bg)` was a circular reference that resolved to nothing.
- **Badge brand colors are intentional** — Python blue, Java orange, etc. are identity colors that should not be normalized into the theme.

## Risks

- **`#1a1f26` hardcoded in `.badge`** — Currently `background-color: #1a1f26` instead of `var(--color-bg-card)`. Low severity but flagged for migration.
- **New colors added outside `:root`** — No mechanism prevents hardcoded colors. Mitigated by `check-css-logic.ps1` and `check-frontend-design.ps1`.
