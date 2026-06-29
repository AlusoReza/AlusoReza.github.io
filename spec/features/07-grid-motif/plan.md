# 07 · Computational grid — Plan

## Approach

Pure CSS implementation using two layered linear gradients as `background-image` on `#inicio`. No images, no canvas, no JavaScript. A `::after` pseudo-element creates the fade-out gradient.

## Implementation

1. **global.css `#inicio`** — Two `linear-gradient` backgrounds: one horizontal (1px line), one vertical (1px line). Both at 2% opacity white.
2. **`background-size: 28px 28px`** — Creates a square grid. 28px is intentional: not 20, not 30 — avoids association with generic design grids.
3. **`#inicio::after`** — Absolute-positioned pseudo-element with `background: linear-gradient(180deg, transparent 60%, var(--color-bg) 100%)`.
4. **Responsive** — At <=650px, `background-size: 20px 20px`.
5. **`pointer-events: none`** on `::after` so it doesn't block interaction.

## Decisions

- **CSS gradients over `<canvas>` or SVG** — Zero runtime cost, no JavaScript, no image loading. Renders instantly.
- **28px spacing** — Odd spacing avoids generic look. 28px feels "scientific" (multiples of 7, common in academic paper layouts).
- **2% opacity** — Must be subtle. Higher opacity would compete with content. The grid is a texture, not a pattern.
- **`::after` fade over CSS mask** — Better browser support, simpler syntax.

## Risks

- **Z-index stacking** — The `::after` pseudo-element must not cover interactive elements. Mitigated with `pointer-events: none` and `inset: 0`.
- **Performance** — Two gradients on one element are GPU-accelerated by modern browsers. No measurable impact.
