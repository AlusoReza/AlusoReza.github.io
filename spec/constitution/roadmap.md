# Roadmap

## Done ✅

1. **01 · Architecture** — Two-phase architecture (Astro build + client JS hydration via `data-data`)
2. **02 · Data contracts** — Schemas for all 7 JSONs with bilingual format
3. **03 · Data flow** — JSON → `data-data` → client.js render pipeline
4. **04 · i18n system** — `data-i18n`, `t()`, `changeLanguage()`, localStorage persistence
5. **05 · Design tokens** — CSS variables in `:root` (GitHub dark theme)
6. **06 · Typography** — Space Grotesk (display) + Inter (body)
7. **07 · Computational grid** — Graph paper background on hero section
8. **08 · Responsive** — Breakpoints at 650px and 480px
9. **09 · Accessibility** — `prefers-reduced-motion` in CSS + JS
10. **10 · Component tree** — 10 Astro components with props and relationships
11. **11 · MCP tests** — Modular test suite (6 modules, master runner)
12. **12 · Design tests** — 22 checks for frontend-design compliance
13. **13 · Logging system** — Build-driven session logging protocol
14. **14 · Bug tracking** — bugs.md lifecycle and regression tracking

## Next 🔜

- Add more integration tests (build output, HTML snapshot)

## Backlog 💡

- Explore light theme toggle
- Migrate i18n to `@astrojs/netlify` or similar if SSR is ever needed
- Install MCP for all programming languages used in the project