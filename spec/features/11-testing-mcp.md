# 11 — Tests MCP (suite completa)

## Propósito

Define el sistema modular de tests que verifica el cumplimiento del portfolio con las mejores prácticas de Astro 5, diseño, lógica JavaScript, CSS, esquemas JSON y rutas de archivos.

## Arquitectura

Los tests están modularizados en scripts independientes por capa, ejecutados por un master runner:

```
.agents/tests/
├── run-all.ps1               ← Master: ejecuta todos y resume, guarda en bugs.md
├── check-astro-mcp.ps1       ← 16 checks Astro MCP
├── check-frontend-design.ps1 ← 22 checks diseño
├── check-js-logic.ps1        ← JS logic flaws (null guards, noopener, etc.)
├── check-css-logic.ps1       ← CSS logic flaws (#1a1f26, clases sin definir)
├── check-json-schema.ps1     ← JSON schema validation (contratos bilingües)
└── check-paths.ps1           ← File path integrity (CV.pdf, assets)
```

### Master runner (`run-all.ps1`)
- Ejecuta los 6 scripts secuencialmente
- Recopila todos los FAILs y WARNs
- Imprime sección `[MANUAL]` con items de lógica profunda
- **Guarda automáticamente los hallazgos en `spec/constitution/bugs.md`**

## Checks por módulo

### check-astro-mcp.ps1 (16 checks)
| # | Check | Método |
|---|-------|--------|
| 1 | No onclick | grepHtml `onclick=` |
| 2 | No is:inline | grepHtml `is:inline` |
| 3 | No window.DATA | grepJs `window\.DATA` |
| 4 | data-data | grepAstro `data-data=` |
| 5-16 | (ver script completo) | — |

### check-frontend-design.ps1 (22 checks)
Variables CSS, circular refs, !important, prefers-reduced-motion, responsive, tipografía, paleta de colores, cuadrícula, componentes.

### check-js-logic.ps1 (~7 checks)
Null guards, early returns, `noopener` ausente, clases CSS referenciadas sin definir, `window.*` globales, flujo `init()`.

### check-css-logic.ps1 (~5 checks)
Colores hardcodeados (`#1a1f26`, `#ffffff` residual), clases sin definir, `!important` fuera de reduced-motion, variables no usadas.

### check-json-schema.ps1 (~13 checks)
Contratos de todos los JSONs: campos requeridos, formato bilingüe, prohibición de `url` en certificates, fechas.

### check-paths.ps1 (~7 checks)
Existencia de archivos referenciados (CV.pdf, perfil.jpg, favicon), consistencia de rutas, integridad de `docs/certificates/`.

## Output
Cada check imprime `[PASS]`, `[FAIL]` o `[WARN]` con el archivo, línea y sugerencia de acción.

## Reglas
- Los FAILs reciben plan de corrección automático en el resumen.
- Los WARNs se discuten con el usuario antes de actuar.
- Todos los hallazgos se guardan en `spec/constitution/bugs.md` antes de cualquier corrección.

## Dependencias
- [Feature 14](14-bug-tracking.md) — Bug tracking (guarda hallazgos en bugs.md)

## Código relevante
- `.agents/tests/run-all.ps1` — master runner
- `.agents/tests/check-*-.ps1` — scripts individuales
- `spec/constitution/bugs.md` — registro de bugs
