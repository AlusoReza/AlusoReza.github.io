/*
Global state: manages the core application state — parsed data, active language, current page, and transition lock.
    - DATA: Objeto JSON completo parseado del atributo data-data del <body>. Es la fuente única de toda la data del sitio (perfil, skills, proyectos, etc.). Se serializa en Astro y se lee en cliente sin fetch.
    - currentLang: Idioma activo ('es' o 'en'). Se persiste en localStorage bajo la clave 'preferredLang'. Controla qué traducciones se muestran en toda la UI.
    - currentPage: ID de la página activa actualmente ('sobre', 'hab', etc.). Se usa para renderizar la sección correcta, marcar el nav activo y controlar qué páginas están visibles.
    - isTransitioning: Flag booleano de bloqueo. Impide clics múltiples durante la animación de transición entre páginas. Se pone true al iniciar y false al terminar la transición (350ms).
*/
const DATA = JSON.parse(document.body.dataset.data)
let currentLang = localStorage.getItem('preferredLang') || 'es'
let currentPage = 'sobre'
let isTransitioning = false
const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches

/*
t(field): Helper de traducción. Resuelve un campo bilingüe {es, en} o un string plano al idioma actual. Es la función más usada del archivo — toda traducción de contenido dinámico pasa por aquí.
    - field: Puede ser un string (devuelto tal cual) o un objeto {es: "...", en: "..."}. Si es null/undefined, devuelve string vacío.
Otros: Si el idioma actual no existe en el objeto, hace fallback a 'es', luego a 'en', luego a ''.
*/
function t(field) {
  if (!field) return ''
  if (typeof field === 'string') return field
  return field[currentLang] || field.es || field.en || ''
}

/*
translateUI(): Traduce todos los elementos estáticos del DOM que tienen un atributo data-i18n. Busca las traducciones en DATA.lang[currentLang] y las inyecta como innerHTML. Se llama en init() y en renderAll() tras cambiar idioma.
    - data: Referencia a DATA.lang — el objeto que contiene todas las traducciones de la UI estática (nav, about, contact, etc.).
    - key: La clave i18n del elemento actual (ej: 'nav-sobre', 'contact-email'). Se extrae de el.dataset.i18n.
Otros: Manejo especial para 'sobre-text' — separa el texto por doble salto de línea (\n\n) y lo envuelve en párrafos <p> con clase 'about-paragraph reveal' para que cada párrafo tenga su propia animación de scroll reveal.
*/
function translateUI() {
  const data = DATA.lang
  if (!data) return
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n
    if (data[currentLang] && data[currentLang][key]) {
      if (key === 'sobre-text') {
        el.innerHTML = data[currentLang][key].split('\n\n').map(p => `<p class="about-paragraph reveal">${p}</p>`).join('')
      } else {
        el.innerHTML = data[currentLang][key]
      }
    }
  })
}

/*
renderAll(): Orquestador maestro de renderizado. Llama a translateUI() para traducir la UI estática, luego renderiza cada sección dinámica (skills, proyectos, educación, experiencia, certificados) con su función de renderizado correspondiente. También controla la visibilidad de secciones vacías y reinicia el scroll reveal. Se llama al init, al cambiar idioma y tras cualquier cambio de datos.
Otros: No tiene variables locales — delega todo a renderSection(), toggleSection() e initScrollReveal(). Es el punto de entrada único para re-renderizar toda la página.
*/
function renderAll() {
  translateUI()
  renderSection('skills', DATA.skills.personality, renderPersonalityItem)
  renderSection('projects', DATA.projects, renderProjectItem)
  renderSection('education', DATA.education, renderEducationItem)
  renderSection('experience', DATA.experience, renderExperienceItem)
  renderSection('certificates', DATA.certificates, renderCertificateItem)
  toggleSection('experiencia', DATA.experience)
  toggleSection('certificados', DATA.certificates)
  initScrollReveal()
}

/*
renderSection(name, items, renderFn): Renderizador genérico de secciones. Busca un contenedor por su atributo data-section, y lo rellena concatenando el HTML generado por renderFn para cada item. Es la función base que usan todas las secciones dinámicas.
    - container: Elemento DOM encontrado con querySelector(`[data-section="${name}"]`). Si no existe, la función aborta silenciosamente.
Otros: Usa (items || []) como fallback por si el array es null/undefined, evitando errores en secciones sin datos.
*/
function renderSection(name, items, renderFn) {
  const container = document.querySelector(`[data-section="${name}"]`)
  if (!container) return
  container.innerHTML = (items || []).map(renderFn).join('')
}

/*
renderPersonalityItem(s): Renderiza un único ítem de skill/personalidad como HTML. Devuelve un div con título en negrita y descripción. Cada ítem tiene las clases 'stagger-item' y 'reveal' para la animación de entrada escalonada.
    - s: Objeto del JSON con campos {title: {es, en}, description: {es, en}}. Se procesa con t() para resolver el idioma actual.
Otros: Es la función de renderizado más simple del archivo — solo devuelve un template literal sin lógica condicional.
*/
function renderPersonalityItem(s) {
  return `<div class="skill-personality-item stagger-item reveal">
    <strong>${t(s.title)}</strong>
    <p>${t(s.description)}</p>
  </div>`
}

