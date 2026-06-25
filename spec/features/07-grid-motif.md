# 07 — Computational grid

## Purpose

Visual signature of the portfolio: a subtle grid that evokes graph paper, coordinates, computational physics and data analysis.

## Technique

The grid is implemented as a `background-image` with two linear gradients on the `#inicio` section:

```css
#inicio {
    background-image:
        linear-gradient(rgba(255,255,255,0.02) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.02) 1px, transparent 1px);
    background-size: 28px 28px;
}
```

- **Spacing:** 28px (intentionally not round, avoids looking like a generic design grid).
- **Opacity:** 2% white — barely perceptible, does not compete with content.
- **Responsive:** On mobile, `background-size: 20px`.

## Fade gradient

```css
#inicio::after {
    background: linear-gradient(180deg, transparent 60%, var(--color-bg) 100%);
}
```

This prevents the grid from cutting off abruptly at the end of the hero.

## Rules
- The grid only appears in `#inicio`. Do not replicate in other sections.
- Do not increase opacity — the design must be subtle.

## Relevant code
- `src/styles/global.css:154-178` — full implementation
