# .agents/tests/check-frontend-design.ps1
# Frontend-design skill compliance test
# Run: pwsh .agents/tests/check-frontend-design.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$css = "$root\src\styles\global.css"
$js = "$root\src\scripts\client.js"
$lang = "$root\src\data\lang.json"

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

$cssContent = Get-Content $css -Raw
$cssLines = Get-Content $css
$jsContent = Get-Content $js -Raw
$langContent = Get-Content $lang -Raw | ConvertFrom-Json

# ─── CHECK 1: :root define variables esenciales ───
Title "Design Tokens"
$requiredVars = @(
    '--color-bg', '--color-bg-card', '--color-bg-hover', '--color-border',
    '--color-text', '--color-text-bright', '--color-text-muted',
    '--color-accent', '--color-green',
    '--font-display', '--font-body'
)
$missingVars = @()
foreach ($v in $requiredVars) {
    if ($cssContent -notmatch [regex]::Escape($v)) { $missingVars += $v }
}
if ($missingVars.Count -eq 0) { Pass "Las $($requiredVars.Count) variables esenciales están definidas en :root" }
else { Fail "Faltan variables en :root: $($missingVars -join ', ')" "Añadir las variables faltantes con valores reales" }

# ─── CHECK 2: Sin variables auto-referenciales (circular) ───
$circularRefs = @()
foreach ($v in $requiredVars) {
    $pattern = [regex]::Escape("$($v): var($($v))")
    if ($cssContent -match $pattern) {
        $line = ($cssLines | Select-String -Pattern $pattern).LineNumber
        $circularRefs += "$($v) (line $line)"
    }
}
if ($circularRefs.Count -eq 0) { Pass "Sin variables auto-referenciales (circular ref)" }
else { Fail "Variables circulares detectadas: $($circularRefs -join '; ')" "Reemplazar var(x) por valor real, ej: --color-bg: #0d1117" }

# ─── CHECK 3: !important solo dentro de prefers-reduced-motion ───
Title "!important & accessibility"
$inMotionBlock = $false
$motionDepth = 0
$outsideImportant = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    $line = $cssLines[$i]
    if ($line -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') { $inMotionBlock = $true; $motionDepth = 0 }
    if ($inMotionBlock) {
        $motionDepth += ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $motionDepth -= ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        if ($motionDepth -le 0) { $inMotionBlock = $false; continue }
    }
    if ($line -match '!important' -and -not $inMotionBlock) {
        $outsideImportant += "  Line $($i+1): $($line.Trim())"
    }
}
if ($outsideImportant.Count -eq 0) { Pass "!important solo dentro de prefers-reduced-motion (WCAG)" }
else {
    $msg = "!important fuera del bloque prefers-reduced-motion:`n" + ($outsideImportant -join "`n")
    Fail $msg "Reemplazar !important por especificidad natural"
}

