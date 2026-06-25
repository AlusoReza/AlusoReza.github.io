# 02 — Data contracts

## Purpose

Defines the schemas of the 7 JSON files in `src/data/`. All portfolio data is managed exclusively from these files.

## General format

### Bilingual fields
Translatable fields use the format:
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

## Schemas

### lang.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| es.{key} | string | yes | Spanish text |
| en.{key} | string | yes | English text |

Keys (`key`): `hero-sub`, `sec-sobre`, `hab-ai`, `sec-hab`, `sec-proy`, `sec-est`, `sec-exp`, `sec-cert`, `sec-cont`, `cont-sub`, `cv-text-h`, `cv-text-f`, `ver-btn`, `cert-dl`.

### profile.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| name | string | yes | Full name |
| photo | string | yes | Profile photo path |
| role | {es, en} | yes | Professional title |

### skills.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | {es, en} | yes | Skill name |
| description | {es, en} | yes | Brief description |

### education.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | {es, en} | yes | Degree obtained |
| date | string | no | Date or period |
| institution | {es, en} | yes | Educational institution |
| description | {es, en} | no | Description |
| list | [{es, en}] | no | List of achievements |

### projects.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | string | yes | Project name |
| description | {es, en} | yes | Description |
| links | [{url, text}] | no | Links (github, demo) |

### experience.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | {es, en} | yes | Position |
| date | string | no | Date or period |
| company | {es, en} | yes | Company |
| description | {es, en} | no | Description |

### certificates.json
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| title | {es, en} | yes | Certificate name |
| institution | {es, en} | yes | Issuing institution |
| date | string | yes | Date ("YYYY-MM-DD") |
| description | {es, en} | no | Brief description |

## Rules
- `certificates.json` **MUST NOT include a `url` field**.
- Empty arrays in `experience` or `certificates` automatically hide the section.
- Each JSON is statically imported in `BaseLayout.astro` (no fetch used).

## Relevant code
- `src/data/*.json` — the 7 files
- `src/layouts/BaseLayout.astro:4-10` — static imports
- `src/scripts/client.js:4-8` — `t()` helper
