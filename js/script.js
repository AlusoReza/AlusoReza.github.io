let currentLang = 'es';
let tr = {};
let data = {};

async function init() {
    const savedLang = localStorage.getItem('preferredLang') || 'es';
    currentLang = savedLang;
    document.documentElement.lang = savedLang;

    try {
        const res = await fetch('data/lang.json');
        tr = await res.json();
    } catch (e) {
        console.error('Failed to load lang.json', e);
    }

    const sections = ['profile', 'skills', 'education', 'projects', 'experience', 'certificates'];
    const results = await Promise.allSettled(
        sections.map(name =>
            fetch(`data/${name}.json`).then(r => r.json()).then(d => data[name] = d)
        )
    );
    results.forEach((r, i) => {
        if (r.status === 'rejected') console.error(`Failed to load ${sections[i]}.json`, r.reason);
    });

    renderAll();
    document.getElementById(`btn-${savedLang}`).classList.add('active');
    requestAnimationFrame(() => reveal());
}

function t(field) {
    if (!field) return '';
    if (typeof field === 'string') return field;
    return field[currentLang] || field.es || field.en || '';
}

function translateUI() {
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;
        if (tr[currentLang] && tr[currentLang][key]) {
            el.innerHTML = tr[currentLang][key];
        }
    });
}

function renderAll() {
    translateUI();
    renderBadges();
    renderSkills();
    renderEducation();
    renderProjects();
    renderExperience();
    renderCertificates();
    toggleSection('experiencia', data.experience);
    toggleSection('certificados', data.certificates);
}

function toggleSection(id, arr) {
    const el = document.getElementById(id);
    if (el) el.style.display = (!arr || arr.length === 0) ? 'none' : '';
}

function renderBadges() {
    const container = document.getElementById('badges-container');
    if (!container || !data.profile) return;
    const profile = data.profile;
    let html = '<div class="badges">';
    (profile.badges || []).forEach(b => html += `<span class="badge ${b.class}">${b.label}</span>`);
    html += '</div>';
    if (profile.toolBadges && profile.toolBadges.length) {
        html += '<div class="badges tools-badges">';
        profile.toolBadges.forEach(b => html += `<span class="badge ${b.class}">${b.label}</span>`);
        html += '</div>';
    }
    container.innerHTML = html;
}

function renderSkills() {
    const container = document.querySelector('[data-section="skills"]');
    if (!container) return;
    const items = data.skills || [];
    container.innerHTML = items.map(s =>
        `<div class="skill-item"><strong>${t(s.title)}</strong><p>${t(s.description)}</p></div>`
    ).join('');
}

function renderEducation() {
    const container = document.querySelector('[data-section="education"]');
    if (!container) return;
    const items = data.education || [];
    container.innerHTML = items.map(item => {
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
    }).join('');
}

function renderProjects() {
    const container = document.querySelector('[data-section="projects"]');
    if (!container) return;
    const items = data.projects || [];
    container.innerHTML = items.map(proj => {
        let html = `<div class="project-card"><h3>${proj.title}</h3><p>${t(proj.description)}</p>`;
        if (proj.links && proj.links.length) {
            html += '<div class="project-links">';
            proj.links.forEach(link => html += `<a href="${link.url}" target="_blank" class="btn btn-primary">${t(link.text)}</a>`);
            html += '</div>';
        }
        html += '</div>';
        return html;
    }).join('');
}

function renderExperience() {
    const container = document.querySelector('[data-section="experience"]');
    if (!container) return;
    const items = data.experience || [];
    container.innerHTML = items.map(item => {
        let html = `<div class="education-item"><div class="edu-header"><strong>${t(item.title)}</strong>`;
        if (item.date) html += `<span class="edu-date">${t(item.date)}</span>`;
        html += '</div>';
        if (item.company) html += `<p class="edu-institution">${t(item.company)}</p>`;
        if (item.description) html += `<p class="edu-description">${t(item.description)}</p>`;
        html += '</div>';
        return html;
    }).join('');
}

function renderCertificates() {
    const container = document.querySelector('[data-section="certificates"]');
    if (!container) return;
    const items = data.certificates || [];
    container.innerHTML = items.map(item => {
        let html = `<div class="education-item"><div class="edu-header"><strong>${t(item.title)}</strong>`;
        if (item.date) html += `<span class="edu-date">${t(item.date)}</span>`;
        html += '</div>';
        if (item.institution) html += `<p class="edu-institution">${t(item.institution)}</p>`;
        if (item.description) html += `<p class="edu-description">${t(item.description)}</p>`;
        html += '</div>';
        return html;
    }).join('');
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

init();