/*
renderEducationItem(item): Renderiza una tarjeta de educación completa como HTML. Construye la tarjeta incrementalmente: header con título y fecha, institución, descripción y lista de logros. Diseñada para el JSON de educación que puede tener campos opcionales.
    - html: Acumulador de string. Se va construyendo paso a paso con += y se devuelve al final. Es el patrón usado en todas las funciones de renderizado de tarjetas.
Otros: La lista (item.list) solo se renderiza si existe y tiene elementos. Cada ítem de la lista también pasa por t() para soporte bilingüe.
*/
function renderEducationItem(item) {
  let html = `<div class="card-item stagger-item reveal">
    <div class="card-header">
      <strong class="card-title">${t(item.title)}</strong>`
  if (item.date) html += `<span class="card-date">${t(item.date)}</span>`
  html += '</div>'
  if (item.institution) html += `<p class="card-sub">${t(item.institution)}</p>`
  if (item.description) html += `<p class="card-desc">${t(item.description)}</p>`
  if (item.list && item.list.length) {
    html += '<ul class="card-list">'
    item.list.forEach(li => html += `<li>${t(li)}</li>`)
    html += '</ul>'
  }
  html += '</div>'
  return html
}

/*
renderProjectItem(proj): Renderiza una tarjeta de proyecto como HTML. Incluye título, descripción y enlaces externos. Los enlaces se abren en nueva pestaña con rel="noopener noreferrer" por seguridad.
    - html: Acumulador de string. Se construye el template del proyecto y se devuelve al final.
Otros: Los links son opcionales — solo se renderiza el div 'project-links' si proj.links existe y tiene elementos. Cada link tiene target="_blank" para no navegar fuera del portfolio.
*/
function renderProjectItem(proj) {
  let html = `<div class="project-card stagger-item reveal">
    <h3>${proj.title}</h3>
    <p>${t(proj.description)}</p>`
  if (proj.links && proj.links.length) {
    html += '<div class="project-links">'
    proj.links.forEach(link => html += `<a href="${link.url}" target="_blank" rel="noopener noreferrer" class="link-outline">${t(link.text)}</a>`)
    html += '</div>'
  }
  html += '</div>'
  return html
}

/*
renderExperienceItem(item): Renderiza una tarjeta de experiencia laboral como HTML. Estructura similar a renderEducationItem pero sin campo de lista. Usa 'company' en lugar de 'institution'.
    - html: Acumulador de string. Construye header con título + fecha, empresa y descripción.
Otros: Es prácticamente un clon de renderCertificateItem con 'company' en lugar de 'institution'. Ambas comparten la misma estructura de tarjeta.
*/
function renderExperienceItem(item) {
  let html = `<div class="card-item stagger-item reveal">
    <div class="card-header">
      <strong class="card-title">${t(item.title)}</strong>`
  if (item.date) html += `<span class="card-date">${t(item.date)}</span>`
  html += '</div>'
  if (item.company) html += `<p class="card-sub">${t(item.company)}</p>`
  if (item.description) html += `<p class="card-desc">${t(item.description)}</p>`
  html += '</div>'
  return html
}

/*
renderCertificateItem(item): Renderiza una tarjeta de certificado como HTML. Estructura idéntica a renderExperienceItem pero usando 'institution' en lugar de 'company'. Diseñada para certificados con título, fecha, institución emisora y descripción.
    - html: Acumulador de string. Construye la tarjeta completa del certificado.
Otros: No incluye URL — los certificados no tienen enlaces (regla definida en hard limits de tech-stack.md).
*/
function renderCertificateItem(item) {
  let html = `<div class="card-item stagger-item reveal">
    <div class="card-header">
      <strong class="card-title">${t(item.title)}</strong>`
  if (item.date) html += `<span class="card-date">${t(item.date)}</span>`
  html += '</div>'
  if (item.institution) html += `<p class="card-sub">${t(item.institution)}</p>`
  if (item.description) html += `<p class="card-desc">${t(item.description)}</p>`
  html += '</div>'
  return html
}

/*
toggleSection(id, arr): Oculta o muestra una sección del DOM depending on si tiene datos. Si el array está vacío o es null/undefined, la sección se oculta con display:none. Se usa para secciones que pueden estar vacías (experiencia, certificados).
    - el: Elemento DOM encontrado por getElementById(id). Si no existe, la función no hace nada.
Otros: Al asignar display:'' (string vacío), se elimina el estilo inline y la sección vuelve a su display por defecto definido en CSS.
*/
function toggleSection(id, arr) {
  const el = document.getElementById(id)
  if (el) el.style.display = (!arr || arr.length === 0) ? 'none' : ''
}

/*
updateScrollbar(): Controla la visibilidad de la scrollbar del contenedor de contenido. Si el contenido es más corto que el viewport (ratio > 0.9), oculta la scrollbar añadiendo la clase 'scrollbar-hidden'. Se llama al cambiar de página y al hacer resize.
    - el: El contenedor scrollable #content. Si no existe, la función aborta.
    - ratio: Proporción clientHeight / scrollHeight. Un valor > 0.9 significa que el contenido cabe casi completamente en el viewport, por lo que la scrollbar no es necesaria.
*/
function updateScrollbar() {
  const el = document.getElementById('content')
  if (!el) return
  const ratio = el.clientHeight / el.scrollHeight
  el.classList.toggle('scrollbar-hidden', ratio > 0.9)
}

