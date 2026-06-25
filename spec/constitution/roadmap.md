# Roadmap — Alonso Suárez Reza Portfolio

## Estado actual (25/06/2026)
- Portfolio funcional con Astro 5, data-driven, bilingüe (ES/EN)
- Tests MCP y frontend-design implementados (22 checks)
- Sistema de logging build-driven operativo
- Especificaciones SDD completadas

## Próximos pasos

### Corto plazo
- Instalar mcp de todos los lenguajes de programación instalados en este pryecto para comprobar que se esté aplicando todo correctamente.
-Agregar cv.

- [ ] Revisar `#1a1f26` hardcodeado en `.badge` (línea 195 de `global.css`) — posible migración a `var(--color-bg-card)`
- [ ] Verificar que todos los paths de `public/certificates/` → `docs/certificates/` están actualizados en referencias

### Medio plazo
- [ ] Añadir más tests de integración (build output, HTML snapshot)
- [ ] Explorar modo claro (light theme) como toggle

### Largo plazo
- [ ] Migrar a i18n con `@astrojs/netlify` o similar si se necesita SSR
- [ ] Añadir blog o sección de artículos técnicos -> Modularidad en distintas páginas.