# ─── CHECK 4: prefers-reduced-motion en CSS ───
if ($cssContent -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') { Pass "@media (prefers-reduced-motion: reduce) existe en CSS" }
else { Fail "Falta @media (prefers-reduced-motion: reduce) en CSS" "Añadir bloque de accesibilidad con * { transition-duration: 0.01ms !important; }" }

# ─── CHECK 5: prefers-reduced-motion en JS ───
if ($jsContent -match 'matchMedia\(.*prefers-reduced-motion.*reduce') { Pass "prefers-reduced-motion también manejado en JS (motionOK)" }
else { Fail "Falta detección de prefers-reduced-motion en JS" "Añadir const motionOK = !window.matchMedia('...').matches" }

# ─── CHECK 6: .reveal reset en prefers-reduced-motion ───
$motionLines = @()
$inMotionBlock = $false
$motionDepth = 0
foreach ($line in $cssLines) {
    if ($line -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') {
        $inMotionBlock = $true
        $motionDepth = 0
        $motionLines = @()
    }
    if ($inMotionBlock) {
        $motionLines += $line
        $motionDepth += ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $motionDepth -= ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        if ($motionDepth -le 0) { break }
    }
}
$motionBlockText = $motionLines -join "`n"
if ($motionBlockText -match '\.reveal\s*\{') { Pass ".reveal tiene reset en prefers-reduced-motion" }
else { Fail "Falta reset de .reveal en prefers-reduced-motion" "Añadir .reveal { opacity: 1; transform: none; transition: none; }" }

# ─── CHECK 7: JS scroll reveal condicional ───
if ($jsContent -match 'motionOK') { Pass "Scroll reveal condicional con motionOK" }
else { Fail "Falta variable motionOK en client.js" "Añadir const motionOK = !window.matchMedia(...).matches" }
if ($jsContent -match 'if\s*\(motionOK\)') { Pass "Scroll reveal se salta si reduced-motion activo" }
else { Fail "Falta if (motionOK) en event listener" "Envolver window.addEventListener('scroll', reveal) en if (motionOK)" }

# ─── CHECK 8: Media queries responsive ───
Title "Responsive"
$media650 = (Select-String -InputObject $cssContent -Pattern '@media\s*\(max-width:\s*650px\)' -AllMatches).Matches.Count
if ($media650 -ge 1) { Pass "@media (max-width: 650px) presente ($media650 bloques)" }
else { Fail "Falta @media (max-width: 650px)" "Añadir punto de quiebre responsive" }

$media480 = (Select-String -InputObject $cssContent -Pattern '@media\s*\(max-width:\s*480px\)' -AllMatches).Matches.Count
if ($media480 -ge 1) { Pass "@media (max-width: 480px) existe" }
else { Warn "Falta @media (max-width: 480px)" "Considerar añadir para móviles muy pequeños" }

# ─── CHECK 9: font-display en headings ───
Title "Tipografía"
$missingDisplay = @()
$h2Section = $cssContent -match '(?s)h2\s*\{[^}]*--font-display[^}]*\}'
$profileH1 = $cssContent -match '(?s)\.profile-text h1\s*\{[^}]*--font-display[^}]*\}'
$skillItem = $cssContent -match '(?s)\.skill-item strong\s*\{[^}]*--font-display[^}]*\}'
$eduHeader = $cssContent -match '(?s)\.edu-header strong\s*\{[^}]*--font-display[^}]*\}'

$fontDisplayOk = 0
if ($h2Section) { $fontDisplayOk++ } else { $missingDisplay += "h2" }
if ($profileH1) { $fontDisplayOk++ } else { $missingDisplay += ".profile-text h1" }
if ($skillItem) { $fontDisplayOk++ } else { $missingDisplay += ".skill-item strong" }
if ($eduHeader) { $fontDisplayOk++ } else { $missingDisplay += ".edu-header strong" }

if ($missingDisplay.Count -eq 0) { Pass "--font-display en los 4 selectores de heading" }
else { Warn "Falta --font-display en: $($missingDisplay -join ', ')" "Aplicar font-family: var(--font-display)" }

if ($cssContent -match 'body\s*\{[^}]*--font-body') { Pass "--font-body aplicado en body" }
else { Fail "Falta --font-body en body" "Aplicar font-family: var(--font-body)" }

# ─── CHECK 10: Sin #58a6ff (antiguo acento) ───
Title "Paleta de colores"
$oldAccent = (Select-String -Path $css -Pattern '#58a6ff' -SimpleMatch).Count
if ($oldAccent -eq 0) { Pass "No queda #58a6ff (migrado a #7fc1fe)" }
else { Warn "#58a6ff encontrado ($oldAccent ocurrencias)" "Migrar a var(--color-accent) (#7fc1fe)" }

# ─── CHECK 11: Hardcoded #ffffff fuera de badge classes ───
$whiteLines = @()
$badgeWhiteLines = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    $line = $cssLines[$i]
    if ($line -match 'color:\s*#ffffff') {
        $trimmed = $line.Trim()
        if ($trimmed -match '\.(b-|tools-badges|badge)') { $badgeWhiteLines += "  Line $($i+1): $trimmed" }
        else { $whiteLines += "  Line $($i+1): $trimmed" }
    }
}
if ($whiteLines.Count -eq 0) { Pass "Sin #ffffff hardcodeado fuera de badges" }
else {
    $msg = "#ffffff hardcodeado en $($whiteLines.Count) sitios fuera de badges:`n" + ($whiteLines -join "`n")
    Warn $msg "Usar var(--color-text-bright) en lugar de #ffffff"
}

if ($badgeWhiteLines.Count -gt 0) {
    $msg = "#ffffff en badges ($($badgeWhiteLines.Count) sitios) — aceptable pero revisable:`n" + ($badgeWhiteLines -join "`n")
    Warn $msg "Considerar var(--color-text-bright) para consistencia"
}

# ─── CHECK 12: Hardcoded #1a1f26 ───
$hard1a1f26 = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) { if ($cssLines[$i] -match '#1a1f26') { $hard1a1f26 += "  Line $($i+1): $($cssLines[$i].Trim())" } }
if ($hard1a1f26.Count -gt 0) {
    $msg = "#1a1f26 hardcodeado:`n" + ($hard1a1f26 -join "`n")
    Warn $msg "Usar var(--color-bg-card) (#161b22) en su lugar"
} else { Pass "Sin #1a1f26 hardcodeado" }

