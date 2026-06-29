const DATA = JSON.parse(document.body.dataset.data);
let currentLang = localStorage.getItem('preferredLang') || 'es';

function t(field) {
  if (!field) return '';
  if (typeof field === 'string') return field;
  return field[currentLang] || field.es || field.en || '';
}

function translateUI() {
  const data = DATA.lang;
  if (!data) return;
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    if (data[currentLang] && data[currentLang][key]) {
      el.innerHTML = data[currentLang][key];
    }
  });
}

function renderAll() {
  translateUI();
  renderSection('skills', DATA.skills, renderSkillItem);
  renderSection('projects', DATA.projects, renderProjectItem);
  renderSection('education', DATA.education, renderEducationItem);
  renderSection('experience', DATA.experience, renderExperienceItem);
  renderSection('certificates', DATA.certificates, renderCertificateItem);
  toggleSection('experiencia', DATA.experience);
  toggleSection('certificados', DATA.certificates);
}

function renderSection(name, items, renderFn) {
  const container = document.querySelector(`[data-section="${name}"]`);
  if (!container) return;
  container.innerHTML = (items || []).map(renderFn).join('');
}

function renderSkillItem(s) {
  return `<div class="skill-item"><strong>${t(s.title)}</strong><p>${t(s.description)}</p></div>`;
}

function renderEducationItem(item) {
  let html = `<div class="education-item"><div class="edu-header"><strong>${t(item.title)}</strong>`;
  if (item.date) html += `<span class="edu-date">${t(item.date)}</span>`;
  html += '</div>';
  if (item.institution) html += `<p class="edu-institution">${t(item.institution)}</p>`;
  if (item.description) html += `<p class="edu-description">${t(item.description)}</p>`;
  if (item.list && item.list.length) {
    html += '<ul class="edu-list">';
    item.list.forEach(li => html += `<li>${t(li)}</li>`);
    html += '</ul>';
  }
  html += '</div>';
  return html;
}

function renderProjectItem(proj) {
  let html = `<div class="project-card"><h3>${proj.title}</h3><p>${t(proj.description)}</p>`;
  if (proj.links && proj.links.length) {
    html += '<div class="project-links">';
    proj.links.forEach(link => html += `<a href="${link.url}" target="_blank" rel="noopener noreferrer" class="btn btn-outline">${t(link.text)}</a>`);
    html += '</div>';
  }
  html += '</div>';
  return html;
}

function renderExperienceItem(item) {
  let html = `<div class="education-item"><div class="edu-header"><strong>${t(item.title)}</strong>`;
  if (item.date) html += `<span class="edu-date">${t(item.date)}</span>`;
  html += '</div>';
  if (item.company) html += `<p class="edu-institution">${t(item.company)}</p>`;
  if (item.description) html += `<p class="edu-description">${t(item.description)}</p>`;
  html += '</div>';
  return html;
}

function renderCertificateItem(item) {
  let html = `<div class="education-item"><div class="edu-header"><strong>${t(item.title)}</strong>`;
  if (item.date) html += `<span class="edu-date">${t(item.date)}</span>`;
  html += '</div>';
  if (item.institution) html += `<p class="edu-institution">${t(item.institution)}</p>`;
  if (item.description) html += `<p class="edu-description">${t(item.description)}</p>`;
  html += '</div>';
  return html;
}

function toggleSection(id, arr) {
  const el = document.getElementById(id);
  if (el) el.style.display = (!arr || arr.length === 0) ? 'none' : '';
}

function changeLanguage(lang) {
  if (lang === currentLang) return;
  currentLang = lang;
  renderAll();
  document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'));
  document.getElementById(`btn-${lang}`).classList.add('active');
  localStorage.setItem('preferredLang', lang);
  document.documentElement.lang = lang;
  requestAnimationFrame(() => reveal());
}

function reveal() {
  const reveals = document.querySelectorAll('.reveal');
  for (let i = 0; i < reveals.length; i++) {
    const windowHeight = window.innerHeight;
    const elementTop = reveals[i].getBoundingClientRect().top;
    if (elementTop < windowHeight - 150) {
      reveals[i].classList.add('active');
    }
  }
}

const motionOK = !window.matchMedia('(prefers-reduced-motion: reduce)').matches;

if (motionOK) {
  window.addEventListener('scroll', reveal);
} else {
  document.querySelectorAll('.reveal').forEach(el => el.classList.add('active'));
}

window.addEventListener('scroll', function () {
  const btn = document.getElementById('back-to-top');
  if (!btn) return;
  if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) {
    btn.classList.add('show');
  } else {
    btn.classList.remove('show');
  }
});

document.querySelectorAll('[data-lang]').forEach(btn => {
  btn.addEventListener('click', () => changeLanguage(btn.dataset.lang));
});

function init() {
  const savedLang = localStorage.getItem('preferredLang') || 'es';
  currentLang = savedLang;
  translateUI();
  toggleSection('experiencia', DATA.experience);
  toggleSection('certificados', DATA.certificates);
  if (savedLang !== 'es') renderAll();
  document.getElementById(`btn-${savedLang}`).classList.add('active');
  document.documentElement.lang = savedLang;
  requestAnimationFrame(() => reveal());
}

init();
