# Changelog — Alonso Suárez Reza Portfolio

## 2026-06-25 — Sesiones 1-6

### Sesión 1 — Refactorización MCP
- Reemplazo de script inline `is:inline set:html` por atributo `data-data` en `<body>`
- Migración de `onclick` a `data-lang` + `addEventListener`
- Eliminación de `window.DATA` y `window.changeLanguage`
- Añadido `tsconfig.json` (extends `astro/tsconfigs/base`)
- Creado `.agents/skills/frontend-design/SKILL.md`

### Sesión 2 — Refactorización de diseño
- Tipografía: Space Grotesk (display) + Inter (body)
- Paleta: acento `#7fc1fe`, 11 variables `:root` con valores reales
- Cuadrícula computacional como fondo del hero
- Subtítulo reformulado como tesis profesional
- Eliminación de emojis de headings

### Sesión 3 — Corrección de color y subtítulo
- Bugfix crítico: variables `:root` auto-referenciales → valores reales
- `.btn-outline` migrado de tema claro a dark theme
- Hero simplificado: "Desarrollador de software / Software developer"
- Tags: "Backend · Datos · Sistemas" → "Full Stack · IA · Agentes"

### Sesión 4 — Sistema de logging automático
- Creado `docs/logs/` con formato `YYYY-MM-DD.md`
- Creado `docs/bitacora.md` como resumen global
- AGENTS.md actualizado con workflow build-driven

### Sesión 5 — Anclaje de contexto y actualización de logs
- Resumen estructurado de todo el trabajo realizado
- Corrección del protocolo de logging

### Sesión 6 — Tests MCP y Frontend Design
- Creado `.agents/tests/check-mcp.ps1` (16 checks)
- Creado `.agents/tests/check-frontend-design.ps1` (22 checks)
- Añadido `skills-lock.json` faltante
- AGENTS.md: añadida sección `## Tests`
- Corregidos 7 `color: #ffffff` → `var(--color-text-bright)`

### Sesión 7 — Reestructuración SDD
- Creado `spec/` con `constitution/`, `features/`, `template/`
- Movido `certificates/` raíz → `docs/certificates/`
- Movido `spec_template/AGENTS_TEMPLATE.md` → `spec/template/`
- Creados 21 archivos de especificación SDD
- AGENTS.md: actualizado project structure y paths de certificados
- `.gitignore`: actualizado `certificates/` → `docs/certificates/`
