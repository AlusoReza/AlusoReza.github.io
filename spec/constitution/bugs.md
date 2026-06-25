# Bugs conocidos — Alonso Suárez Reza Portfolio

Último escaneo: 2026-06-25 (Sesión ?)
Total: 4 FAIL(s), 20 WARN(s) — ver detalles por sección

## 🔴 Sin arreglar

### Mixed-language en carga inicial con EN guardado — HIGH
- **Archivo:** `src/scripts/client.js:136`
- **Origen:** check-js-logic.ps1 + [MANUAL]
- **Detectado:** Sesión 8
- **Descripción:** `init()` llama a `translateUI()` pero nunca a `renderAll()`. Visitante con inglés guardado en localStorage ve skills, projects, education, experience, certificates en español. Solo nav y headings se traducen.
- **Fix propuesto:** Llamar `changeLanguage(savedLang)` al final de `init()` o `renderAll()` si `savedLang !== 'es'`
- **Estado:** ⏳ Pendiente

### CV PDF no existe (404) — MEDIUM
- **Archivo:** `src/components/Contact.astro:9`, `src/components/Profile.astro:22`
- **Origen:** check-paths.ps1
- **Detectado:** Sesión 8
- **Descripción:** El href apunta a `assets/Alonso_Reza_CV.pdf` pero el archivo no existe en `public/assets/`. Todos los visitantes reciben 404.
- **Fix propuesto:** Colocar el PDF en `public/assets/Alonso_Reza_CV.pdf` o actualizar las rutas
- **Estado:** ⏳ Pendiente

### Icono 📄 destruido al cambiar idioma — MEDIUM
- **Archivo:** `src/components/Contact.astro:10`
- **Origen:** [MANUAL]
- **Detectado:** Sesión 8
- **Descripción:** El icono 📄 está dentro del `<span data-i18n="cv-text-f">`. `translateUI()` hace `el.innerHTML = langData[key]` y los strings de `lang.json` no incluyen el icono. En `Profile.astro` está correctamente separado.
- **Fix propuesto:** Separar icono del span data-i18n: `<span class="icon">📄</span><span data-i18n="cv-text-f">Descargar...</span>`
- **Estado:** ⏳ Pendiente

### btn-primary sin definir en CSS — LOW
- **Archivo:** `src/components/Projects.astro:18`, `src/scripts/client.js:61`
- **Origen:** check-js-logic.ps1, check-css-logic.ps1
- **Detectado:** Sesión 8
- **Descripción:** Clase `btn-primary` usada en botones de proyecto pero sin definición CSS.
- **Fix propuesto:** Definir `.btn-primary` en CSS o eliminar la clase
- **Estado:** ⏳ Pendiente

### target=_blank sin rel=noopener (×4) — LOW
- **Archivo:** `Contact.astro:13,17`, `Projects.astro:18`, `client.js:61`
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión 8
- **Descripción:** LinkedIn, GitHub, enlaces de proyectos (SSR + cliente) sin `rel="noopener noreferrer"`.
- **Fix propuesto:** Añadir `rel="noopener noreferrer"` a los 4 enlaces
- **Estado:** ⏳ Pendiente

### changeLanguage sin early return — LOW
- **Archivo:** `src/scripts/client.js:93`
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión 8
- **Descripción:** Clickar idioma ya activo ejecuta `renderAll()` completo innecesariamente.
- **Fix propuesto:** Añadir `if (lang === currentLang) return;`
- **Estado:** ⏳ Pendiente

### getElementById sin null guard (×2) — LOW
- **Archivo:** `src/scripts/client.js:97,142`
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión 8
- **Descripción:** `document.getElementById(...).classList.add('active')` lanza TypeError si lang es inesperado.
- **Fix propuesto:** `const btn = document.getElementById(...); if (btn) btn.classList.add('active')`
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado en .badge — LOW
- **Archivo:** `src/styles/global.css:195`
- **Origen:** check-css-logic.ps1, check-frontend-design.ps1
- **Detectado:** Sesión 8
- **Descripción:** `background-color: #1a1f26` hardcodeado. Debería usar `var(--color-bg-card)`.
- **Fix propuesto:** Reemplazar `#1a1f26` por `var(--color-bg-card)`
- **Estado:** ⏳ Pendiente