/*
navigateTo(pageId): Sistema de navegación entre páginas con transiciones animadas. Oculta la página actual con animación de salida (350ms) y muestra la nueva con animación de entrada. También actualiza el nav activo, el footer y el estado en localStorage. Es la función central de la arquitectura de SPA del sitio.
    - oldPage: Página DOM actualmente visible (data-page="${currentPage}"). Se busca antes de cambiar currentPage.
    - newPage: Página DOM destino (data-page="${pageId}"). Si no existe, la función aborta.
    - contentEl: Contenedor scrollable #content. Se hace scroll al top antes de mostrar la nueva página.
    - motionOK: Booleano. Verdadero si el usuario NO tiene prefer-reduced-motion activado. Determina si se usa animación CSS o transición instantánea.
    - footer: Elemento .site-footer. Se oculta en páginas que no son 'sobre' o 'hab' (las que tienen sidebar).
Otros: La transición tiene 3 caminos: (1) con animación — añade clase 'exiting' y espera 350ms, (2) sin motion — cambio instantáneo, (3) sin oldPage — primera carga, solo muestra. El flag isTransitioning se gestiona internamente.
*/
function navigateTo(pageId) {
  if (pageId === currentPage || isTransitioning) return
  isTransitioning = true

  const oldPage = document.querySelector(`[data-page="${currentPage}"]`)
  const newPage = document.querySelector(`[data-page="${pageId}"]`)
  if (!newPage) { isTransitioning = false; return }

  if (oldPage?.querySelector('.tech-showcase')) storedRects.clear()

  const contentEl = document.getElementById('content')
  if (contentEl) contentEl.scrollTop = 0

  newPage.style.display = 'block'
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      newPage.classList.add('active')
    })
  })

  currentPage = pageId
  localStorage.setItem('currentPage', pageId)
  updateMobileProfile()
  sidebar?.classList.toggle('sidebar--about', pageId === 'sobre')

  const footer = document.querySelector('.site-footer')
  if (footer) footer.classList.toggle('hidden', pageId !== 'sobre')

  document.querySelectorAll('.sidebar-nav-link').forEach(link => {
    link.classList.toggle('active', link.dataset.nav === pageId)
  })

  if (oldPage && motionOK) {
    oldPage.classList.remove('active')
    oldPage.classList.add('exiting')
    setTimeout(() => {
      oldPage.classList.remove('exiting')
      oldPage.style.display = ''
      isTransitioning = false
      initScrollReveal()
      updateScrollbar()
    }, 350)
  } else if (oldPage) {
    oldPage.classList.remove('active')
    oldPage.style.display = ''
    isTransitioning = false
    initScrollReveal()
    updateScrollbar()
  } else {
    isTransitioning = false
    initScrollReveal()
    updateScrollbar()
  }
}

