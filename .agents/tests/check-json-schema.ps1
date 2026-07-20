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
    Write-Host "`n-- $t --" -ForegroundColor Cyan
}
function Get-JsonSafe($path) {
    try { return Get-Content $path -Raw | ConvertFrom-Json } catch { return $null }
}

# --- CHECK 1-3: lang data (nav.json + sections.json + about.json) ---
Title "lang data (nav + sections + about)"
$nav = Get-JsonSafe "$dataDir\nav.json"
$sections = Get-JsonSafe "$dataDir\sections.json"
$about = Get-JsonSafe "$dataDir\about.json"
if ($nav -and $sections -and $about) {
    $allKeys = @()
    $nav.es.PSObject.Properties | ForEach-Object { $allKeys += $_.Name }
    $sections.es.PSObject.Properties | ForEach-Object { $allKeys += $_.Name }
    $about.es.PSObject.Properties | ForEach-Object { $allKeys += $_.Name }
    $missingEs = $allKeys | Where-Object { -not $nav.es.$_ -and -not $sections.es.$_ -and -not $about.es.$_ }
    $missingEn = $allKeys | Where-Object { -not $nav.en.$_ -and -not $sections.en.$_ -and -not $about.en.$_ }
    if ($missingEs.Count -eq 0 -and $missingEn.Count -eq 0) { Pass "nav.json + sections.json + about.json have all required keys in ES and EN" }
    else {
        if ($missingEs.Count -gt 0) { Warn "Missing keys in ES: $($missingEs -join ', ')" "Add missing keys" }
        if ($missingEn.Count -gt 0) { Warn "Missing keys in EN: $($missingEn -join ', ')" "Add missing keys" }
    }
} else { Fail "nav.json, sections.json, or about.json not found" "Verify src/data/ files exist" }

# --- CHECK 4-5: profile.json ---
Title "profile.json"
$profile = Get-JsonSafe "$dataDir\profile.json"
if ($profile) {
    $missing = @()
    if (-not $profile.firstName) { $missing += "firstName" }
    if (-not $profile.lastName) { $missing += "lastName" }
    if (-not $profile.cvPath) { $missing += "cvPath" }
    if ($missing.Count -eq 0) { Pass "profile.json complete (firstName, lastName, cvPath)" }
    else { Fail "profile.json incomplete: $($missing -join ', ')" "Add required fields" }
} else { Fail "profile.json not found" "Check src/data/profile.json" }

# --- CHECK 6-7: skills.json ---
Title "skills.json"
$skills = Get-JsonSafe "$dataDir\skills.json"
if ($skills) {
    $allSkills = @()
    if ($skills.personality) { $allSkills += $skills.personality }
    if ($skills.technical) { $allSkills += $skills.technical }
    if ($allSkills.Count -gt 0) {
        $bilingualIssues = @()
        foreach ($s in $allSkills) {
            if (-not $s.title.es -or -not $s.title.en) { $bilingualIssues += "title not bilingual" }
            if (-not $s.description.es -or -not $s.description.en) { $bilingualIssues += "description not bilingual" }
        }
        if ($bilingualIssues.Count -eq 0) { Pass "skills.json: $($allSkills.Count) skills, all bilingual" }
        else { Warn "skills.json bilingual issues: $($bilingualIssues -join ', ')" "Use {es, en} format" }
    } else { Warn "skills.json empty (no personality or technical arrays)" "Verify skills data exists" }
} else { Warn "skills.json not found" "Check src/data/skills.json" }

# --- CHECK 8-9: education.json ---
Title "education.json"
$edu = Get-JsonSafe "$dataDir\education.json"
if ($edu -and $edu.Count -gt 0) {
    $issues = @()
    foreach ($e in $edu) {
        if ($e.title -and -not $e.title.es -and -not $e.title.en -and -not ($e.title -is [string])) { $issues += "field title not string" }
        if ($e.institution -and -not $e.institution.es -and -not $e.institution.en -and -not ($e.institution -is [string])) { $issues += "institution not bilingual" }
    }
    if ($issues.Count -eq 0) { Pass "education.json: $($edu.Count) entries, correct format" }
    else { Warn "Possible issues in education.json: $($issues -join ', ')" "Check bilingual format" }
} else { Warn "education.json empty or not found" "No education data" }

# --- CHECK 10-11: projects.json ---
Title "projects.json"
$projects = Get-JsonSafe "$dataDir\projects.json"
if ($projects -and $projects.Count -gt 0) {
    $issues = @()
    foreach ($p in $projects) {
        if (-not $p.title) { $issues += "project without title" }
        if (-not $p.description.es -or -not $p.description.en) { $issues += "$($p.title) -- description not bilingual" }
        if ($p.links -and $p.links.Count -gt 0) {
            foreach ($l in $p.links) {
                if (-not $l.url -or -not $l.text) { $issues += "$($p.title) -- link without url or text" }
                $t = $l.text
                if ($t -and -not $t.es -and -not $t.en -and -not ($t -is [string])) { $issues += "$($p.title) -- link text not string" }
            }
        }
    }
    if ($issues.Count -eq 0) { Pass "projects.json: $($projects.Count) projects, correct format" }
    else { Warn "Issues in projects.json: $($issues -join '; ')" "Check format" }
} else { Warn "projects.json empty" "No projects" }

# --- CHECK 12: certificates.json -- no url, bilingual format ---
Title "certificates.json"
$certs = Get-JsonSafe "$dataDir\certificates.json"
if ($certs -and $certs.Count -gt 0) {
    $issues = @()
    foreach ($c in $certs) {
        if ($c.url) { $issues += "$($c.title) -- HAS url field (forbidden)" }
        if (-not $c.title.es -or -not $c.title.en) { $issues += "title not bilingual" }
        if (-not $c.institution.es -or -not $c.institution.en) { $issues += "$($c.title) -- institution not bilingual" }
        if (-not $c.date) { $issues += "$($c.title) -- no date" }
    }
    if ($issues.Count -eq 0) { Pass "certificates.json: $($certs.Count) certificates, no url field, correct format" }
    else { Fail "Issues in certificates.json: $($issues -join '; ')" "Remove url field if present, add missing fields" }
} else { Warn "certificates.json empty" "No certificates" }

# --- CHECK 13: experience.json ---
Title "experience.json"
$exp = Get-JsonSafe "$dataDir\experience.json"
if ($exp -and $exp.Count -gt 0) {
    $issues = @()
    foreach ($e in $exp) {
        if (-not $e.title.es -or -not $e.title.en) { $issues += "title not bilingual" }
        if (-not $e.company.es -or -not $e.company.en) { $issues += "$($e.title) -- company not bilingual" }
    }
    if ($issues.Count -eq 0) { Pass "experience.json: $($exp.Count) entries, correct format" }
    else { Warn "Issues in experience.json: $($issues -join '; ')" "Check bilingual format" }
} else { Warn "experience.json empty" "No experience" }

# --- SUMMARY ---
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  JSON SCHEMA SUMMARY" -ForegroundColor Cyan
Write-Host "  PASS: $($passes.Count)   FAIL: $($failures.Count)   WARN: $($warnings.Count)" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

if ($failures.Count -gt 0 -or $warnings.Count -gt 0) {
    Write-Host "`n-- ACTION PLAN --" -ForegroundColor Cyan
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
