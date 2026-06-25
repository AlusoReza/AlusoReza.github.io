# .agents/tests/check-paths.ps1
# Test de integridad de rutas de archivos
# Ejecutar: pwsh .agents/tests/check-paths.ps1

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
Title "Archivos estáticos"
$cvPath = "$root\public\assets\Alonso_Reza_CV.pdf"
$cvExists = Test-Path $cvPath -PathType Leaf
$cvsFound = Get-ChildItem "$root\public" -Recurse -Filter "*CV*" -ErrorAction SilentlyContinue
if ($cvExists) { Pass "CV.pdf existe en public/assets/" }
else {
    $hint = ""
    if ($cvsFound) { $hint = " — pero se encontró en $($cvsFound.FullName)" }
    Fail "CV.pdf NO existe en public/assets/Alonso_Reza_CV.pdf$hint" "Añadir el archivo CV en public/assets/ o actualizar la ruta en profile.json y Contact.astro"
}

# ─── CHECK 2: perfil.jpg ───
$profileImg = "$root\public\assets\perfil.jpg"
if (Test-Path $profileImg -PathType Leaf) { Pass "perfil.jpg existe en public/assets/" }
else { Fail "perfil.jpg NO encontrado en public/assets/" "Añadir la foto de perfil en public/assets/perfil.jpg" }

# ─── CHECK 3: favicon ───
$favicon = "$root\public\assets\favicon.ico"
if (Test-Path $favicon -PathType Leaf) { Pass "favicon.ico existe en public/assets/" }
else { Warn "favicon.ico NO encontrado en public/assets/" "Añadir favicon o actualizar ruta en BaseLayout.astro" }

# ─── CHECK 4: docs/certificates/ tiene .gitkeep ───
Title "Certificados"
$gitkeep = "$root\docs\certificates\.gitkeep"
if (Test-Path $gitkeep -PathType Leaf) { Pass ".gitkeep existe en docs/certificates/" }
else { Warn ".gitkeep NO encontrado en docs/certificates/" "Añadir .gitkeep para mantener la carpeta trackeada" }

# ─── CHECK 5: Sin carpeta certificates/ en root ───
$oldCertDir = "$root\certificates"
if (Test-Path $oldCertDir -PathType Container) {
    $oldFiles = Get-ChildItem $oldCertDir -File
    Warn "Todavía existe la carpeta certificates/ en raíz con $($oldFiles.Count) archivo(s)" "Mover contenido a docs/certificates/ y eliminar la carpeta raíz"
} else { Pass "Sin carpeta certificates/ residual en raíz" }

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
    if ($trackedCount -eq 0) { Pass "$($certPdfs.Count) PDF(s) en docs/certificates/ — todos ignorados por git" }
    else { Warn "$trackedCount PDF(s) no están gitignorados" "Actualizar .gitignore para ignorar docs/certificates/*" }
} else { Pass "Sin PDFs en docs/certificates/ (o todos ignorados)" }

# ─── CHECK 7: Consistencia paths assets ───
Title "Consistencia de rutas"
$profileJson = Get-Content "$root\src\data\profile.json" -Raw
$contactAstro = Get-Content "$root\src\components\Contact.astro" -Raw
$baseLayout = Get-Content "$root\src\layouts\BaseLayout.astro" -Raw
$cvRelPaths = @()
if ($profileJson -match '"cvPath"\s*:\s*"([^"]+)"') {
    $cvPathStr = $matches[1]
    if ($cvPathStr -notmatch '^/') { $cvRelPaths += "profile.json: cvPath = '$cvPathStr' (relativo)" }
}
if ($contactAstro -match 'href="([^"]*CV[^"]*)"') {
    $href = $matches[1]
    if ($href -notmatch '^/') { $cvRelPaths += "Contact.astro: href = '$href' (relativo)" }
}
if ($baseLayout -match 'href="/assets/favicon') { $favAbs = $true }
if ($cvRelPaths.Count -gt 0) {
    Warn "Rutas relativas de CV (inconsistente con favicon absoluto):`n$($cvRelPaths -join "`n")" "Usar rutas absolutas /assets/... para consistencia"
} else { Pass "Todas las rutas de assets usan paths absolutos" }

# ─── RESUMEN ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESUMEN PATHS" -ForegroundColor Cyan
Write-Host "  PASS: $($passes.Count)   FAIL: $($failures.Count)   WARN: $($warnings.Count)" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

if ($failures.Count -gt 0 -or $warnings.Count -gt 0) {
    Write-Host "`n── PLAN DE ACCIÓN ──" -ForegroundColor Cyan
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
