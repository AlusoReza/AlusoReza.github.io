# 10 · Component tree — Tasks

- [x] Create all 10 section components following the props-only pattern
- [x] Implement `BaseLayout.astro` with data-data serialization and slot
- [x] Wire up `index.astro` to import JSONs and pass to BaseLayout
- [x] Implement conditional rendering for empty sections
- [ ] Verify no component imports JSON directly (check imports in all `.astro` files)

## Maintenance

- [ ] When adding a new section component, follow the same pattern: receive `data` as prop, render HTML
- [ ] When modifying the data shape, update all components that consume it
