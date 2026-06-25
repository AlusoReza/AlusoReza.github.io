# .agents/tests/run-all.ps1
# Master runner: runs all tests and saves findings to bugs.md
# Run: pwsh .agents/tests/run-all.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$testsDir = "$PSScriptRoot"
$bugsFile = "$root\spec\constitution\bugs.md"

$allOutput = @()
$global:allFails = @()
$global:allWarns = @()
$global:manualItems = @(
    @{ check = "init() flow — deep logic"; desc = "init() calls translateUI() but not renderAll(). Visitor with EN saved sees mixed sections." },
    @{ check = "📄 icon in Contact.astro"; desc = "The icon is INSIDE the data-i18n span. translateUI() deletes it when switching language." },
    @{ check = "Data architecture"; desc = "Verify that data-data → JSON.parse → renderAll() works without console errors." },
    @{ check = "Known bug regression"; desc = "Check spec/constitution/bugs.md — bugs marked as ✅ Arreglado should remain fixed." }
)

function Title($t) {
    Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Magenta
    Write-Host "  $t" -ForegroundColor Magenta
    Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
}

function Run-Test($name, $script) {
    $path = "$testsDir\$script"
    if (-not (Test-Path $path)) {
        Write-Host "`n  [SKIP] $script — not found" -ForegroundColor DarkGray
        return @()
    }
    Write-Host "`n  >>> Running $script..." -ForegroundColor Cyan
    $output = & pwsh -NoProfile -File $path 2>&1
    $output | ForEach-Object { Write-Host $_ }
    
    # Capture FAILs and WARNs for bugs.md
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
Write-Host "║    RUN-ALL — Complete test suite         ║" -ForegroundColor Magenta
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Magenta

# ─── RUN ALL ───
Run-Test "Astro MCP" "check-mcp.ps1"
Run-Test "Frontend Design" "check-frontend-design.ps1"
Run-Test "JS Logic" "check-js-logic.ps1"
Run-Test "CSS Logic" "check-css-logic.ps1"
Run-Test "JSON Schema" "check-json-schema.ps1"
Run-Test "Paths" "check-paths.ps1"

# ─── [MANUAL] ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "  [MANUAL] — Deep logic review" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════" -ForegroundColor Yellow

foreach ($item in $global:manualItems) {
    Write-Host "`n  □ $($item.check)" -ForegroundColor Yellow
    Write-Host "    $($item.desc)" -ForegroundColor DarkGray
}
Write-Host "`n  (The agent must review these items manually)" -ForegroundColor DarkGray

# ─── SAVE TO bugs.md ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Saving findings to bugs.md..." -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════" -ForegroundColor Cyan

$sessionDate = Get-Date -Format "yyyy-MM-dd"
$sessionNum = "?"

# Read current session number from last log
$logFile = "$root\docs\$sessionDate.md"
if (Test-Path $logFile) {
    $logContent = Get-Content $logFile -Raw
    $sessions = [regex]::Matches($logContent, 'Sesión (\d+)')
    if ($sessions.Count -gt 0) { $sessionNum = [int]$sessions[-1].Groups[1].Value + 1 }
}

$totalFails = $global:allFails.Count
$totalWarns = $global:allWarns.Count

# Preserve curated content and update scan date
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

# Build header if it doesn't exist (first run)
$header = if (-not $hasHeader) {
@"
# Bugs conocidos — Alonso Suárez Reza Portfolio
"@
} else { "" }

# Update Last scan line in curated content
$existingCurated = $existingCurated -replace '(?m)^Último escaneo:.*', "Last scan: $sessionDate (Sesión $sessionNum)"

$bugsContent = if ($header) { "$header`n`n" } else { "" }
$bugsContent += "$existingCurated`n`n"

# Add FAILs
foreach ($f in $global:allFails) {
    $msg = $f.message
    $src = $f.source
    $bugsContent += @"

### $msg — ERROR
- **Source:** $src
- **Detected:** Session $sessionNum
- **Description:** $msg
- **Status:** ⏳ Pending

"@
}

# Add WARNs
foreach ($w in $global:allWarns) {
    $msg = $w.message
    $src = $w.source
    $bugsContent += @"

### $msg — WARNING
- **Source:** $src
- **Detected:** Session $sessionNum
- **Description:** $msg
- **Status:** ⏳ Pending

"@
}

$bugsContent += @"

## 📡 Automatic findings (Session $sessionNum — $sessionDate)

"@

# Add FAILs (deduplicated)
$seenFail = @{}
foreach ($f in $global:allFails) {
    $msg = $f.message
    $src = $f.source
    $key = "$src|$msg"
    if ($seenFail[$key]) { continue }
    $seenFail[$key] = $true
    $bugsContent += @"

### $msg — ERROR
- **Source:** $src
- **Detected:** Session $sessionNum (automatic)
- **Status:** ⏳ Pending

"@
}

# Add WARNs (deduplicated)
$seenWarn = @{}
foreach ($w in $global:allWarns) {
    $msg = $w.message
    $src = $w.source
    $key = "$src|$msg"
    if ($seenWarn[$key]) { continue }
    $seenWarn[$key] = $true
    $bugsContent += @"

### $msg — WARNING
- **Source:** $src
- **Detected:** Session $sessionNum (automatic)
- **Status:** ⏳ Pending

"@
}

$bugsContent += @"

---
*Automatic findings are added here on each run-all.ps1 execution. The agent must move them to sections above with the correct description and severity.*
"@

# Save file
$bugsContent | Out-File -FilePath $bugsFile -Encoding utf8
Write-Host "  Findings saved to $bugsFile" -ForegroundColor Green

# ─── GLOBAL SUMMARY ───
Write-Host "`n`n════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  GLOBAL SUMMARY" -ForegroundColor Magenta
Write-Host "════════════════════════════════════════════" -ForegroundColor Magenta
Write-Host "  Scripts run: 6" -ForegroundColor White
Write-Host "  FAILs: $totalFails" -ForegroundColor $(if ($totalFails -gt 0) { "Red" } else { "Green" })
Write-Host "  WARNs: $totalWarns" -ForegroundColor $(if ($totalWarns -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Manual items pending: $($global:manualItems.Count)" -ForegroundColor Yellow
Write-Host "  Bugs saved to: spec/constitution/bugs.md" -ForegroundColor Cyan
Write-Host "`n"

if ($totalFails -gt 0) { exit 1 }