// --- Particle system ---
/*
initParticles(): Sistema de partículas flotantes en un canvas HTML. Crea partículas verdes semi-transparentes que se mueven lentamente por toda la pantalla. Las partículas se atenúan (dimming) cuando pasan sobre el sidebar, el botón de CV y el botón hamburguesa, creando un efecto de profundidad. El número de partículas se adapta al tamaño de pantalla.
    - canvas: Elemento canvas #particle-canvas. Si no existe, la función aborta.
    - ctx: Contexto de dibujo 2D del canvas. Se usa para clearRect, arc y fill.
    - particles: Array de objetos partícula. Cada partícula tiene {x, y, vx, vy, r, a} (posición, velocidad, radio, alpha).
    - w, h: Ancho y alto del canvas (igual a window.innerWidth/innerHeight). Se actualizan en resize.
    - sidebar: Elemento .sidebar. Se usa para calcular el ancho del sidebar y aplicar dimming a las partículas que pasan por detrás.
    - cvBtn: Elemento .sidebar-cv-btn. Se usa para calcular la zona de dimming alrededor del botón de descarga de CV.
    - hamburger: Elemento #sidebar-toggle. Se usa para calcular la zona de dimming alrededor del botón hamburguesa.

 Funciones internas:
    - resize(): Actualiza w y h al tamaño de la ventana. Se llama en cada resize del navegador.
    - createParticle(): Crea una partícula con posición y velocidad aleatoria dentro del canvas.
    - init(): Inicializa el canvas y crea el array de partículas. El count se adapta al área de pantalla (w*h/12000, máximo 80).
    - draw(): Bucle de renderizado principal. Limpia el canvas, mueve cada partícula, calcula el alpha según proximidad a sidebar/CV/hamburger, y dibuja el círculo. Se ejecuta con requestAnimationFrame.

    Variables internas de draw():
    - sidebarW: Ancho del sidebar en píxeles. Base para calcular la zona de dimming.
    - SIDEBAR_DIM: Factor mínimo de opacidad (0.05 = 5%). Las partículas nunca desaparecen del todo sobre el sidebar.
    - troughLeft, troughRight: Límites de la zona "trough" alrededor del botón CV donde las partículas están más opacas. Se calculan a partir de cvRect o como fallback: centro ± 100px.
    - cvRect: Bounding rect del botón CV. Se usa para calcular troughLeft/troughRight con precisión.
    - alpha: Opacidad calculada de cada partícula. Se modifica según la zona (sidebar, trough, hamburger).
    - t: Factor de interpolación lineal para el fade entre zona opaca y zona transparente.

 Variables internas del bloque hamburger:
    - hr: Bounding rect del botón hamburguesa.
    - cx, cy: Centro del hamburguesa en coordenadas de pantalla.
    - hw, hh: Semiancho y semialto del hamburguesa + 5px de margen. Define el área de influencia rectangular.
    - dx, dy: Distancia del punto más cercano del rectángulo del hamburguesa a la partícula (eje X e Y).
    - dist: Distancia euclídea desde la partícula hasta el borde del hamburguesa. Si es < 20px, se aplica dimming proporcional.

Otros: El canvas se resize automáticamente con la ventana. Las partículas envuelven (wrap) cuando salen del canvas — si x < 0 aparece por la derecha y viceversa. El color es rgba(100, 255, 218) — verde aguamarina.
*/
function initParticles() {
  const canvas = document.getElementById('particle-canvas')
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  let particles = []
  let w, h
  const sidebar = document.querySelector('.sidebar')
  const cvBtn = document.querySelector('.sidebar-cv-btn')
  const hamburger = document.getElementById('sidebar-toggle')

  function resize() {
    w = canvas.width = window.innerWidth
    h = canvas.height = window.innerHeight
  }

  function createParticle() {
    return {
      x: Math.random() * w,
      y: Math.random() * h,
      vx: (Math.random() - 0.5) * 0.5,
      vy: (Math.random() - 0.5) * 0.5,
      r: Math.random() * 2 + 1,
      a: Math.random() * 0.4 + 0.1
    }
  }

  function init() {
    resize()
    const count = Math.min(Math.floor(w * h / 12000), 80)
    particles = Array.from({ length: count }, createParticle)
  }

  function draw() {
    ctx.clearRect(0, 0, w, h)
    const sidebarW = sidebar ? sidebar.offsetWidth : 0
    const SIDEBAR_DIM = 0.05

    let troughLeft = sidebarW / 2 - 100
    let troughRight = sidebarW / 2 + 100
    if (cvBtn) {
      const cvRect = cvBtn.getBoundingClientRect()
      troughLeft = cvRect.left
      troughRight = cvRect.right
    }

    particles.forEach(p => {
      p.x += p.vx
      p.y += p.vy
      if (p.x < 0) p.x = w
      if (p.x > w) p.x = 0
      if (p.y < 0) p.y = h
      if (p.y > h) p.y = 0

      let alpha = p.a
      if (sidebarW > 0) {
        if (p.x < sidebarW) {
          if (p.x >= troughLeft && p.x <= troughRight) {
            alpha = p.a * SIDEBAR_DIM
          } else if (p.x < troughLeft) {
            const t = 1 - Math.max(0, p.x / troughLeft)
            alpha = p.a * (SIDEBAR_DIM + (1 - SIDEBAR_DIM) * t)
          } else {
            const t = Math.min(1, (p.x - troughRight) / (sidebarW - troughRight))
            alpha = p.a * (SIDEBAR_DIM + (1 - SIDEBAR_DIM) * t)
          }
        }
      }

      if (hamburger) {
        const hr = hamburger.getBoundingClientRect()
        const cx = (hr.left + hr.right) / 2
        const cy = (hr.top + hr.bottom) / 2
        const hw = (hr.right - hr.left) / 2 + 5
        const hh = (hr.bottom - hr.top) / 2 + 5
        const dx = Math.max(0, Math.abs(p.x - cx) - hw)
        const dy = Math.max(0, Math.abs(p.y - cy) - hh)
        const dist = Math.sqrt(dx * dx + dy * dy)
        if (dist < 20) {
          const t = dist / 20
          alpha *= 0.08 + 0.92 * t
        }
      }

      ctx.beginPath()
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
      ctx.fillStyle = `rgba(100, 255, 218, ${alpha})`
      ctx.fill()
    })
    requestAnimationFrame(draw)
  }

  window.addEventListener('resize', resize)
  init()
  draw()
}

// --- Scroll reveal ---
let scrollObserver = null

/*
initScrollReveal(): Inicializa el sistema de scroll reveal usando IntersectionObserver. Los elementos con clase 'reveal' se hacen visibles (añaden 'visible') cuando entran en el viewport. Se llama al init, al cambiar de página y tras renderAll(). Si el usuario tiene prefers-reduced-motion, todos los elementos se muestran inmediatamente sin animación.
    - motionOK: Booleano. Verdadero si el usuario NO tiene prefer-reduced-motion activado. Si es false, todos los .reveal reciben 'visible' directamente.
Otros: Se desconecta el observer anterior (scrollObserver.disconnect()) y se eliminan las clases 'visible' existentes antes de re-observar. Esto evita duplicados al cambiar de página. El threshold de 0.15 significa que el 15% del elemento debe ser visible para trigger.
*/
function initScrollReveal() {
  if (!motionOK) {
    document.querySelectorAll('.reveal').forEach(el => el.classList.add('visible'))
    return
  }
  if (scrollObserver) scrollObserver.disconnect()
  document.querySelectorAll('.reveal.visible').forEach(el => el.classList.remove('visible'))
  scrollObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible')
        scrollObserver.unobserve(entry.target)
      }
    })
  }, { threshold: 0.15 })
  document.querySelectorAll('.reveal').forEach(el => scrollObserver.observe(el))
}

