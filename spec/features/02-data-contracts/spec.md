# 02 · Data contracts

**Status:** implemented ✅

## What it does

Defines the schemas of the 7 JSON files in `src/data/`. All portfolio content is managed exclusively from these files — no component changes needed for data updates.

### Bilingual field format
```json
{ "es": "Hola", "en": "Hello" }
```
Non-translatable fields use plain strings.

### Client-side resolution
```javascript
function t(field) {
  if (!field) return '';
  if (typeof field === 'string') return field;
  return field[currentLang] || field.es || field.en || '';
}
```

### Schemas

**lang.json** — `es.{key}` / `en.{key}` string pairs. Keys: `hero-sub`, `sec-sobre`, `hab-ai`, `sec-hab`, `sec-proy`, `sec-est`, `sec-exp`, `sec-cert`, `sec-cont`, `cont-sub`, `cv-text-h`, `cv-text-f`, `ver-btn`, `cert-dl`.

**profile.json** — `name` (string), `photo` (string, path), `role` ({es, en}).

**skills.json** — Array of `{ title: {es, en}, description: {es, en} }`.

**education.json** — Array of `{ title: {es, en}, date (optional): string, institution: {es, en}, description (optional): {es, en}, list (optional): [{es, en}] }`.

**projects.json** — Array of `{ title: string, description: {es, en}, links (optional): [{url, text}] }`.

**experience.json** — Array of `{ title: {es, en}, date (optional): string, company: {es, en}, description (optional): {es, en} }`.

**certificates.json** — Array of `{ title: {es, en}, institution: {es, en}, date: string (YYYY-MM-DD), description (optional): {es, en} }`. **No `url` field allowed.**

## Why

Decouples content from presentation. Non-developers can edit JSON files to update portfolio without touching Astro components or understanding the build pipeline.

## Acceptance criteria

- [ ] Each JSON file matches its schema (required fields, types, bilingual format).
- [ ] `certificates.json` has no `url` field.
- [ ] Empty arrays in `experience` or `certificates` automatically hide the section.
- [ ] `t()` helper correctly resolves bilingual fields for both ES and EN.

## Out of scope

- Dynamic schemas — all JSONs follow a fixed, documented structure.
- Validation at runtime — schemas are validated by tests, not by the runtime code.
