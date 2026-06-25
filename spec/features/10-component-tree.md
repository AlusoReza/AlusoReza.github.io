# 10 — Component tree

## Purpose

Inventory of the 10 Astro components in the portfolio, with their props, responsibilities and relationships.

## Component list

| Componente | Archivo | Props | Responsabilidad |
|------------|---------|-------|-----------------|
| BaseLayout | `layouts/BaseLayout.astro` | title, description | HTML shell, data-data, Google Fonts, bundles |
| Nav | `components/Nav.astro` | — | Sticky navigation with section links |
| LangSwitcher | `components/LangSwitcher.astro` | — | ES/EN buttons with `data-lang` |
| Profile | `components/Profile.astro` | data, lang | Photo, name, subtitle, badges |
| About | `components/About.astro` | data | "About me" paragraphs with `set:html` |
| Skills | `components/Skills.astro` | data | Skills grid + personality note |
| Education | `components/Education.astro` | data | Educational timeline with interactive hover |
| Projects | `components/Projects.astro` | data | Project cards with links |
| Experience | `components/Experience.astro` | data | Work experience (auto-hide if empty) |
| Certificates | `components/Certificates.astro` | data | Certificates (auto-hide if empty) |
| Contact | `components/Contact.astro` | data | Footer with social buttons + CV |

## Relationships

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
    ├── Experience
    ├── Certificates
    └── Contact
```

## Data loading

`index.astro` imports `BaseLayout` and passes it the 7 JSONs as `data`. `BaseLayout` serializes them into `data-data` and passes them to components as props.

## Rules
- Components **do not import data directly** — they receive it as props.
- Components **have no business logic** — they only render.
- `set:html` only on HTML elements (not in `<script>`).

## Relevant code
- `src/pages/index.astro` — entry point
- `src/components/*.astro` — the 10 components
