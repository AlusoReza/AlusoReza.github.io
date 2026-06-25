let currentLang = localStorage.getItem('preferredLang') || 'es';

function decodeHtml(str) {
  const txt = document.createElement('textarea');
  txt.innerHTML = str;
  return txt.value;
}

function t(field) {
  if (!field) return '';
  if (typeof field === 'string') return decodeHtml(field);
  return decodeHtml(field[currentLang] || field.es || field.en || '');
}

function translateUI() {
  const data = window.DATA.lang;
  if (!data) return;
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.dataset.i18n;
    if (data[currentLang] && data[currentLang][key]) {
      el.innerHTML = decodeHtml(data[currentLang][key]);
    }
  });
}

function renderAll() {
  translateUI();
  renderSection('skills', window.DATA.skills, renderSkillItem);
  renderSection('projects', window.DATA.projects, renderProjectItem);
  renderSection('education', window.DATA.education, renderEducationItem);
  renderSection('experience', window.DATA.experience, renderExperienceItem);
  renderSection('certificates', window.DATA.certificates, renderCertificateItem);
  toggleSection('experiencia', window.DATA.experience);
  toggleSection('certificados', window.DATA.certificates);
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
    proj.links.forEach(link => html += `<a href="${link.url}" target="_blank" class="btn btn-primary">${t(link.text)}</a>`);
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
  currentLang = lang;
  renderAll();
  document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'));
  document.getElementById(`btn-${lang}`).classList.add('active');
  localStorage.setItem('preferredLang', lang);
  document.documentElement.lang = lang;
  requestAnimationFrame(() => reveal());
}
window.changeLanguage = changeLanguage;

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

window.addEventListener('scroll', reveal);
window.addEventListener('scroll', function () {
  const btn = document.getElementById('back-to-top');
  if (!btn) return;
  if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) {
    btn.classList.add('show');
  } else {
    btn.classList.remove('show');
  }
});

function init() {
  const savedLang = localStorage.getItem('preferredLang') || 'es';
  currentLang = savedLang;
  translateUI();
  toggleSection('experiencia', window.DATA.experience);
  toggleSection('certificados', window.DATA.certificates);
  document.getElementById(`btn-${savedLang}`).classList.add('active');
  document.documentElement.lang = savedLang;
  requestAnimationFrame(() => reveal());
}

init();
