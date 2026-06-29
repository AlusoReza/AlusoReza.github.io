# 07 · Computational grid

**Status:** implemented ✅

## What it does

A subtle graph-paper grid background on the hero (`#inicio`) section that evokes computational physics, data analysis, and coordinate systems — the developer's academic background.

### Technique
```css
#inicio {
    background-image:
        linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 28px 28px;
}
```
- **Spacing:** 28px — intentionally non-round to avoid looking like a generic design grid.
- **Opacity:** 2% white — barely perceptible, does not compete with content.
- **Responsive:** On mobile (<=650px), `background-size: 20px 20px`.
- **Fade gradient:** `#inicio::after` fades the grid from 60% to 100% so it doesn't cut off abruptly at the hero's edge.

## Why

A visual signature that differentiates the portfolio. The grid is a subtle nod to the developer's physics background — graph paper, coordinates, numerical methods — without being overt or distracting.

## Acceptance criteria

- [ ] Grid appears ONLY on `#inicio` section, not on other sections.
- [ ] Grid is barely visible (2% white) — does not draw attention from content.
- [ ] On mobile, grid spacing reduces to 20px.
- [ ] The fade gradient prevents an abrupt grid cutoff at the section bottom.
- [ ] Grid does not break on hover or interact with other elements (it's a pure background image).

## Out of scope

- Animated grid — the grid is static.
- Interactive grid — no mouse tracking or coordinate display.
- Grid on multiple sections — exclusive to hero.