### Rutas de assets inconsistentes — LOW
- **Archivo:** `profile.json`, `Contact.astro:9`
- **Origen:** check-paths.ps1
- **Detectado:** Sesión 8
- **Descripción:** Rutas CV relativas (`assets/...`) vs absolutas (`/assets/...`) en favicon/perfil.
- **Fix propuesto:** Usar `/assets/Alonso_Reza_CV.pdf` consistente
- **Estado:** ⏳ Pendiente

### Clases HTML sin definición CSS — LOW
- **Archivo:** `src/styles/global.css`, varios componentes
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión 9
- **Descripción:** `badges`, `text`, `section`, `profile-text` usadas como clases en HTML sin selector CSS directo. Pueden ser intencionales (selectores compuestos) o residuales.
- **Fix propuesto:** Verificar y definir si son necesarias o eliminar referencias
- **Estado:** ⏳ Pendiente

## 🟡 Parcialmente arreglado
*(vacío)*

## ✅ Arreglado
*(vacío)*


### init() NO llama a renderAll() - visitante con EN guardado ve secciones mixtas ES/EN — ERROR
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** init() NO llama a renderAll() - visitante con EN guardado ve secciones mixtas ES/EN
- **Estado:** ⏳ Pendiente

### init() NO llama a renderAll() - visitante con EN guardado ve secciones mixtas ES/EN — ERROR
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** init() NO llama a renderAll() - visitante con EN guardado ve secciones mixtas ES/EN
- **Estado:** ⏳ Pendiente

### CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf — ERROR
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ?
- **Descripción:** CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf
- **Estado:** ⏳ Pendiente

### CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf — ERROR
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ?
- **Descripción:** CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado: — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ?
- **Descripción:** #1a1f26 hardcodeado:
- **Estado:** ⏳ Pendiente

### Colores de marca en badges: #3776ab (2 uso(s)), #e76f00 (2 uso(s)), #f7df1e (2 uso(s)), #00758f (3 uso(s)), #734f96 (2 uso(s)), #007acc (1 uso(s)), #2c2255 (1 uso(s)), #1a6ac9 (1 uso(s)), #710900 (1 uso(s)), #10a37f (1 uso(s)) - intencionales pero no normalizables — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ?
- **Descripción:** Colores de marca en badges: #3776ab (2 uso(s)), #e76f00 (2 uso(s)), #f7df1e (2 uso(s)), #00758f (3 uso(s)), #734f96 (2 uso(s)), #007acc (1 uso(s)), #2c2255 (1 uso(s)), #1a6ac9 (1 uso(s)), #710900 (1 uso(s)), #10a37f (1 uso(s)) - intencionales pero no normalizables
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado: — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ?
- **Descripción:** #1a1f26 hardcodeado:
- **Estado:** ⏳ Pendiente

### Colores de marca en badges: #3776ab (2 uso(s)), #e76f00 (2 uso(s)), #f7df1e (2 uso(s)), #00758f (3 uso(s)), #734f96 (2 uso(s)), #007acc (1 uso(s)), #2c2255 (1 uso(s)), #1a6ac9 (1 uso(s)), #710900 (1 uso(s)), #10a37f (1 uso(s)) - intencionales pero no normalizables — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ?
- **Descripción:** Colores de marca en badges: #3776ab (2 uso(s)), #e76f00 (2 uso(s)), #f7df1e (2 uso(s)), #00758f (3 uso(s)), #734f96 (2 uso(s)), #007acc (1 uso(s)), #2c2255 (1 uso(s)), #1a6ac9 (1 uso(s)), #710900 (1 uso(s)), #10a37f (1 uso(s)) - intencionales pero no normalizables
- **Estado:** ⏳ Pendiente

### changeLanguage no tiene early return — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** changeLanguage no tiene early return
- **Estado:** ⏳ Pendiente

### target=_blank sin rel=noopener: — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** target=_blank sin rel=noopener:
- **Estado:** ⏳ Pendiente

### btn-primary usado en client.js, 1 componente(s) Astro pero NO definido en CSS — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** btn-primary usado en client.js, 1 componente(s) Astro pero NO definido en CSS
- **Estado:** ⏳ Pendiente

