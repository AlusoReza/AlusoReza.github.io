# .agents/tests/check-paths.ps1
# File path integrity test
# Run: pwsh .agents/tests/check-paths.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."

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

# ─── CHECK 1: CV PDF ───
Title "Static files"
$cvPath = "$root\public\assets\Alonso_Reza_CV.pdf"
$cvExists = Test-Path $cvPath -PathType Leaf
$cvsFound = Get-ChildItem "$root\public" -Recurse -Filter "*CV*" -ErrorAction SilentlyContinue
if ($cvExists) { Pass "CV.pdf exists in public/assets/" }
else {
    $hint = ""
    if ($cvsFound) { $hint = " — but found at $($cvsFound.FullName)" }
    Fail "CV.pdf NOT found in public/assets/Alonso_Reza_CV.pdf$hint" "Add CV file to public/assets/ or update path in profile.json and Contact.astro"
}

# ─── CHECK 2: perfil.jpg ───
$profileImg = "$root\public\assets\perfil.jpg"
if (Test-Path $profileImg -PathType Leaf) { Pass "perfil.jpg exists in public/assets/" }
else { Fail "perfil.jpg NOT found in public/assets/" "Add profile picture to public/assets/perfil.jpg" }

# ─── CHECK 3: favicon ───
$favicon = "$root\public\assets\favicon.ico"
if (Test-Path $favicon -PathType Leaf) { Pass "favicon.ico exists in public/assets/" }
else { Warn "favicon.ico NOT found in public/assets/" "Add favicon or update path in BaseLayout.astro" }

# ─── CHECK 4: docs/certificates/ has .gitkeep ───
Title "Certificates"
$gitkeep = "$root\docs\certificates\.gitkeep"
if (Test-Path $gitkeep -PathType Leaf) { Pass ".gitkeep exists in docs/certificates/" }
else { Warn ".gitkeep NOT found in docs/certificates/" "Add .gitkeep to keep the folder tracked" }

# ─── CHECK 5: No certificates/ folder in root ───
$oldCertDir = "$root\certificates"
if (Test-Path $oldCertDir -PathType Container) {
    $oldFiles = Get-ChildItem $oldCertDir -File
    Warn "Root certificates/ folder still exists with $($oldFiles.Count) file(s)" "Move contents to docs/certificates/ and delete root folder"
} else { Pass "No residual root certificates/ folder" }

# ─── CHECK 6: PDFs en docs/certificates/ (ignorados) ───
$certPdfs = Get-ChildItem "$root\docs\certificates" -Filter *.pdf -ErrorAction SilentlyContinue
if ($certPdfs.Count -gt 0) {
    $ignoredCount = 0
    $trackedCount = 0
    foreach ($pdf in $certPdfs) {
        $rel = "docs\certificates\$($pdf.Name)"
        $ignored = & git check-ignore $rel 2>$null
        if ($ignored) { $ignoredCount++ }
        else { $trackedCount++; Write-Host "  [WARN] $rel NO está gitignorado" -ForegroundColor Yellow }
    }
    if ($trackedCount -eq 0) { Pass "$($certPdfs.Count) PDF(s) in docs/certificates/ — all gitignored" }
    else { Warn "$trackedCount PDF(s) are NOT gitignored" "Update .gitignore to ignore docs/certificates/*" }
} else { Pass "No PDFs in docs/certificates/ (or all gitignored)" }

# ─── CHECK 7: Asset path consistency ───
Title "Path consistency"
$profileJson = Get-Content "$root\src\data\profile.json" -Raw
$contactAstro = Get-Content "$root\src\components\Contact.astro" -Raw
$baseLayout = Get-Content "$root\src\layouts\BaseLayout.astro" -Raw
$cvRelPaths = @()
if ($profileJson -match '"cvPath"\s*:\s*"([^"]+)"') {
    $cvPathStr = $matches[1]
    if ($cvPathStr -notmatch '^/') { $cvRelPaths += "profile.json: cvPath = '$cvPathStr' (relative)" }
}
if ($contactAstro -match 'href="([^"]*CV[^"]*)"') {
    $href = $matches[1]
    if ($href -notmatch '^/') { $cvRelPaths += "Contact.astro: href = '$href' (relative)" }
}
if ($baseLayout -match 'href="/assets/favicon') { $favAbs = $true }
if ($cvRelPaths.Count -gt 0) {
    Warn "Relative CV paths (inconsistent with absolute favicon):`n$($cvRelPaths -join "`n")" "Use absolute paths /assets/... for consistency"
} else { Pass "All asset paths use absolute paths" }

# ─── SUMMARY ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  PATHS SUMMARY" -ForegroundColor Cyan
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
