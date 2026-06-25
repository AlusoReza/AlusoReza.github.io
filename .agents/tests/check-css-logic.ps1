# .agents/tests/check-css-logic.ps1
# Test de lógica CSS
# Ejecutar: pwsh .agents/tests/check-css-logic.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$css = "$root\src\styles\global.css"
$cssContent = Get-Content $css -Raw
$cssLines = Get-Content $css

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

# ─── CHECK 1: #1a1f26 hardcodeado ───
Title "Colores hardcodeados"
$hard1a1f26 = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    if ($cssLines[$i] -match '#1a1f26') { $hard1a1f26 += "  Línea $($i+1): $($cssLines[$i].Trim())" }
}
if ($hard1a1f26.Count -gt 0) {
    $msg = "#1a1f26 hardcodeado en $($hard1a1f26.Count) sitio(s):`n$($hard1a1f26 -join "`n")"
    Warn $msg "Usar var(--color-bg-card) (#161b22) en su lugar"
} else { Pass "Sin #1a1f26 hardcodeado" }

# ─── CHECK 2: #ffffff residual (no badge) ───
$whiteResidual = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    if ($cssLines[$i] -match 'color:\s*#ffffff' -and $cssLines[$i] -notmatch '\.(b-|tools-badges|badge)') {
        $whiteResidual += "  Línea $($i+1): $($cssLines[$i].Trim())"
    }
}
if ($whiteResidual.Count -eq 0) { Pass "Sin #ffffff residual" }
else {
    $msg = "#ffffff fuera de badges:$($whiteResidual -join "`n")"
    Warn $msg "Usar var(--color-text-bright)"
}

# ─── CHECK 3: Clases usadas en componentes pero no en CSS ───
Title "Clases sin definir"
$allAstroContent = (Get-ChildItem "$root\src\components\*.astro" | Get-Content -Raw) -join "`n"
$clientJs = Get-Content "$root\src\scripts\client.js" -Raw
$allContent = $allAstroContent + "`n" + $clientJs
$classRefs = [regex]::Matches($allContent, 'class\s*=\s*["'']([^"''\s]+)')
$usedClasses = @{}
foreach ($cr in $classRefs) {
    $cls = $cr.Groups[1].Value
    $usedClasses[$cls] = $true
}
$cssClasses = [regex]::Matches($cssContent, '\.([\w-]+)\s*\{')
$definedClasses = @{}
foreach ($cc in $cssClasses) { $definedClasses[$cc.Groups[1].Value] = $true }
$undefined = @()
foreach ($uc in $usedClasses.Keys) {
    if (-not $definedClasses.ContainsKey($uc) -and $uc -notin @('btn-primary', 'badge', 'icon', 'tools-badge', 'language-badge', 'social-btn')) {
        if ($uc -notmatch '^(data-|reveal|active|social-btns|btn-outline|btn|contact-links|cv-cta|cv-cta-button)') {
            $undefined += $uc
        }
    }
}
# Check btn-primary specifically
$hasBtnPrimaryAstro = $allAstroContent -match 'btn-primary'
$hasBtnPrimaryJS = $clientJs -match 'btn-primary'
$hasBtnPrimaryCSS = $cssContent -match '\.btn-primary'
if (($hasBtnPrimaryAstro -or $hasBtnPrimaryJS) -and -not $hasBtnPrimaryCSS) {
    $undefined += "btn-primary (usado en HTML/JS pero sin CSS)"
}
if ($undefined.Count -eq 0) { Pass "Todas las clases referenciadas están definidas en CSS" }
else {
    Warn "Clases referenciadas pero sin CSS: $($undefined -join ', ')" "Definir las clases faltantes o eliminar referencias"
}

# ─── CHECK 4: !important fuera de reduced-motion ───
Title "!important"
$inMotionBlock = $false
$motionDepth = 0
$outsideImportant = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    $line = $cssLines[$i]
    if ($line -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') { $inMotionBlock = $true; $motionDepth = 0 }
    if ($inMotionBlock) {
        $motionDepth += ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $motionDepth -= ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        if ($motionDepth -le 0) { $inMotionBlock = $false }
    }
    if ($line -match '!important' -and -not $inMotionBlock) {
        $outsideImportant += "  Línea $($i+1): $($line.Trim())"
    }
}
if ($outsideImportant.Count -eq 0) { Pass "Sin !important fuera de reduced-motion" }
else { Warn "!important fuera del bloque:`n$($outsideImportant -join "`n")" "Reemplazar por especificidad natural" }

# ─── CHECK 5: Variables CSS definidas pero no usadas ───
Title "Variables CSS"
$definedVars = [regex]::Matches($cssContent, '(--[\w-]+)\s*:')
$usedVars = [regex]::Matches($cssContent, 'var\((--[\w-]+)\)')
$definedSet = @{}; $usedSet = @{}
foreach ($dv in $definedVars) { $definedSet[$dv.Groups[1].Value] = $true }
foreach ($uv in $usedVars) { $usedSet[$uv.Groups[1].Value] = $true }
$unused = @()
foreach ($dv in $definedSet.Keys) {
    if (-not $usedSet.ContainsKey($dv) -and $dv -notmatch '--font-(display|body)') {
        if (($usedSet.Keys | Where-Object { $_ -eq $dv }).Count -eq 0) { $unused += $dv }
    }
}
# Revisar también en componentes Astro y client.js
foreach ($dv in $definedSet.Keys) {
    $inAstro = $allAstroContent -match [regex]::Escape($dv) -or $clientJs -match [regex]::Escape($dv)
    if (-not $inAstro -and -not $usedSet.ContainsKey($dv) -and $dv -notin @('--color-green', '--font-display', '--font-body')) {
        $unused += "$dv"
    }
}
$unused = $unused | Select-Object -Unique | Where-Object { $_ -ne "" }
if ($unused.Count -eq 0) { Pass "Todas las variables CSS se usan" }
else { Warn "Variables CSS definidas pero quizás no usadas: $($unused -join ', ')" "Revisar si son necesarias" }

# ─── RESUMEN ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESUMEN CSS LOGIC" -ForegroundColor Cyan
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
