# 05 · Design tokens — Tasks

- [x] Define 11 CSS variables in `:root` (9 color + 2 font)
- [x] Migrate all CSS to use `var(--color-*)` instead of hardcoded values
- [x] Fix self-referential `:root` variables (Session 3 bug)
- [x] Define badge brand colors for language and tool badges
- [ ] Migrate `#1a1f26` in `.badge` to `var(--color-bg-card)`
- [ ] Run `check-css-logic.ps1` and `check-frontend-design.ps1` to verify token usage

## Maintenance

- [ ] Any new color must be added to `:root` and used via `var()`
- [ ] Brand colors for new badges can be hardcoded but should be documented
