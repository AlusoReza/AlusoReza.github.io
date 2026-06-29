# Mission

## What we build

A static bilingual (ES/EN) single-page portfolio for Alonso Suárez Reza — a software developer with a background in Computational Physics — built with Astro 5, vanilla CSS, and vanilla JS.

1. **Data-driven site** — All content is managed from `src/data/*.json` files; no component changes needed for content updates.
2. **Bilingual system** — Full ES/EN translation with client-side language switching, persisted in `localStorage`.
3. **Zero-dependency frontend** — No frameworks or build tools beyond Astro 5; vanilla everything.

## For whom

- Recruiters and hiring managers evaluating the developer's skills and background.
- Professional network (LinkedIn, GitHub) visiting the portfolio.
- The author himself, who maintains the site with minimal effort.

## Principles

- **Explicit beats clever** — Code is straightforward, no abstractions or frameworks beyond what's needed.
- **Static-first** — Everything that can be built at compile time should be; the client only hydrates when necessary.
- **Data-driven** — Content lives in JSON, not in components. Editing a JSON updates the entire site.
- **Minimum viable dependencies** — Astro 5 and its built-in tooling. No npm packages beyond that.

## What NOT

- **Not a CMS** — There is no admin panel or database. Content is edited in JSON files by hand.
- **Not a blog (yet)** — The site is a single page. A blog would require new pages and a new feature spec.
- **Not server-rendered** — The site is fully static (SSG). No SSR, no Node server at runtime.
