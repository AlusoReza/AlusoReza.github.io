# 05 — Design tokens

## Propósito

Define las variables CSS en `:root` que gobiernan la apariencia del portfolio. Tema oscuro GitHub con acento eléctrico.

## Variables

| Variable | Valor | Propósito |
|----------|-------|-----------|
| `--color-bg` | `#0d1117` | Fondo principal (GitHub dark) |
| `--color-bg-card` | `#161b22` | Fondo de tarjetas y secciones |
| `--color-bg-hover` | `#1c2128` | Fondo hover de tarjetas |
| `--color-border` | `#30363d` | Bordes y separadores |
| `--color-text` | `#c9d1d9` | Texto principal |
| `--color-text-bright` | `#f0f6fc` | Texto brillante (headings, hover) |
| `--color-text-muted` | `#8b949e` | Texto secundario, metadatos |
| `--color-accent` | `#7fc1fe` | Azul eléctrico (links, hover, nombre) |
| `--color-green` | `#3fb950` | Verde acento (badges, hover skills) |
| `--font-display` | `'Space Grotesk', sans-serif` | Display (h1, h2, badges, labels) |
| `--font-body` | `'Inter', ...` | Cuerpo de texto |

## Reglas
- **NO usar valores hardcodeados** de color fuera de `:root`. Usar `var(--color-*)`.
- **NO crear variables auto-referenciales** (`--color-bg: var(--color-bg)`).
- Los colores de marca en badges (Python azul, Java naranja, etc.) son intencionales y no se normalizan.

## Código relevante
- `src/styles/global.css:2-14` — definición de todas las variables
