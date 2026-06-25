# .agents/tests/check-json-schema.ps1
# JSON schema compliance test
# Run: pwsh .agents/tests/check-json-schema.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$dataDir = "$root\src\data"

$passes = @()
$failures = @()
$warnings = @()

function Pass($msg) {
    $global:passes += $msg
    Write-Host "  [PASS]" -ForegroundColor Green -NoNewline; Write-Host " $msg"
}
function Fail($msg, $plan) {
    $global:failures += @{ message = $msg; plan = $plan }
    Write-Host "  [FAIL]" -ForegroundColor Red -NoNewline; Write-Host " $msg"
}
function Warn($msg, $plan) {
    $global:warnings += @{ message = $msg; plan = $plan }
    Write-Host "  [WARN]" -ForegroundColor Yellow -NoNewline; Write-Host " $msg"
}
function Title($t) {
    Write-Host "`n── $t ──" -ForegroundColor Cyan
}
function Get-JsonSafe($path) {
    try { return Get-Content $path -Raw | ConvertFrom-Json } catch { return $null }
}

# ─── CHECK 1-3: lang.json ───
Title "lang.json"
$lang = Get-JsonSafe "$dataDir\lang.json"
if ($lang) {
    $requiredEs = @('nav-inicio', 'nav-sobre', 'nav-hab', 'nav-proy', 'nav-est', 'nav-cont', 'nav-exp', 'nav-cert', 'hero-sub', 'cv-text-h', 'cv-text-f', 'sec-sobre', 'sec-hab', 'sec-proy', 'sec-est', 'sec-exp', 'sec-cert', 'sec-cont', 'sobre-p1', 'sobre-p2', 'sobre-p3', 'hab-note', 'hab-ai', 'cont-sub', 'soc-li', 'soc-gh')
    $missingEs = $requiredEs | Where-Object { -not $lang.es.$_ }
    $missingEn = $requiredEs | Where-Object { -not $lang.en.$_ }
    if ($missingEs.Count -eq 0 -and $missingEn.Count -eq 0) { Pass "lang.json has all required keys in ES and EN ($($requiredEs.Count) keys)" }
    else {
        if ($missingEs.Count -gt 0) { Warn "Missing keys in lang.json.es: $($missingEs -join ', ')" "Add missing keys" }
        if ($missingEn.Count -gt 0) { Warn "Missing keys in lang.json.en: $($missingEn -join ', ')" "Add missing keys" }
    }
} else { Fail "lang.json not found or invalid" "Verify src/data/lang.json exists and is valid JSON" }

# ─── CHECK 4-5: profile.json ───
Title "profile.json"
$profile = Get-JsonSafe "$dataDir\profile.json"
if ($profile) {
    $missing = @()
    if (-not $profile.name) { $missing += "name" }
    if (-not $profile.cvPath) { $missing += "cvPath" }
    if (-not $profile.badges -or $profile.badges.Count -eq 0) { $missing += "badges" }
    if ($missing.Count -eq 0) { Pass "profile.json complete (name, cvPath, badges)" }
    else { Fail "profile.json incomplete: $($missing -join ', ')" "Add required fields" }
} else { Fail "profile.json not found" "Check src/data/profile.json" }

# ─── CHECK 6-7: skills.json ───
Title "skills.json"
$skills = Get-JsonSafe "$dataDir\skills.json"
if ($skills -and $skills.Count -gt 0) {
    $bilingualIssues = @()
    foreach ($s in $skills) {
        if (-not $s.title.es -or -not $s.title.en) { $bilingualIssues += "$($s.title) (title)" }
        if (-not $s.description.es -or -not $s.description.en) { $bilingualIssues += "$($s.title) (description)" }
    }
    if ($bilingualIssues.Count -eq 0) { Pass "skills.json: $($skills.Count) skills, all bilingual" }
    else { Fail "skills.json has non-bilingual fields: $($bilingualIssues -join ', ')" "Use {es, en} format" }
} else { Warn "skills.json empty or not found" "Verify at least one skill exists" }

