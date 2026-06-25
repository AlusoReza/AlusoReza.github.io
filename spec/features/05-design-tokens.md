# 05 — Design tokens

## Purpose

Defines the CSS variables in `:root` that govern the portfolio's appearance. GitHub dark theme with electric accent.

## Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `--color-bg` | `#0d1117` | Main background (GitHub dark) |
| `--color-bg-card` | `#161b22` | Card and section background |
| `--color-bg-hover` | `#1c2128` | Card hover background |
| `--color-border` | `#30363d` | Borders and separators |
| `--color-text` | `#c9d1d9` | Main text |
| `--color-text-bright` | `#f0f6fc` | Bright text (headings, hover) |
| `--color-text-muted` | `#8b949e` | Secondary text, metadata |
| `--color-accent` | `#7fc1fe` | Electric blue (links, hover, name) |
| `--color-green` | `#3fb950` | Accent green (badges, skill hover) |
| `--font-display` | `'Space Grotesk', sans-serif` | Display (h1, h2, badges, labels) |
| `--font-body` | `'Inter', ...` | Body text |

## Rules
- **DO NOT use hardcoded color values** outside `:root`. Use `var(--color-*)`.
- **DO NOT create self-referential variables** (`--color-bg: var(--color-bg)`).
- Brand colors in badges (Python blue, Java orange, etc.) are intentional and not normalized.

## Relevant code
- `src/styles/global.css:2-14` — all variable definitions
