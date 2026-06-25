# .agents/tests/check-js-logic.ps1
# Test de lógica JavaScript cliente
# Ejecutar: pwsh .agents/tests/check-js-logic.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$js = "$root\src\scripts\client.js"
$components = Get-ChildItem "$root\src\components" -Filter *.astro
$jsContent = Get-Content $js -Raw
$jsLines = Get-Content $js

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

# ─── CHECK 1: getElementById sin null guard ───
Title "Null safety"
$getElemById = [regex]::Matches($jsContent, 'document\.getElementById\([^)]+\)')
$unguarded = @()
foreach ($match in $getElemById) {
    $idx = $match.Index
    $after = $jsContent.Substring($idx + $match.Length, [Math]::Min(60, $jsContent.Length - $idx - $match.Length))
    if ($after -match '^\s*\.' -and -not $after -match '^\s*\.\s*$') {
        $lineNum = ($jsContent.Substring(0, $idx).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
        $unguarded += "  Línea $lineNum"
    }
}
if ($unguarded.Count -eq 0) { Pass "getElementById siempre con null guard" }
else {
    $msg = "getElementById sin null guard en $($unguarded.Count) sitio(s):`n$($unguarded -join "`n")"
    Fail $msg "Añadir null guard: const btn = document.getElementById(...); if (btn) btn.classList.add(...)"
}

# ─── CHECK 2: changeLanguage sin early return ───
if ($jsContent -match 'function\s+changeLanguage\s*\(') {
    $funcStart = $jsContent.IndexOf('function changeLanguage')
    $funcEnd = $jsContent.IndexOf('function', $funcStart + 1)
    if ($funcEnd -eq -1) { $funcEnd = $jsContent.Length }
    $funcBody = $jsContent.Substring($funcStart, $funcEnd - $funcStart)
    if ($funcBody -match 'if\s*\(\s*lang\s*===\s*currentLang\s*\)') {
        Pass "changeLanguage tiene early return si mismo idioma"
    } else {
        Warn "changeLanguage no tiene early return" "Añadir: if (lang === currentLang) return;"
    }
} else { Warn "No se encuentra función changeLanguage" "Verificar que existe" }

# ─── CHECK 3: target=_blank sin rel=noopener en JS ───
Title "Seguridad en enlaces"
$blankWithoutNoopener = @()
$blankPattern = [regex]::Match($jsContent, '(?s)target\s*=\s*["'']_blank["'']')
if ($blankPattern.Success) {
    $blankStart = $blankPattern.Index
    $contextStart = [Math]::Max(0, $blankStart - 200)
    $context = $jsContent.Substring($contextStart, [Math]::Min(400, $jsContent.Length - $contextStart))
    if ($context -notmatch 'rel\s*=\s*["'']noopener') {
        $blankWithoutNoopener += "  client.js: líneas alrededor de getElementById/setInnerHTML"
    }
}
# Buscar en componentes
foreach ($f in $components) {
    $content = Get-Content $f.FullName -Raw
    $hrefPattern = 'href="https?://[^"]*"'
    $hrefs = [regex]::Matches($content, $hrefPattern)
    foreach ($h in $hrefs) {
        $startIdx = [Math]::Max(0, $h.Index - 100)
        $context = $content.Substring($startIdx, [Math]::Min(300, $content.Length - $startIdx))
        if ($context -match 'target\s*=\s*["'']_blank["'']' -and $context -notmatch 'rel\s*=\s*["'']noopener') {
            $lineNum = ($content.Substring(0, $h.Index).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
            $blankWithoutNoopener += "  $($f.Name): línea ~$lineNum"
            break
        }
    }
}
if ($blankWithoutNoopener.Count -eq 0) { Pass "Todos los target=_blank tienen rel=noopener" }
else {
    $msg = "target=_blank sin rel=noopener:`n$($blankWithoutNoopener -join "`n")"
    Warn $msg "Añadir rel='noopener noreferrer' a todos los enlaces externos"
}

# ─── CHECK 4: btn-primary referenciado pero sin CSS ───
Title "Clases CSS referenciadas"
$cssFile = "$root\src\styles\global.css"
$cssContent = Get-Content $cssFile -Raw
$btnPrimaryInJS = $jsContent -match 'btn-primary'
$btnPrimaryInAstro = (Select-String -Path "$root\src\components\*.astro" -Pattern 'btn-primary').Count
$btnPrimaryInCSS = $cssContent -match '\.btn-primary'
if (($btnPrimaryInJS -or $btnPrimaryInAstro -gt 0) -and -not $btnPrimaryInCSS) {
    $refs = @()
    if ($btnPrimaryInJS) { $refs += "client.js" }
    if ($btnPrimaryInAstro -gt 0) { $refs += "$btnPrimaryInAstro componente(s) Astro" }
    Warn "btn-primary usado en $($refs -join ', ') pero NO definido en CSS" "Definir .btn-primary en global.css o eliminar la clase"
} elseif ($btnPrimaryInCSS) { Pass "btn-primary definido en CSS" }
else { Pass "btn-primary no referenciado — no aplica" }

# ─── CHECK 5: window.* globals no declaradas ───
Title "Variables globales"
$windowRefs = [regex]::Matches($jsContent, 'window\.\w+')
$problematicGlobals = @()
foreach ($wr in $windowRefs) {
    $name = $wr.Value
    if ($name -match 'window\.(DATA|changeLanguage|renderAll)') {
        $lineNum = ($jsContent.Substring(0, $wr.Index).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
        $problematicGlobals += "  Línea ${lineNum}: $name"
    }
}
if ($problematicGlobals.Count -eq 0) { Pass "Sin window.* globales problemáticas" }
else {
    $msg = "window.* encontrados:`n$($problematicGlobals -join "`n")"
    Fail $msg "Eliminar dependencia de window.* — datos van en data-data, eventos en addEventListener"
}

# ─── CHECK 6: init() llama a renderAll? ───
Title "Flujo de inicialización"
if ($jsContent -match 'function\s+init\s*\(') {
    $initBody = ""
    $idx = $jsContent.IndexOf('function init')
    $braceStart = $jsContent.IndexOf('{', $idx)
    $depth = 0
    for ($i = $braceStart; $i -lt $jsContent.Length; $i++) {
        if ($jsContent[$i] -eq '{') { $depth++ }
        elseif ($jsContent[$i] -eq '}') { $depth-- }
        if ($depth -le 0) { $initBody = $jsContent.Substring($braceStart, $i - $braceStart + 1); break }
    }
    if ($initBody -match 'renderAll') { Pass "init() llama a renderAll()" }
    else {
        Fail "init() NO llama a renderAll() — visitante con EN guardado ve secciones mixtas ES/EN" "Añadir renderAll() o changeLanguage(savedLang) al final de init()"
    }
} else { Fail "No se encuentra función init() en client.js" "Añadir init() como entry point" }

# ─── CHECK 7: Comillas/patrones inconsistentes ───
Title "Consistencia"
$singleQuotes = ($jsContent.ToCharArray() | Where-Object { $_ -eq "'" }).Count
$doubleQuotes = ($jsContent.ToCharArray() | Where-Object { $_ -eq '"' }).Count
if ($singleQuotes -gt $doubleQuotes * 1.5 -or $doubleQuotes -gt $singleQuotes * 1.5) {
    $dominant = if ($singleQuotes -gt $doubleQuotes) { "simples" } else { "dobles" }
    Warn "Predominan comillas $dominant ($singleQuotes simples vs $doubleQuotes dobles)" "Unificar estilo de comillas si es posible"
} else { Pass "Uso equilibrado de comillas ($singleQuotes simples, $doubleQuotes dobles)" }

# ─── RESUMEN ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESUMEN JS LOGIC" -ForegroundColor Cyan
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