# ─── CHECK 8-9: education.json ───
Title "education.json"
$edu = Get-JsonSafe "$dataDir\education.json"
if ($edu -and $edu.Count -gt 0) {
    $issues = @()
    foreach ($e in $edu) {
        if ($e.title -and -not $e.title.es -and -not $e.title.en -and -not ($e.title -is [string])) { $issues += "campo title no estríng" }
        if ($e.institution -and -not $e.institution.es -and -not $e.institution.en -and -not ($e.institution -is [string])) { $issues += "institution no bilingüe" }
    }
    if ($issues.Count -eq 0) { Pass "education.json: $($edu.Count) entries, correct format" }
    else { Warn "Possible issues in education.json: $($issues -join ', ')" "Check bilingual format" }
} else { Warn "education.json empty or not found" "No education data" }

# ─── CHECK 10-11: projects.json ───
Title "projects.json"
$projects = Get-JsonSafe "$dataDir\projects.json"
if ($projects -and $projects.Count -gt 0) {
    $issues = @()
    foreach ($p in $projects) {
        if (-not $p.title) { $issues += "proyecto sin title" }
        if (-not $p.description.es -or -not $p.description.en) { $issues += "$($p.title) — description no bilingüe" }
        if ($p.links -and $p.links.Count -gt 0) {
            foreach ($l in $p.links) {
                if (-not $l.url -or -not $l.text) { $issues += "$($p.title) — link sin url o text" }
                $t = $l.text
                if ($t -and -not $t.es -and -not $t.en -and -not ($t -is [string])) { $issues += "$($p.title) — link text no estríng" }
            }
        }
    }
    if ($issues.Count -eq 0) { Pass "projects.json: $($projects.Count) projects, correct format" }
    else { Warn "Issues in projects.json: $($issues -join '; ')" "Check format" }
} else { Warn "projects.json empty" "No projects" }

# ─── CHECK 12: certificates.json — sin url, formato bilingüe ───
Title "certificates.json"
$certs = Get-JsonSafe "$dataDir\certificates.json"
if ($certs -and $certs.Count -gt 0) {
    $issues = @()
    foreach ($c in $certs) {
        if ($c.url) { $issues += "$($c.title) — TIENE campo url (prohibido)" }
        if (-not $c.title.es -or -not $c.title.en) { $issues += "title no bilingüe" }
        if (-not $c.institution.es -or -not $c.institution.en) { $issues += "$($c.title) — institution no bilingüe" }
        if (-not $c.date) { $issues += "$($c.title) — sin date" }
    }
    if ($issues.Count -eq 0) { Pass "certificates.json: $($certs.Count) certificates, no url field, correct format" }
    else { Fail "Issues in certificates.json: $($issues -join '; ')" "Remove url field if present, add missing fields" }
} else { Warn "certificates.json empty" "No certificates" }

# ─── CHECK 13: experience.json ───
Title "experience.json"
$exp = Get-JsonSafe "$dataDir\experience.json"
if ($exp -and $exp.Count -gt 0) {
    $issues = @()
    foreach ($e in $exp) {
        if (-not $e.title.es -or -not $e.title.en) { $issues += "title no bilingüe" }
        if (-not $e.company.es -or -not $e.company.en) { $issues += "$($e.title) — company no bilingüe" }
    }
    if ($issues.Count -eq 0) { Pass "experience.json: $($exp.Count) entries, correct format" }
    else { Warn "Issues in experience.json: $($issues -join '; ')" "Check bilingual format" }
} else { Warn "experience.json empty" "No experience" }

# ─── SUMMARY ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  JSON SCHEMA SUMMARY" -ForegroundColor Cyan
Write-Host "  PASS: $($passes.Count)   FAIL: $($failures.Count)   WARN: $($warnings.Count)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

if ($failures.Count -gt 0 -or $warnings.Count -gt 0) {
    Write-Host "`n── ACTION PLAN ──" -ForegroundColor Cyan
    foreach ($f in $failures) {
        Write-Host "`n[FAIL]" -ForegroundColor Red -NoNewline; Write-Host " $($f.message)"
        Write-Host "  -> $($f.plan)" -ForegroundColor White
    }
    foreach ($w in $warnings) {
        Write-Host "`n[WARN]" -ForegroundColor Yellow -NoNewline; Write-Host " $($w.message)"
        Write-Host "  -> $($w.plan)" -ForegroundColor White
    }
}

if ($failures.Count -gt 0) { exit 1 }
