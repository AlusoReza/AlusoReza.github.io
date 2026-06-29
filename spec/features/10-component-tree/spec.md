# 10 · Component tree

**Status:** implemented ✅

## What it does

Inventory of the 10 Astro components in the portfolio, with their props, responsibilities and relationships.

### Component list
| Component | File | Props | Responsibility |
|-----------|------|-------|----------------|
| BaseLayout | `layouts/BaseLayout.astro` | title, description | HTML shell, data-data, Google Fonts, client.js |
| Nav | `components/Nav.astro` | — | Sticky navigation with section links |
| LangSwitcher | `components/LangSwitcher.astro` | — | ES/EN buttons with `data-lang` |
| Profile | `components/Profile.astro` | data, lang | Photo, name, subtitle, badges |
| About | `components/About.astro` | data | "About me" paragraphs with `set:html` |
| Skills | `components/Skills.astro` | data | Skills grid + personality note |
| Education | `components/Education.astro` | data | Educational timeline with interactive hover |
| Projects | `components/Projects.astro` | data | Project cards with links |
| Experience | `components/Experience.astro` | data | Work experience (auto-hide if empty) |
| Certificates | `components/Certificates.astro` | data | Certificates (auto-hide if empty) |
| Contact | `components/Contact.astro` | data | Footer with social buttons + CV download |

### Relationships
```
BaseLayout
├── LangSwitcher
├── Nav
└── <slot> (index.astro)
    ├── Profile
    ├── About
    ├── Skills
    ├── Education
    ├── Projects
    ├── Experience (auto-hide)
    ├── Certificates (auto-hide)
    └── Contact
```

## Why

A clear component tree ensures that the architecture is understandable at a glance. Components have strict boundaries: they receive data as props, render HTML, and contain no business logic.

## Acceptance criteria

- [ ] All 10 components exist in `src/components/` (plus `BaseLayout` in `layouts/`).
- [ ] Components import data from `BaseLayout` — they do not import JSONs directly.
- [ ] No business logic in components — data manipulation happens in `client.js` only.
- [ ] `set:html` is used only on HTML elements, never in `<script>` tags.

## Out of scope

- Shared component library — all components are project-specific.
- Testing components in isolation — tested via build output and integration tests.