// --- Language switching ---
/*
changeLanguage(lang): Cambia el idioma activo de toda la aplicación. Actualiza currentLang, re-renderiza todas las secciones con renderAll(), actualiza la clase 'active' en los botones de idioma, persiste la selección en localStorage y actualiza el atributo lang del <html>. Se llama al clicar los botones ES/EN.
Otros: Si el idioma solicitado es igual al actual, la función aborta (no re-renderiza innecesariamente). La persistencia en localStorage permite que al recargar la página se mantenga el idioma elegido.
*/
function changeLanguage(lang) {
  if (lang === currentLang) return
  currentLang = lang
  renderAll()
  document.querySelectorAll('.sidebar-lang-btn').forEach(btn => btn.classList.remove('active'))
  document.querySelectorAll(`[data-lang="${lang}"]`).forEach(btn => btn.classList.add('active'))
  localStorage.setItem('preferredLang', lang)
  document.documentElement.lang = lang
}

// --- Event listeners: language buttons ---
document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang))
})

// --- Event listeners: nav clicks ---
document.querySelectorAll('[data-nav]').forEach(btn => {
  btn.addEventListener('click', () => {
    navigateTo(btn.dataset.nav)
    closeSidebar()
  })
})

// --- Sidebar toggle (mobile) ---
const sidebar = document.getElementById('sidebar')
const sidebarToggle = document.getElementById('sidebar-toggle')
const sidebarOverlay = document.getElementById('sidebar-overlay')

/*
openSidebar(): Abre el sidebar móvil añadiendo la clase 'open' al sidebar, al overlay y al toggle. Bloquea el scroll del body con overflow:hidden para que el contenido de detrás no se pueda scrollear mientras el sidebar está abierto.
Otros: Si sidebar o sidebarOverlay no existen (desktop), la función aborta silenciosamente.
*/
function openSidebar() {
  if (!sidebar || !sidebarOverlay) return
  sidebar.classList.add('open')
  sidebarOverlay.classList.add('open')
  if (sidebarToggle) sidebarToggle.classList.add('open')
  document.body.style.overflow = 'hidden'
}

/*
closeSidebar(): Cierra el sidebar móvil eliminando la clase 'open' del sidebar, overlay y toggle. Restaura el scroll del body eliminando el overflow:hidden. Se llama al clicar fuera del sidebar, al pulsar Escape, al navegar a una página, y al superar 1235px de ancho.
Otros: Misma lógica de guard que openSidebar — aborta si los elementos no existen.
*/
function closeSidebar() {
  if (!sidebar || !sidebarOverlay) return
  if (!sidebar.classList.contains('open')) return
  sidebar.classList.remove('open')
  sidebarOverlay.classList.remove('open')
  if (sidebarToggle) sidebarToggle.classList.remove('open')
  document.body.style.overflow = ''
}

/*
toggleSidebar(): Alterna el estado del sidebar móvil. Comprueba si tiene la clase 'open' y llama a closeSidebar() o openSidebar() según corresponda. Se usa como handler del botón hamburguesa.
    - isOpen: Booleano que indica si el sidebar está actualmente abierto. Se comprueba con optional chaining (sidebar?.classList.contains).
*/
function toggleSidebar() {
  const isOpen = sidebar?.classList.contains('open')
  if (isOpen) closeSidebar()
  else openSidebar()
}

// --- Event listeners: sidebar ---
if (sidebarToggle) sidebarToggle.addEventListener('click', toggleSidebar)
if (sidebarOverlay) sidebarOverlay.addEventListener('click', closeSidebar)

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeSidebar()
})

const mql = window.matchMedia('(max-width: 1235px)')
mql.addEventListener('change', (e) => {
  if (!e.matches) closeSidebar()
  document.documentElement.classList.add('sidebar-no-transition')
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      document.documentElement.classList.remove('sidebar-no-transition')
    })
  })
})

// --- MobileProfile transition (sidebar-delayed/locked for sequential animations) ---
const mobileProfile = document.querySelector('.mobile-profile')
const mqlBreakpoint = window.matchMedia('(max-width: 1235px)')
let wasBelow = mqlBreakpoint.matches
let sidebarLockTimer = null
let mobileProfileTimer = null
let snapProfileTimer = null
let adjustTimer = null

