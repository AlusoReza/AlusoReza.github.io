# 02 — Contratos de datos

## Propósito

Define los esquemas de los 7 archivos JSON en `src/data/`. Todos los datos del portfolio se gestionan exclusivamente desde estos archivos.

## Formato general

### Campos bilingües
Los campos traducibles usan el formato:
```json
{ "es": "Hola", "en": "Hello" }
```
Los campos no traducibles usan strings planos.

### Resolución en cliente
```javascript
function t(field) {
  if (!field) return '';
  if (typeof field === 'string') return field;
  return field[currentLang] || field.es || field.en || '';
}
```

## Esquemas

### lang.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| es.{key} | string | sí | Texto en español |
| en.{key} | string | sí | Texto en inglés |

Claves (`key`): `hero-sub`, `sec-sobre`, `hab-ai`, `sec-hab`, `sec-proy`, `sec-est`, `sec-exp`, `sec-cert`, `sec-cont`, `cont-sub`, `cv-text-h`, `cv-text-f`, `ver-btn`, `cert-dl`.

### profile.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| name | string | sí | Nombre completo |
| photo | string | sí | Ruta de la foto de perfil |
| role | {es, en} | sí | Título profesional |

### skills.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| title | {es, en} | sí | Nombre de la skill |
| description | {es, en} | sí | Descripción breve |

### education.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| title | {es, en} | sí | Título obtenido |
| date | string | no | Fecha o período |
| institution | {es, en} | sí | Institución educativa |
| description | {es, en} | no | Descripción |
| list | [{es, en}] | no | Lista de logros |

### projects.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| title | string | sí | Nombre del proyecto |
| description | {es, en} | sí | Descripción |
| links | [{url, text}] | no | Enlaces (github, demo) |

### experience.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| title | {es, en} | sí | Puesto |
| date | string | no | Fecha o período |
| company | {es, en} | sí | Empresa |
| description | {es, en} | no | Descripción |

### certificates.json
| Campo | Tipo | Required | Descripción |
|-------|------|----------|-------------|
| title | {es, en} | sí | Nombre del certificado |
| institution | {es, en} | sí | Institución emisora |
| date | string | sí | Fecha ("YYYY-MM-DD") |
| description | {es, en} | no | Descripción breve |

## Reglas
- `certificates.json` **NO debe incluir campo `url`**.
- Los arrays vacíos en `experience` o `certificates` ocultan automáticamente la sección.
- Cada JSON se importa estáticamente en `BaseLayout.astro` (no se usa fetch).

## Código relevante
- `src/data/*.json` — los 7 archivos
- `src/layouts/BaseLayout.astro:4-10` — imports estáticos
- `src/scripts/client.js:4-8` — helper `t()`
