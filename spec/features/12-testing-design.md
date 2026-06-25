# 12 — Tests de diseño

## Propósito

Define los checks del script `.agents/tests/check-frontend-design.ps1` que verifican el cumplimiento del skill de frontend-design.

## Checks (22 total)

| # | Check | Descripción | Método |
|---|-------|-------------|--------|
| 1 | Design tokens defined | `:root` tiene variables de diseño | grepCss `--color-` |
| 2 | No circular refs | Ningún var() se refiere a sí mismo | grepCss `var(--color-bg): var(--color-bg)` |
| 3 | !important only in reduced-motion | Solo hay `!important` dentro de `prefers-reduced-motion` | grepCss avanzado |
| 4 | prefers-reduced-motion CSS | Existe el media query en CSS | grepCss `prefers-reduced-motion` |
| 5 | prefers-reduced-motion JS | Existe detección en JS | grepJs `prefers-reduced-motion` |
| 6 | .reveal reset | Existe reset de `.reveal` dentro del media query | grepCss `.reveal` |
| 7 | Responsive breakpoints | Existe `@media (max-width: 650px)` | grepCss `max-width` |
| 8 | Typography vars | `--font-display` y `--font-body` definidos | grepCss `--font-` |
| 9 | `#58a6ff` hardcoded | Busca el color antiguo en CSS (debe ser `#7fc1fe`) | grepCss `#58a6ff` |
| 10 | `#ffffff` hardcoded | Busca blanco hardcodeado en CSS (debe ser var) | grepCss `#ffffff` |
| 11 | `#1a1f26` hardcoded | Busca el color en badges (posible migración) | grepCss `#1a1f26` |
| 12 | Brand colors preserved | Python, Java, JS badges tienen sus colores | grepCss `b-python` |
| 13 | Grid motif | `#inicio` tiene background-image con gradientes | grepCss `background-image` |
| 14 | No emojis in headings | Los headings no tienen emojis hardcodeados | grepCss `🇪🇸` / grepAstro `📍` |
| 15 | btn-outline dark theme | `.btn-outline` usa colores del tema oscuro | grepCss `.btn-outline` |
| 16 | nav sticky | `nav` usa `position: sticky` | grepCss `sticky` |
| 17 | Redundant color removed | No hay `color:` duplicado en selectores específicos | grepCss específico |
| 18 | lang-switcher fixed | Lang switcher tiene `position: fixed` | grepCss `lang-switcher` |
| 19 | back-to-top | Existe el botón back-to-top | grepCss `back-to-top` |
| 20 | Specific named color | Verifica colores específicos de marca | grepCss `#10a37f` |
| 21-22 | Google Fonts loaded | Space Grotesk e Inter están en el layout | grepAstro `Space+Grotesk` / `Inter` |

## Output
Cada check imprime `[PASS]`, `[FAIL]` o `[WARN]` con acción sugerida.

## Reglas
- FAILs requieren plan de corrección.
- WARNs requieren decisión estética del usuario.
- No aplicar correcciones automáticas sin aprobación.

## Código relevante
- `.agents/tests/check-frontend-design.ps1` — script completo