### Predominan comillas simples (96 simples vs 46 dobles) — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** Predominan comillas simples (96 simples vs 46 dobles)
- **Estado:** ⏳ Pendiente

### changeLanguage no tiene early return — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** changeLanguage no tiene early return
- **Estado:** ⏳ Pendiente

### target=_blank sin rel=noopener: — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** target=_blank sin rel=noopener:
- **Estado:** ⏳ Pendiente

### btn-primary usado en client.js, 1 componente(s) Astro pero NO definido en CSS — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** btn-primary usado en client.js, 1 componente(s) Astro pero NO definido en CSS
- **Estado:** ⏳ Pendiente

### Predominan comillas simples (96 simples vs 46 dobles) — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** Predominan comillas simples (96 simples vs 46 dobles)
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado en 1 sitio(s): — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** #1a1f26 hardcodeado en 1 sitio(s):
- **Estado:** ⏳ Pendiente

### Clases referenciadas pero sin CSS: profile-text, section, text, badges, btn-primary (usado en HTML/JS pero sin CSS) — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** Clases referenciadas pero sin CSS: profile-text, section, text, badges, btn-primary (usado en HTML/JS pero sin CSS)
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado en 1 sitio(s): — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** #1a1f26 hardcodeado en 1 sitio(s):
- **Estado:** ⏳ Pendiente

### Clases referenciadas pero sin CSS: profile-text, section, text, badges, btn-primary (usado en HTML/JS pero sin CSS) — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ?
- **Descripción:** Clases referenciadas pero sin CSS: profile-text, section, text, badges, btn-primary (usado en HTML/JS pero sin CSS)
- **Estado:** ⏳ Pendiente

### experience.json vacío — ADVERTENCIA
- **Origen:** check-json-schema.ps1
- **Detectado:** Sesión ?
- **Descripción:** experience.json vacío
- **Estado:** ⏳ Pendiente

### experience.json vacío — ADVERTENCIA
- **Origen:** check-json-schema.ps1
- **Detectado:** Sesión ?
- **Descripción:** experience.json vacío
- **Estado:** ⏳ Pendiente

### Rutas relativas de CV (inconsistente con favicon absoluto): — ADVERTENCIA
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ?
- **Descripción:** Rutas relativas de CV (inconsistente con favicon absoluto):
- **Estado:** ⏳ Pendiente

### Rutas relativas de CV (inconsistente con favicon absoluto): — ADVERTENCIA
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ?
- **Descripción:** Rutas relativas de CV (inconsistente con favicon absoluto):
- **Estado:** ⏳ Pendiente

## 📡 Hallazgos automáticos (Sesión ? — 2026-06-25)

### init() NO llama a renderAll() - visitante con EN guardado ve secciones mixtas ES/EN — ERROR
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf — ERROR
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado: — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### Colores de marca en badges: #3776ab (2 uso(s)), #e76f00 (2 uso(s)), #f7df1e (2 uso(s)), #00758f (3 uso(s)), #734f96 (2 uso(s)), #007acc (1 uso(s)), #2c2255 (1 uso(s)), #1a6ac9 (1 uso(s)), #710900 (1 uso(s)), #10a37f (1 uso(s)) - intencionales pero no normalizables — ADVERTENCIA
- **Origen:** check-frontend-design.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### changeLanguage no tiene early return — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### target=_blank sin rel=noopener: — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### btn-primary usado en client.js, 1 componente(s) Astro pero NO definido en CSS — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### Predominan comillas simples (96 simples vs 46 dobles) — ADVERTENCIA
- **Origen:** check-js-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### #1a1f26 hardcodeado en 1 sitio(s): — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### Clases referenciadas pero sin CSS: profile-text, section, text, badges, btn-primary (usado en HTML/JS pero sin CSS) — ADVERTENCIA
- **Origen:** check-css-logic.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### experience.json vacío — ADVERTENCIA
- **Origen:** check-json-schema.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

### Rutas relativas de CV (inconsistente con favicon absoluto): — ADVERTENCIA
- **Origen:** check-paths.ps1
- **Detectado:** Sesión ? (automático)
- **Estado:** ⏳ Pendiente

---
*Los hallazgos automáticos se añaden aquí en cada ejecución de run-all.ps1. El agente debe moverlos a las secciones de arriba con la descripción detallada y severidad correcta.*
