# Roadmap — Alonso Suárez Reza Portfolio

## Current state (25/06/2026)
- Functional portfolio with Astro 5, data-driven, bilingual (ES/EN)
- MCP and frontend-design tests implemented (22 checks + 4 modular test scripts)
- Build-driven logging system operational
- SDD specifications completed

## Next steps

### Short term
- Install MCP for all programming languages used in this project to verify everything is applied correctly.
- Add CV file.

- [ ] Review `#1a1f26` hardcoded in `.badge` (line 195 of `global.css`) — possible migration to `var(--color-bg-card)`
- [ ] Verify all paths from `public/certificates/` → `docs/certificates/` are updated in references

### Medium term
- [ ] Add more integration tests (build output, HTML snapshot)
- [ ] Explore light theme as a toggle

### Long term
- [ ] Migrate i18n to `@astrojs/netlify` or similar if SSR is needed
- [ ] Add blog or technical articles section → Modular pages