/*
updateMobileProfile(): Controla la visibilidad del mobile-profile solo en la página "Sobre mí". En otras páginas se oculta instantáneamente (sin transición) para evitar que la animación de colapso interfiera con el contenido.
*/
function updateMobileProfile() {
  if (!mobileProfile) return
  if (mobileProfileTimer) { clearTimeout(mobileProfileTimer); mobileProfileTimer = null }
  if (snapProfileTimer) { clearTimeout(snapProfileTimer); snapProfileTimer = null }
  if (adjustTimer) { clearTimeout(adjustTimer); adjustTimer = null }
  const html = document.documentElement
  const shouldShow = (mqlBreakpoint.matches || html.classList.contains('sidebar-midpoint-mode')) && currentPage === 'sobre'
  if (shouldShow) {
    mobileProfile.style.height = ''
    mobileProfile.classList.add('mobile-profile--visible')
  } else {
    mobileProfile.style.transition = 'none'
    mobileProfile.classList.remove('mobile-profile--visible')
    mobileProfile.offsetHeight
    mobileProfile.style.transition = ''
    mobileProfile.style.height = '0'
  }
}

function animateMobileProfile(show, duration = 350) {
  if (!mobileProfile) return
  if (mobileProfileTimer) { clearTimeout(mobileProfileTimer); mobileProfileTimer = null }
  if (snapProfileTimer) { clearTimeout(snapProfileTimer); snapProfileTimer = null }
  if (adjustTimer) { clearTimeout(adjustTimer); adjustTimer = null }

  if (show) {
    mobileProfile.style.height = '0'
    mobileProfile.offsetHeight
    mobileProfile.classList.add('mobile-profile--visible')
    let h = mobileProfile.scrollHeight
    if (h <= 0) {
      mobileProfile.style.height = 'auto'
      mobileProfile.offsetHeight
      h = mobileProfile.scrollHeight
    }
    mobileProfile.offsetHeight
    mobileProfile.style.transition = `height ${duration}ms ease, opacity ${duration}ms ease`
    requestAnimationFrame(() => { mobileProfile.style.height = h + 'px' })
    mobileProfileTimer = setTimeout(() => {
      const finalH = mobileProfile.scrollHeight
      const currentH = Math.round(parseFloat(getComputedStyle(mobileProfile).height))
      if (Math.abs(finalH - currentH) > 2) {
        mobileProfile.style.transition = 'height 0.15s ease'
        mobileProfile.style.height = finalH + 'px'
        adjustTimer = setTimeout(() => {
          mobileProfile.style.height = ''
          mobileProfile.style.transition = ''
          adjustTimer = null
        }, 150)
      } else {
        mobileProfile.style.height = ''
        mobileProfile.style.transition = ''
      }
      mobileProfileTimer = null
    }, duration)
  } else {
    const h = mobileProfile.scrollHeight
    mobileProfile.style.height = h + 'px'
    mobileProfile.offsetHeight
    mobileProfile.classList.remove('mobile-profile--visible')
    mobileProfile.style.transition = `height ${duration}ms ease, opacity ${duration}ms ease`
    requestAnimationFrame(() => { mobileProfile.style.height = '0' })
    mobileProfileTimer = setTimeout(() => {
      mobileProfile.style.height = '0'
      mobileProfile.style.transition = ''
      mobileProfileTimer = null
    }, duration)
  }
}

function handleMobileProfile() {
  const isBelow = mqlBreakpoint.matches

  if (!isBelow && wasBelow) {
    // Growing past 1235px: delay sidebar transitions 350ms (mobile-profile collapse time)
    document.documentElement.classList.add('sidebar-delayed')
    document.querySelector('.sidebar')?.offsetHeight
    if (mobileProfile?.classList.contains('mobile-profile--visible')) {
      animateMobileProfile(false)
    }
    setTimeout(() => {
      document.documentElement.classList.remove('sidebar-delayed')
      document.documentElement.classList.remove('is-resizing')
      snapSidebarFade()
    }, 350)
  } else if (isBelow && !wasBelow) {
    // Shrinking past 1235px: lock sidebar during mobile-profile slide-in
    if (sidebarLockTimer) { clearTimeout(sidebarLockTimer); sidebarLockTimer = null }
    document.documentElement.classList.add('sidebar-locked')
    if (!mobileProfile?.classList.contains('mobile-profile--visible')) {
      animateMobileProfile(true)
    }
    sidebarLockTimer = setTimeout(() => {
      document.documentElement.classList.remove('sidebar-locked')
      sidebarLockTimer = null
    }, 350)
  }

  wasBelow = isBelow
}

mqlBreakpoint.addEventListener('change', handleMobileProfile)

if (mqlBreakpoint.matches) {
  updateMobileProfile()
}

// --- MobileProfile responsive layout (ResizeObserver) ---
const mobileProfileInner = document.querySelector('.mobile-profile-inner')
const PHOTO_W = 220
const NAME_GAP = 8
const COL_GAP = 20

