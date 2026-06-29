# 06 · Typography

**Status:** implemented ✅

## What it does

Defines the typographic system: Space Grotesk for display/title elements and Inter for body text. Fonts are loaded from Google Fonts in `BaseLayout.astro` with `display=swap`.

### Fonts
- **Space Grotesk (display):** Titles, profile name, badges, skill/education labels. Weights 400, 500, 600, 700. Geometric character evoking math and code.
- **Inter (body):** Paragraph text, descriptions, navigation. Weights 400, 500, 600, 700. Optimized for screen readability.

### Hierarchy
| Element | Font | Size | Weight |
|---------|------|------|--------|
| h1 (name) | `--font-display` | 2.5em | 600 |
| h2 (sections) | `--font-display` | — | 600 |
| `.subtitle` | `--font-body` | 1.1em | — |
| body | `--font-body` | — | 400 |
| `.badge` | `--font-display` | 0.8em | 600 |
| `.skill-item strong` | `--font-display` | — | 600 |
| `.edu-header strong` | `--font-display` | 1.15em | 600 |
| nav a | `--font-body` | 0.85em | 500 |

## Why

Font pairing communicates personality: Space Grotesk gives a technical, computational feel (matching the developer's physics background), while Inter provides exceptional screen readability for longer text.

## Acceptance criteria

- [ ] Both fonts load from Google Fonts with `display=swap`.
- [ ] `--font-display` is applied to h1, h2, badges, skill labels, edu headers.
- [ ] `--font-body` is applied to body text, nav, descriptions.
- [ ] No FOIT (Flash of Invisible Text) on slow connections — `display=swap` ensures fallback font shows immediately.

## Out of scope

- Custom font files — all fonts are loaded via Google Fonts CDN.
- Variable fonts — only static weights are used.
