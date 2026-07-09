const DATA = JSON.parse(document.body.dataset.data)
let currentLang = localStorage.getItem('preferredLang') || 'es'

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
  renderSection('skills', DATA.skills, renderSkillItem)
  renderSection('projects', DATA.projects, renderProjectItem)
  renderSection('education', DATA.education, renderEducationItem)
  renderSection('experience', DATA.experience, renderExperienceItem)
  renderSection('certificates', DATA.certificates, renderCertificateItem)
  toggleSection('experiencia', DATA.experience)
  toggleSection('certificados', DATA.certificates)
}

function renderSection(name, items, renderFn) {
  const container = document.querySelector(`[data-section="${name}"]`)
  if (!container) return
  container.innerHTML = (items || []).map(renderFn).join('')
}

function renderSkillItem(s) {
  return `<div class="skill-item stagger-item">
    <strong>${t(s.title)}</strong>
    <p>${t(s.description)}</p>
  </div>`
}

function renderEducationItem(item) {
  let html = `<div class="card-item stagger-item">
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
  let html = `<div class="project-card stagger-item">
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
  let html = `<div class="card-item stagger-item">
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
  let html = `<div class="card-item stagger-item">
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

function changeLanguage(lang) {
  if (lang === currentLang) return
  currentLang = lang
  renderAll()
  document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'))
  const activeBtn = document.getElementById(`btn-${lang}`)
  if (activeBtn) activeBtn.classList.add('active')
  localStorage.setItem('preferredLang', lang)
  document.documentElement.lang = lang
  requestAnimationFrame(() => {
    observeAll()
    observeStagger()
  })
}

// --- Intersection Observer scroll-reveal with stagger ---

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('active')
      observer.unobserve(entry.target)
    }
  })
}, { threshold: 0.15 })

function observeAll() {
  if (!motionOK) {
    document.querySelectorAll('.reveal, .stagger-item').forEach(el => el.classList.add('active'))
    return
  }
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el))
}

// Stagger animation for grid items (skill, project, education, etc.)
const staggerObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      const parent = entry.target
      const items = parent.querySelectorAll('.stagger-item')
      items.forEach((item, i) => {
        item.style.transitionDelay = `${i * 80}ms`
        item.classList.add('active')
      })
      staggerObserver.unobserve(parent)
    }
  })
}, { threshold: 0.15 })

function observeStagger() {
  document.querySelectorAll('[data-section]').forEach(el => staggerObserver.observe(el))
}

const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches

// Back-to-top button
const backToTop = document.getElementById('back-to-top')
if (backToTop) {
  if (backToTop.dataset.listener !== 'true') {
    window.addEventListener('scroll', function () {
      const scrollY = document.body.scrollTop || document.documentElement.scrollTop
      if (scrollY > 400) {
        backToTop.classList.add('show')
      } else {
        backToTop.classList.remove('show')
      }
    })
    backToTop.dataset.listener = 'true'
  }
  // Initial check
  if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) {
    backToTop.classList.add('show')
  }
}

document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang))
})

function init() {
  const savedLang = localStorage.getItem('preferredLang') || 'es'
  currentLang = savedLang
  translateUI()
  toggleSection('experiencia', DATA.experience)
  toggleSection('certificados', DATA.certificates)
  if (savedLang !== 'es') renderAll()
  const activeBtn = document.getElementById(`btn-${savedLang}`)
  if (activeBtn) activeBtn.classList.add('active')
  document.documentElement.lang = savedLang
  requestAnimationFrame(() => {
    observeAll()
    observeStagger()
  })
}

init()

// --- Hamburger menu drawer ---

const navToggle = document.getElementById('nav-toggle')
const navLinks = document.getElementById('nav-links')
const navOverlay = document.getElementById('nav-overlay')

function closeNav() {
  if (!navLinks || !navOverlay) return
  navLinks.classList.remove('open')
  navOverlay.classList.remove('open')
  document.body.style.overflow = ''
}

function toggleNav() {
  if (!navLinks || !navOverlay) return
  const isOpen = navLinks.classList.toggle('open')
  navOverlay.classList.toggle('open')
  document.body.style.overflow = isOpen ? 'hidden' : ''
}

if (navToggle) {
  navToggle.addEventListener('click', toggleNav)
}

if (navOverlay) {
  navOverlay.addEventListener('click', closeNav)
}

if (navLinks) {
  navLinks.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', closeNav)
  })
}

document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && navLinks?.classList.contains('open')) {
    closeNav()
  }
})