if (mobileProfileInner) {
  const name = mobileProfileInner.querySelector('.mobile-profile-name')
  const text = mobileProfileInner.querySelector('.mobile-profile-text')
  const desc = mobileProfileInner.querySelector('.mobile-profile-desc')
  const actions = mobileProfileInner.querySelector('.mobile-profile-actions')
  const img = mobileProfileInner.querySelector('.mobile-profile-img')
  let flipAnimated = false

  const profileObserver = new ResizeObserver(entries => {
    const w = entries[0].contentRect.width
    const spans = name.querySelectorAll('span')

    // Capture name position BEFORE measurement — measurement temporarily
    // toggles --inline which forces name to stacked, corrupting the rect
    const oldNameRect = name.getBoundingClientRect()

    // Measure name width in inline orientation (temporarily toggle)
    name.classList.add('mobile-profile-name--inline')
    const nameInlineW = Array.from(spans).reduce((sum, s) => sum + s.scrollWidth, 0) + NAME_GAP
    name.classList.remove('mobile-profile-name--inline')

    // Measure name width in stacked orientation
    const nameStackedW = Math.max(...Array.from(spans).map(s => s.scrollWidth)) + NAME_GAP

    const descW = desc.scrollWidth

    // Two thresholds: stacked row vs inline row
    const totalNeededStacked = PHOTO_W + Math.max(nameStackedW, descW) + actions.scrollWidth + (3 * COL_GAP)
    const totalNeededInline = PHOTO_W + Math.max(nameInlineW, descW) + actions.scrollWidth + (3 * COL_GAP)

    const shouldRow = w >= totalNeededStacked
    const nameFitsInline = w >= nameInlineW
    const shouldInline = shouldRow ? (w >= totalNeededInline) : nameFitsInline

    // Toggle name inline layout
    name.classList.toggle('mobile-profile-name--inline', shouldInline)

    const wasRow = mobileProfileInner.classList.contains('mobile-profile-inner--row')

    if (shouldRow === wasRow) {
      // Grid NOT changing — compensate vertical shift for name layout change
      if (flipAnimated) {
        const newNameRect = name.getBoundingClientRect()
        const dy = oldNameRect.top - newNameRect.top
        if (dy !== 0) {
          name.style.transition = 'none'
          name.style.transform = `translateY(${dy}px)`
          name.getBoundingClientRect()
          name.style.transition = 'transform 0.2s ease-out'
          name.style.transform = ''
        }
      }
      return
    }

    if (flipAnimated) {
      // Suppress parent transitions during FLIP
      mobileProfileInner.style.transition = 'none'

      const oldImg = img.getBoundingClientRect()
      const oldText = text.getBoundingClientRect()
      const oldActions = actions.getBoundingClientRect()

      mobileProfileInner.classList.toggle('mobile-profile-inner--row', shouldRow)

      const newImg = img.getBoundingClientRect()
      const newText = text.getBoundingClientRect()
      const newActions = actions.getBoundingClientRect()

      const elements = [
        [img, oldImg, newImg],
        [text, oldText, newText],
        [actions, oldActions, newActions]
      ]

      let animCount = 0
      for (const [el, oldR, newR] of elements) {
        const dx = oldR.left - newR.left
        const dy = oldR.top - newR.top
        if (dx === 0 && dy === 0) continue
        el.style.transform = `translate(${dx}px, ${dy}px)`
        el.style.transition = 'none'
        animCount++
      }

      mobileProfileInner.getBoundingClientRect()

      for (const [el] of elements) {
        if (el.style.transform) {
          el.style.transition = 'transform 0.3s ease'
          el.style.transform = ''
        }
      }

      const cleanup = () => {
        animCount--
        if (animCount > 0) return
        for (const [el] of elements) {
          el.style.transition = ''
          el.style.transform = ''
        }
        mobileProfileInner.style.transition = ''
        mobileProfileInner.removeEventListener('transitionend', cleanup)
      }
      mobileProfileInner.addEventListener('transitionend', cleanup)
    } else {
      mobileProfileInner.classList.toggle('mobile-profile-inner--row', shouldRow)
      flipAnimated = true
    }
  })
  profileObserver.observe(mobileProfileInner)
}

// --- Back to top ---
const backToTop = document.getElementById('back-to-top')
const contentEl = document.getElementById('content')

if (backToTop && contentEl) {
  backToTop.addEventListener('click', (e) => {
    e.preventDefault()
    contentEl.scrollTo({ top: 0, behavior: 'smooth' })
  })
  contentEl.addEventListener('scroll', () => {
    if (contentEl.scrollTop > 300) {
      backToTop.classList.add('show')
    } else {
      backToTop.classList.remove('show')
    }
  })
}

