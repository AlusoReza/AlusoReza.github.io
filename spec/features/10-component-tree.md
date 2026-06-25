# 10 — Árbol de componentes

## Propósito

Inventario de los 10 componentes Astro del portfolio, con sus props, responsabilidades y relaciones.

## Lista de componentes

| Componente | Archivo | Props | Responsabilidad |
|------------|---------|-------|-----------------|
| BaseLayout | `layouts/BaseLayout.astro` | title, description | Shell HTML, data-data, Google Fonts, bundles |
| Nav | `components/Nav.astro` | — | Navegación sticky con links a secciones |
| LangSwitcher | `components/LangSwitcher.astro` | — | Botones ES/EN con `data-lang` |
| Profile | `components/Profile.astro` | data, lang | Foto, nombre, subtítulo, badges |
| About | `components/About.astro` | data | Párrafos "Sobre mí" con `set:html` |
| Skills | `components/Skills.astro` | data | Grid de habilidades + nota de personalidad |
| Education | `components/Education.astro` | data | Timeline formativo con hover interactivo |
| Projects | `components/Projects.astro` | data | Tarjetas de proyecto con enlaces |
| Experience | `components/Experience.astro` | data | Experiencia laboral (auto-hide si vacío) |
| Certificates | `components/Certificates.astro` | data | Certificados (auto-hide si vacío) |
| Contact | `components/Contact.astro` | data | Footer con botones sociales + CV |

## Relaciones

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

## Carga de datos

`index.astro` importa `BaseLayout` y le pasa los 7 JSONs como `data`. `BaseLayout` los serializa en `data-data` y los pasa a los componentes como props.

## Reglas
- Los componentes **no importan datos directamente** — los reciben como props.
- Los componentes **no tienen lógica de negocio** — solo renderizan.
- `set:html` solo en elementos HTML (no en `<script>`).

## Código relevante
- `src/pages/index.astro` — entry point
- `src/components/*.astro` — los 10 componentes
