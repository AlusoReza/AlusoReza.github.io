# .agents/tests/run-all.ps1
# Master runner: ejecuta todos los tests y guarda hallazgos en bugs.md
# Ejecutar: pwsh .agents/tests/run-all.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$testsDir = "$PSScriptRoot"
$bugsFile = "$root\spec\constitution\bugs.md"

$allOutput = @()
$global:allFails = @()
$global:allWarns = @()
$global:manualItems = @(
    @{ check = "Flujo init() — lógica profunda"; desc = "init() llama a translateUI() pero no a renderAll(). Visitante con EN guardado ve secciones mixtas." },
    @{ check = "Icono 📄 en Contact.astro"; desc = "El icono está DENTRO del span data-i18n. translateUI() lo borra al cambiar idioma." },
    @{ check = "Arquitectura de datos"; desc = "Verificar que data-data → JSON.parse → renderAll() funciona sin errores de consola." },
    @{ check = "Regresión de bugs conocidos"; desc = "Revisar spec/constitution/bugs.md — los bugs marcados como ✅ Arreglado deben seguir arreglados." }
)

function Title($t) {
    Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "  $t" -ForegroundColor Magenta
    Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
}

function Run-Test($name, $script) {
    $path = "$testsDir\$script"
    if (-not (Test-Path $path)) {
        Write-Host "`n  [SKIP] $script — no encontrado" -ForegroundColor DarkGray
        return @()
    }
    Write-Host "`n  >>> Ejecutando $script..." -ForegroundColor Cyan
    $output = & pwsh -NoProfile -File $path 2>&1
    $output | ForEach-Object { Write-Host $_ }
    
    # Capturar FAILs y WARNs para bugs.md
    foreach ($line in $output) {
        $text = "$line"
        if ($text -match '^\s*\[FAIL\]\s+(.*)') {
            $global:allFails += @{ source = $script; message = $matches[1].Trim() }
        }
        if ($text -match '^\s*\[WARN\]\s+(.*)') {
            $global:allWarns += @{ source = $script; message = $matches[1].Trim() }
        }
    }
}

# ─── BANNER ───
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║       RUN-ALL — Suite completa de tests  ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Magenta

# ─── EJECUTAR TODOS ───
Run-Test "Astro MCP" "check-mcp.ps1"
Run-Test "Frontend Design" "check-frontend-design.ps1"
Run-Test "JS Logic" "check-js-logic.ps1"
Run-Test "CSS Logic" "check-css-logic.ps1"
Run-Test "JSON Schema" "check-json-schema.ps1"
Run-Test "Paths" "check-paths.ps1"

# ─── [MANUAL] ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  [MANUAL] — Revisión de lógica profunda" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════" -ForegroundColor Yellow

foreach ($item in $global:manualItems) {
    Write-Host "`n  □ $($item.check)" -ForegroundColor Yellow
    Write-Host "    $($item.desc)" -ForegroundColor DarkGray
}
Write-Host "`n  (El agente debe revisar estos items manualmente)" -ForegroundColor DarkGray

# ─── GUARDAR EN bugs.md ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Guardando hallazgos en bugs.md..." -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan

$sessionDate = Get-Date -Format "yyyy-MM-dd"
$sessionNum = "?"

# Leer número de sesión actual del último log
$logFile = "$root\docs\$sessionDate.md"
if (Test-Path $logFile) {
    $logContent = Get-Content $logFile -Raw
    $sessions = [regex]::Matches($logContent, 'Sesión (\d+)')
    if ($sessions.Count -gt 0) { $sessionNum = [int]$sessions[-1].Groups[1].Value + 1 }
}

$totalFails = $global:allFails.Count
$totalWarns = $global:allWarns.Count

# Preservar contenido curado y actualizar fecha de escaneo
$existingCurated = ""
$hasHeader = $false
if (Test-Path $bugsFile) {
    $existingContent = Get-Content $bugsFile -Raw
    $autoMarker = $existingContent.IndexOf("## 📡 Hallazgos automáticos")
    if ($autoMarker -ge 0) {
        $existingCurated = $existingContent.Substring(0, $autoMarker).TrimEnd()
    } else {
        $existingCurated = $existingContent.TrimEnd()
    }
    $hasHeader = $existingCurated -match "^# Bugs conocidos"
}

# Construir header si no existe (primera vez)
$header = if (-not $hasHeader) {
@"
# Bugs conocidos — Alonso Suárez Reza Portfolio
"@
} else { "" }

# Actualizar línea de Último escaneo en el contenido curado
$existingCurated = $existingCurated -replace '(?m)^Último escaneo:.*', "Último escaneo: $sessionDate (Sesión $sessionNum)"

$bugsContent = if ($header) { "$header`n`n" } else { "" }
$bugsContent += "$existingCurated`n`n"

# Añadir FAILs
foreach ($f in $global:allFails) {
    $msg = $f.message
    $src = $f.source
    $bugsContent += @"

### $msg — ERROR
- **Origen:** $src
- **Detectado:** Sesión $sessionNum
- **Descripción:** $msg
- **Estado:** ⏳ Pendiente

"@
}

# Añadir WARNs
foreach ($w in $global:allWarns) {
    $msg = $w.message
    $src = $w.source
    $bugsContent += @"

### $msg — ADVERTENCIA
- **Origen:** $src
- **Detectado:** Sesión $sessionNum
- **Descripción:** $msg
- **Estado:** ⏳ Pendiente

"@
}

$bugsContent += @"

## 📡 Hallazgos automáticos (Sesión $sessionNum — $sessionDate)

"@

# Añadir FAILs (deduplicados)
$seenFail = @{}
foreach ($f in $global:allFails) {
    $msg = $f.message
    $src = $f.source
    $key = "$src|$msg"
    if ($seenFail[$key]) { continue }
    $seenFail[$key] = $true
    $bugsContent += @"

### $msg — ERROR
- **Origen:** $src
- **Detectado:** Sesión $sessionNum (automático)
- **Estado:** ⏳ Pendiente

"@
}

# Añadir WARNs (deduplicados)
$seenWarn = @{}
foreach ($w in $global:allWarns) {
    $msg = $w.message
    $src = $w.source
    $key = "$src|$msg"
    if ($seenWarn[$key]) { continue }
    $seenWarn[$key] = $true
    $bugsContent += @"

### $msg — ADVERTENCIA
- **Origen:** $src
- **Detectado:** Sesión $sessionNum (automático)
- **Estado:** ⏳ Pendiente

"@
}

$bugsContent += @"

---
*Los hallazgos automáticos se añaden aquí en cada ejecución de run-all.ps1. El agente debe moverlos a las secciones de arriba con la descripción detallada y severidad correcta.*
"@

# Guardar archivo
$bugsContent | Out-File -FilePath $bugsFile -Encoding utf8
Write-Host "  Hallazgos guardados en $bugsFile" -ForegroundColor Green

# ─── RESUMEN GLOBAL ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  RESUMEN GLOBAL" -ForegroundColor Magenta
Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  Scripts ejecutados: 6" -ForegroundColor White
Write-Host "  FAILs: $totalFails" -ForegroundColor $(if ($totalFails -gt 0) { "Red" } else { "Green" })
Write-Host "  WARNs: $totalWarns" -ForegroundColor $(if ($totalWarns -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Items manuales pendientes: $($global:manualItems.Count)" -ForegroundColor Yellow
Write-Host "  Bugs guardados en: spec/constitution/bugs.md" -ForegroundColor Cyan
Write-Host "`n"

if ($totalFails -gt 0) { exit 1 }