// --- Init ---
/*
init(): Inicialización maestra de toda la aplicación. Se ejecuta al final del archivo y es el punto de entrada único. Restaura el estado persistido (idioma y página), renderiza la UI, inicia el sistema de partículas, oculta el spinner de carga y configura los event listeners de resize. Diseñada para que la app arranche exactamente donde el usuario la dejó.
    - savedLang: Idioma guardado en localStorage. Si no existe, usa 'es' como fallback.
    - savedPage: Página guardada en localStorage. Si no existe, usa 'sobre' como fallback.
    - validPage: Página validada — comprueba que el data-page existe en el DOM. Si no existe (página eliminada), cae a 'sobre'. Evita mostrar una página que ya no está en el HTML.
    - activePage: Elemento DOM de la página guardada. Se le añade la clase 'active' para mostrarla.
    - activeNav: Elemento DOM del enlace de nav correspondiente a la página guardada. Se marca como activo.
    - footer: Elemento .site-footer. Se oculta si la página guardada no es 'sobre' o 'hab'.
    - spinner: Elemento #loading-spinner. Se le añade la clase 'done' para iniciar la animación de ocultación, pero solo si el <html> tiene la clase 'show-spinner' (indicando que JS cargó correctamente).

Otros: clearTimeout(window.__spinnerTimer) cancela el timer de fallback del spinner (por si JS carga lento). Al final, se elimina 'js-loading' del <html> para activar las transiciones CSS que estaban pausadas.
*/
function init() {
  clearTimeout(window.__spinnerTimer)

  const savedLang = localStorage.getItem('preferredLang') || 'es'
  currentLang = savedLang

  const savedPage = localStorage.getItem('currentPage') || 'sobre'
  const validPage = document.querySelector(`[data-page="${savedPage}"]`) ? savedPage : 'sobre'
  currentPage = validPage

  document.querySelectorAll(`[data-lang="${savedLang}"]`).forEach(btn => btn.classList.add('active'))

  const activePage = document.querySelector(`[data-page="${validPage}"]`)
  if (activePage) activePage.classList.add('active')
  const activeNav = document.querySelector(`[data-nav="${validPage}"]`)
  if (activeNav) activeNav.classList.add('active')

  const footer = document.querySelector('.site-footer')
  if (footer) footer.classList.toggle('hidden', validPage !== 'sobre')

  document.documentElement.lang = savedLang
  translateUI()

  renderAll()

  updateMobileProfile()
  sidebar?.classList.toggle('sidebar--about', validPage === 'sobre')

  initParticles()

  const spinner = document.getElementById('loading-spinner')
  if (spinner && document.documentElement.classList.contains('show-spinner')) {
    spinner.classList.add('done')
  }

  initScrollReveal()
  updateScrollbar()

  const initW = window.innerWidth
  if (initW > 1235 && initW < 1337) {
    const initClass = initW < 1286 ? 'sidebar-init-mobile' : 'sidebar-init-desktop'
    document.documentElement.classList.add(initClass)
    if (initW < 1286) {
      document.documentElement.classList.add('sidebar-no-transition')
      document.documentElement.classList.add('sidebar-midpoint-mode')
    }
  }

  document.documentElement.classList.remove('js-loading')

  window.addEventListener('resize', updateScrollbar)

  if (initW > 1235 && initW < 1286) {
    setTimeout(() => { updateMobileProfile() }, 350)
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        document.documentElement.classList.remove('sidebar-no-transition')
      })
    })
  }
  if (initW > 1235 && initW < 1337) {
    window.addEventListener('resize', function () {
      document.documentElement.classList.remove('sidebar-init-mobile', 'sidebar-init-desktop', 'sidebar-midpoint-mode')
    }, { once: true })
  }
}

// --- Resize debounce + snap on mouseup ---
let resizeTimer

document.addEventListener('mouseup', () => {
  const html = document.documentElement
  if (html.classList.contains('is-resizing')) {
    clearTimeout(resizeTimer)
    html.classList.remove('is-resizing')
    snapSidebarFade()
  }
})

function snapSidebarFade() {
  const w = window.innerWidth
  const html = document.documentElement
  if (w >= 1286 && w <= 1336) {
    html.classList.remove('sidebar-midpoint-mode')
    html.style.setProperty('--sidebar-fade', '1')
  } else if (w >= 1236 && w < 1286) {
    html.classList.add('sidebar-no-transition')
    html.style.setProperty('--sidebar-fade', '0')
    html.classList.add('sidebar-midpoint-mode')
    html.classList.add('lang-switcher-delayed')
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        html.classList.remove('sidebar-no-transition')
      })
    })
    setTimeout(() => {
      html.classList.remove('lang-switcher-delayed')
      html.classList.add('lang-switcher-reveal')
      const ls = document.querySelector('.lang-switcher-floating')
      ls?.addEventListener('animationend', () => {
        html.classList.remove('lang-switcher-reveal')
      }, { once: true })
    }, 340)
    snapProfileTimer = setTimeout(() => {
      if (html.classList.contains('sidebar-midpoint-mode')) {
        animateMobileProfile(true)
      }
    }, 350)
  } else {
    html.classList.remove('sidebar-midpoint-mode')
    html.style.removeProperty('--sidebar-fade')
  }
}

window.addEventListener('resize', () => {
  const html = document.documentElement
  const wasInMidpoint = html.classList.contains('sidebar-midpoint-mode')

  html.style.removeProperty('--sidebar-fade')
  html.classList.add('is-resizing')

  if (wasInMidpoint) {
    html.classList.remove('sidebar-midpoint-mode')
    if (window.innerWidth > 1235 && mobileProfile?.classList.contains('mobile-profile--visible')) {
      if (mobileProfileTimer) { clearTimeout(mobileProfileTimer); mobileProfileTimer = null }
      if (snapProfileTimer) { clearTimeout(snapProfileTimer); snapProfileTimer = null }
      if (adjustTimer) { clearTimeout(adjustTimer); adjustTimer = null }
      mobileProfile.style.transition = 'none'
      mobileProfile.classList.remove('mobile-profile--visible')
      mobileProfile.offsetHeight
      mobileProfile.style.transition = ''
      mobileProfile.style.height = '0'
    }
  }

  clearTimeout(resizeTimer)
  resizeTimer = setTimeout(() => {
    html.classList.remove('is-resizing')
    snapSidebarFade()
  }, 1000)
})

init()
