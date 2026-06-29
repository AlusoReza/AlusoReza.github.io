# 10 · Component tree — Plan

## Approach

All components follow the same pattern: receive `data` as prop → render HTML. No component imports JSON directly. Data flows from `index.astro` → `BaseLayout` → slot components.

## Implementation

1. **index.astro** imports all 7 JSONs and passes them to `BaseLayout` as `data` attribute.
2. **BaseLayout.astro** receives `data`, serializes it into `data-data`, and passes it to slot components as props.
3. Each section component (`Profile`, `About`, `Skills`, etc.) receives `data` and renders statically in Spanish.
4. Empty sections (`Experience`, `Certificates`) use Astro conditional rendering: `{data.experience.length > 0 && <section>...</section>}`.

## Decisions

- **Props over direct imports** — Components are reusable and testable. If the data source changes, only the parent (`BaseLayout` / `index.astro`) needs updating.
- **Static render in Spanish + client-side hydration** — All content is rendered in Spanish at build time. If the user has EN saved, `client.js` re-renders dynamically. This gives search engines Spanish content by default.
- **`set:html` for rich text** — About section uses `set:html` to render paragraphs with HTML formatting from JSON. Used only on HTML elements, never in `<script>`.

## Risks

- **Component-data coupling** — If the data shape changes, all components that receive `data` must be checked. Mitigated by JSON schema tests.
- **Empty section handling** — Astro's conditional rendering and `client.js`'s `toggleSection()` must agree. Currently both check `array.length`.