# ─── CHECK 13: Brand colors en badges (intencionales) ───
$brandColors = @('#3776ab', '#e76f00', '#f7df1e', '#00758f', '#734f96', '#007acc', '#2c2255', '#1a6ac9', '#710900', '#10a37f')
$foundBrands = @()
foreach ($bc in $brandColors) {
    $escaped = [regex]::Escape($bc)
    $m = (Select-String -InputObject $cssContent -Pattern $escaped -AllMatches).Matches.Count
    if ($m -gt 0) { $foundBrands += "$bc ($m use(s))" }
}
if ($foundBrands.Count -gt 0) {
    Warn "Colores de marca en badges: $($foundBrands -join ', ') — intencionales pero no normalizables" "Los colores de badges son OK por diseño, pero revisar que ninguno sobreescriba variable del tema"
} else { Pass "Sin colores de marca en badges" }

# ─── CHECK 14: Cuadrícula computacional ───
Title "Firma visual"
if ($cssContent -match '(?s)#inicio.*background.*linear-gradient.*1px') { Pass "Cuadrícula computacional en #inicio (28px, 2%)" }
else { Warn "No se detecta cuadrícula computacional en #inicio" "Añadir grid con linear-gradient como background-image" }

if ($cssContent -match '#inicio::after' -and $cssContent -match 'linear-gradient\(180deg') { Pass "Gradiente de desvanecimiento en #inicio" }
else { Warn "Falta gradiente de desvanecimiento en #inicio::after" "Añadir linear-gradient(180deg, transparent 60%, var(--color-bg) 100%)" }

# ─── CHECK 15: Sin emojis en headings ───
Title "Contenido"
$emojiPattern = '[^\x00-\x7F\x80-\xFF\u00F1\u00D1\u00E1-\u00FA\u00C1-\u00DA\u00BF\u00A1\u00FC\u00DC]'
$hasEmoji = $false
$langObj = $langContent.es
$langObj.PSObject.Properties | Where-Object { $_.Name -like 'sec-*' -or $_.Name -like 'cv-*' } | ForEach-Object {
    if ($_.Value -match $emojiPattern) { $hasEmoji = $true; Warn "Emoji detectado en lang.json: $($_.Name) = '$($_.Value)'" "Eliminar emoji del heading" }
}
if (-not $hasEmoji) { Pass "Sin emojis en headings (lang.json)" }

# ─── CHECK 16: btn-outline usa custom properties ───
Title "Componentes"
$btnOutline = $cssContent -match '(?s)\.btn-outline\s*\{[^}]*\}'
$btnOutlineHover = $cssContent -match '(?s)\.btn-outline:hover\s*\{[^}]*\}'
if ($btnOutline) {
    $btnBlock = [regex]::Match($cssContent, '(?s)\.btn-outline\s*\{[^}]*\}').Value
    if ($btnBlock -match 'var\(--color-border\)' -and $btnBlock -match 'var\(--color-text-muted\)') { Pass ".btn-outline usa custom properties" }
    else { Warn ".btn-outline podría usar más custom properties" "Revisar colores en .btn-outline" }
} else { Warn "No se encuentra .btn-outline" "Verificar que existe el componente" }

# ─── CHECK 17: Nav sticky ───
if ($cssContent -match 'nav\s*\{[^}]*position:\s*sticky[^}]*backdrop-filter') { Pass "Nav sticky con backdrop-filter" }
else { Warn "Falta sticky o backdrop-filter en nav" "Añadir position: sticky + backdrop-filter para efecto vidrio" }

# ─── CHECK 18: Badges sin color redundante ───
$redundantLines = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    if ($cssLines[$i] -match 'color:\s*#ffffff' -and $cssLines[$i] -match 'background-color:') {
        $redundantLines += "  Line $($i+1): $($cssLines[$i].Trim())"
    }
}
if ($redundantLines.Count -gt 0) {
    $msg = "Color redundante (color + background-color hardcodeados):`n" + ($redundantLines -join "`n")
    Warn $msg "Revisar si el color es necesario o heredable"
} else { Pass "Sin colores redundantes" }

# ─── CHECK 19: Lang switcher flotante ───
if ($cssContent -match '\.lang-switcher\s*\{[^}]*position:\s*fixed') { Pass "LangSwitcher fixed (flotante)" }
else { Warn "LangSwitcher no es fixed" "Añadir position: fixed + top: 15px + right: 20px" }

# ─── CHECK 20: Back-to-top button ───
if ($cssContent -match '#back-to-top\s*\{[^}]*position:\s*fixed') { Pass "Botón back-to-top fixed" }
else { Warn "Falta botón back-to-top" "Añadir #back-to-top si no existe" }

# ─── SUMMARY ───
Write-Host "`n══════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  FRONTEND DESIGN SUMMARY" -ForegroundColor Cyan
Write-Host "  PASS: $($passes.Count)   FAIL: $($failures.Count)   WARN: $($warnings.Count)" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════" -ForegroundColor Cyan

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
