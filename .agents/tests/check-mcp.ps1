# .agents/tests/check-mcp.ps1
# Astro 5 best practices (MCP) compliance test
# Run: pwsh .agents/tests/check-mcp.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$src = "$root\src"

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

# ─── CHECK 1: onclick ───
Title "Inline events"
$astroFiles = Get-ChildItem -Path "$src\components" -Filter *.astro
$onclickCount = 0
$onclickFiles = @()
foreach ($f in $astroFiles) {
    $m = Select-String -Path $f.FullName -Pattern 'onclick=' -SimpleMatch
    if ($m) { $onclickCount += $m.Count; $onclickFiles += $f.Name }
}
if ($onclickCount -eq 0) { Pass "No onclick= en .astro — 0 ocurrencias" }
else { Fail "onclick= encontrado en $($onclickFiles -join ', ') ($onclickCount ocurrencias)" "Migrar a data-lang + addEventListener" }

# ─── CHECK 2: is:inline set:html en <script> ───
$inlineScriptCount = 0
$inlineScriptFiles = @()
foreach ($f in (Get-ChildItem -Path "$src\components" -Filter *.astro)) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match '<script[^>]*set:html') {
        $inlineScriptCount++
        $inlineScriptFiles += $f.Name
    }
}
if ($inlineScriptCount -eq 0) { Pass "No <script set:html> — 0 ocurrencias" }
else { Fail "<script set:html> en $($inlineScriptFiles -join ', ')" "Usar data-data en <body> en lugar de script inline" }

# ─── CHECK 3: window globals ───
$windowDATA = (Select-String -Path "$src\scripts\client.js" -Pattern 'window\.(DATA|changeLanguage)' -SimpleMatch).Count
if ($windowDATA -eq 0) { Pass "No window.DATA ni window.changeLanguage — 0 ocurrencias" }
else { Fail "window.DATA o window.changeLanguage encontrados" "Mover datos a data-data y eventos a addEventListener" }

# ─── CHECK 4: Astro.serialize ───
$astroSer = (Select-String -Path "$src\layouts\*.astro" -Pattern 'Astro\.serialize' -SimpleMatch).Count
if ($astroSer -eq 0) { Pass "No Astro.serialize() — usa JSON.stringify" }
else { Fail "Astro.serialize() encontrado" "Reemplazar por JSON.stringify()" }

# ─── CHECK 5: data-data on <body> ───
Title "MCP Structure"
$baseLayout = Get-Content "$src\layouts\BaseLayout.astro" -Raw
if ($baseLayout -match 'data-data=') { Pass "data-data en <body> en BaseLayout.astro" }
else { Fail "data-data NO encontrado en BaseLayout.astro" "Añadir data-data={dataBundle} al <body>" }

# ─── CHECK 6: body cierra bien ───
if ($baseLayout -match '<body[^>]*data-data=.*?>') { Pass "Tag <body> completo con data-data" }
else { Warn "No se pudo verificar sintaxis de <body>" "Revisar BaseLayout.astro manualmente" }

# ─── CHECK 7: tsconfig.json ───
$tsconfig = Test-Path "$root\tsconfig.json" -PathType Leaf
if ($tsconfig) {
    $tsc = Get-Content "$root\tsconfig.json" -Raw
    if ($tsc -match 'astro/tsconfigs/base') { Pass "tsconfig.json existe y extiende astro/tsconfigs/base" }
    else { Fail "tsconfig.json no extiende astro/tsconfigs/base" "Añadir 'extends': 'astro/tsconfigs/base'" }
} else { Fail "tsconfig.json NO encontrado" "Crear tsconfig.json con extends astro/tsconfigs/base" }

# ─── CHECK 8: addEventListener ───
Title "Client JavaScript"
$clientJs = Get-Content "$src\scripts\client.js" -Raw
if ($clientJs -match "querySelectorAll\('\[data-lang\]'\)") { Pass "client.js usa addEventListener con [data-lang]" }
else { Fail "client.js NO usa addEventListener con [data-lang]" "Migrar onclick a addEventListener" }

# ─── CHECK 9: data fetch pattern ───
if ($clientJs -match 'document\.body\.dataset\.data') { Pass "client.js lee datos desde data-data" }
else { Fail "client.js NO usa document.body.dataset.data" "Leer datos de document.body.dataset.data" }

# ─── CHECK 10: LangSwitcher (en Nav.astro) ───
$nav = Get-Content "$src\components\Nav.astro" -Raw
if ($nav -match 'data-lang=' -and $nav -notmatch 'onclick=') { Pass "Nav.astro incluye lang-switcher con data-lang (sin onclick)" }
else { Fail "Nav.astro sin data-lang o con onclick" "Incluir botones ES/EN con data-lang en Nav.astro" }

# ─── CHECK 11: set:html on HTML elements ───
Title "Astro Directives"
$setHtmlCount = (Select-String -Path "$src\components\*.astro" -Pattern 'set:html=' -SimpleMatch).Count
if ($setHtmlCount -gt 0) { Pass "set:html usado correctamente en $setHtmlCount elementos HTML" }
else { Warn "No se usa set:html — podría ser normal si todo es data-i18n" "Verificar que contenido dinámico funciona" }

# ─── CHECK 12: data-i18n attributes ───
$i18nCount = (Select-String -Path "$src\components\*.astro" -Pattern 'data-i18n=' -SimpleMatch).Count
if ($i18nCount -gt 0) { Pass "data-i18n presente en $i18nCount elementos — i18n funcionando" }
else { Warn "No hay data-i18n — traducción estática?" "Verificar sistema de traducción" }

# ─── CHECK 13: skills-lock.json ───
$lockFile = Test-Path "$root\.agents\skills-lock.json" -PathType Leaf
if ($lockFile) { Pass "skills-lock.json existe en .agents/" }
else { Warn "skills-lock.json NO encontrado en .agents/" "Ejecutar skill tool o crear manualmente skills-lock.json" }

# ─── CHECK 14: .agents/skills/ existe ───
$skillsDir = Test-Path "$root\.agents\skills" -PathType Container
if ($skillsDir) { Pass ".agents/skills/ existe" }
else { Warn ".agents/skills/ NO encontrado" "Crear .agents/skills/ con skill frontend-design" }

# ─── CHECK 15: No importaciones obsoletas ───
if ($clientJs -match 'import\s') {
    $imports = [regex]::Matches($clientJs, 'import\s+[^;]+;').Value
    Warn "client.js tiene declaraciones import ($imports)" "Verificar que funcionan con Astro bundler"
} else { Pass "client.js no tiene imports — módulo plano" }

# ─── CHECK 16: Script bundled correctly ───
$baseLayoutLines = Get-Content "$src\layouts\BaseLayout.astro"
$scriptSrc = $baseLayoutLines | Where-Object { $_ -match '<script\s+src=' }
if ($scriptSrc) { Pass "Script incluido como src (Astro bundle)" }
else { Fail "Script no encontrado como src en BaseLayout" "Añadir <script src='.../client.js'></script>" }

# ─── SUMMARY ───
Write-Host "`n═══════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  MCP SUMMARY" -ForegroundColor Cyan
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
