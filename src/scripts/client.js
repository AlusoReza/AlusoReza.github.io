const DATA = JSON.parse(document.body.dataset.data)
let currentLang = localStorage.getItem('preferredLang') || 'es'
let currentPage = 'sobre'
let isTransitioning = false

function t(field) {
  if (!field) return ''
  if (typeof field === 'string') return field
  return field[currentLang] || field.es || field.en || ''
}

function translateUI() {
  const data = DATA.lang
  if (!data) return
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n
    if (data[currentLang] && data[currentLang][key]) {
      el.innerHTML = data[currentLang][key]
    }
  })
}

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

function renderSection(name, items, renderFn) {
  const container = document.querySelector(`[data-section="${name}"]`)
  if (!container) return
  container.innerHTML = (items || []).map(renderFn).join('')
}

function renderPersonalityItem(s) {
  return `<div class="skill-personality-item stagger-item reveal">
    <strong>${t(s.title)}</strong>
    <p>${t(s.description)}</p>
  </div>`
}

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

function toggleSection(id, arr) {
  const el = document.getElementById(id)
  if (el) el.style.display = (!arr || arr.length === 0) ? 'none' : ''
}

function updateScrollbar() {
  const el = document.getElementById('content')
  if (!el) return
  const ratio = el.clientHeight / el.scrollHeight
  el.classList.toggle('scrollbar-hidden', ratio > 0.9)
}

function navigateTo(pageId) {
  if (pageId === currentPage || isTransitioning) return
  isTransitioning = true

  const oldPage = document.querySelector(`[data-page="${currentPage}"]`)
  const newPage = document.querySelector(`[data-page="${pageId}"]`)
  if (!newPage) { isTransitioning = false; return }

  const contentEl = document.getElementById('content')
  if (contentEl) contentEl.scrollTop = 0

  const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches

  newPage.style.display = 'block'
  requestAnimationFrame(() => {
    newPage.classList.add('active')
  })

  currentPage = pageId
  localStorage.setItem('currentPage', pageId)

  const footer = document.querySelector('.site-footer')
  if (footer) footer.classList.toggle('hidden', !['sobre', 'hab'].includes(pageId))

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
function initParticles() {
  const canvas = document.getElementById('particle-canvas')
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  let particles = []
  let w, h
  const sidebar = document.querySelector('.sidebar')
  const cvBtn = document.querySelector('.sidebar-cv-btn')

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

function initScrollReveal() {
  const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches
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
function changeLanguage(lang) {
  if (lang === currentLang) return
  currentLang = lang
  renderAll()
  document.querySelectorAll('.sidebar-lang-btn').forEach(btn => btn.classList.remove('active'))
  document.querySelectorAll(`[data-lang="${lang}"]`).forEach(btn => btn.classList.add('active'))
  localStorage.setItem('preferredLang', lang)
  document.documentElement.lang = lang
  translateUI()
}

document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang))
})

// --- Nav clicks ---
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

function openSidebar() {
  if (!sidebar || !sidebarOverlay) return
  sidebar.classList.add('open')
  sidebarOverlay.classList.add('open')
  document.body.style.overflow = 'hidden'
}

function closeSidebar() {
  if (!sidebar || !sidebarOverlay) return
  sidebar.classList.remove('open')
  sidebarOverlay.classList.remove('open')
  document.body.style.overflow = ''
}

function toggleSidebar() {
  const isOpen = sidebar?.classList.contains('open')
  if (isOpen) closeSidebar()
  else openSidebar()
}

if (sidebarToggle) sidebarToggle.addEventListener('click', toggleSidebar)
if (sidebarOverlay) sidebarOverlay.addEventListener('click', closeSidebar)

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeSidebar()
})

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
  if (footer) footer.classList.toggle('hidden', !['sobre', 'hab'].includes(validPage))

  document.documentElement.lang = savedLang
  translateUI()

  if (savedLang !== 'es') renderAll()

  initParticles()

  const spinner = document.getElementById('loading-spinner')
  if (spinner && document.documentElement.classList.contains('show-spinner')) {
    spinner.classList.add('done')
  }

  initScrollReveal()
  updateScrollbar()
  document.documentElement.classList.remove('js-loading')

  window.addEventListener('resize', updateScrollbar)
}

init()
