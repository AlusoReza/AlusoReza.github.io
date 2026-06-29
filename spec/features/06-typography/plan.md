# 06 · Typography — Plan

## Approach

Two-font system: a geometric display font for headings and labels, a neutral sans-serif for body text. Both loaded from Google Fonts with `display=swap` to avoid FOIT.

## Implementation

1. **BaseLayout.astro** adds `<link>` tags for Google Fonts with `display=swap`, preconnect, and crossorigin attributes.
2. **global.css `:root`** defines `--font-display: 'Space Grotesk', sans-serif` and `--font-body: 'Inter', -apple-system, ...`.
3. **Component selectors** apply the font variables: `h1` and `h2` use `--font-display`, `body` uses `--font-body`, specific elements override as needed.

## Decisions

- **Space Grotesk + Inter over system fonts** — The pairing is intentional: Grotesk's geometric shapes evoke code and mathematics (aligned with computational physics background), Inter is optimized for screen reading at small sizes.
- **`display=swap` over `display=block`** — Ensures text is immediately visible with fallback font while Google Fonts loads. Trade-off: a brief layout shift (FOUT) instead of invisible text (FOIT).
- **Static weights (400, 500, 600, 700)** — Variable fonts would reduce file size but add complexity. The 4 static weights cover all needs.

## Risks

- **Google Fonts availability** — If CDN is unreachable, fallback `sans-serif` is used. Not a functional issue but the visual identity is weakened.
- **Font loading timing** — On fast connections, fonts load before first paint. On slow connections, `display=swap` shows fallback text, then swaps. Acceptable trade-off.
