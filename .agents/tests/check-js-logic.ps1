# .agents/tests/check-js-logic.ps1
# Client JavaScript logic test
# Run: pwsh .agents/tests/check-js-logic.ps1

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
    Write-Host "`n-- $t --" -ForegroundColor Cyan
}

# --- CHECK 1: getElementById without null guard ---
Title "Null safety"
$getElemById = [regex]::Matches($jsContent, 'document\.getElementById\([^)]+\)')
$unguarded = @()
foreach ($match in $getElemById) {
    $idx = $match.Index
    $after = $jsContent.Substring($idx + $match.Length, [Math]::Min(60, $jsContent.Length - $idx - $match.Length))
    if ($after -match '^\s*\.' -and -not $after -match '^\s*\.\s*$') {
        $lineNum = ($jsContent.Substring(0, $idx).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
        $unguarded += "  Line $lineNum"
    }
}
if ($unguarded.Count -eq 0) { Pass "getElementById always with null guard" }
else {
    $msg = "getElementById without null guard in $($unguarded.Count) place(s):`n$($unguarded -join "`n")"
    Fail $msg "Add null guard: const btn = document.getElementById(...); if (btn) btn.classList.add(...)"
}

# --- CHECK 2: changeLanguage without early return ---
if ($jsContent -match 'function\s+changeLanguage\s*\(') {
    $funcStart = $jsContent.IndexOf('function changeLanguage')
    $funcEnd = $jsContent.IndexOf('function', $funcStart + 1)
    if ($funcEnd -eq -1) { $funcEnd = $jsContent.Length }
    $funcBody = $jsContent.Substring($funcStart, $funcEnd - $funcStart)
    if ($funcBody -match 'if\s*\(\s*lang\s*===\s*currentLang\s*\)') {
        Pass "changeLanguage has early return if same language"
    } else {
        Warn "changeLanguage has no early return" "Add: if (lang === currentLang) return;"
    }
} else { Warn "Function changeLanguage not found" "Check that it exists" }

# --- CHECK 3: target=_blank without rel=noopener in JS ---
Title "Link security"
$blankWithoutNoopener = @()
# Only check actual code lines, not comments
$codeLines = $jsLines | Where-Object { $_ -notmatch '^\s*//' -and $_ -notmatch '^\s*\*' }
$codeContent = $codeLines -join "`n"
$blankPattern = [regex]::Match($codeContent, '(?s)target\s*=\s*["'']_blank["'']')
if ($blankPattern.Success) {
    $blankStart = $blankPattern.Index
    $contextStart = [Math]::Max(0, $blankStart - 200)
    $context = $codeContent.Substring($contextStart, [Math]::Min(400, $codeContent.Length - $contextStart))
    if ($context -notmatch 'rel\s*=\s*["'']noopener') {
        $blankWithoutNoopener += "  client.js: lines around getElementById/setInnerHTML"
    }
}
# Check in components
foreach ($f in $components) {
    $content = Get-Content $f.FullName -Raw
    $hrefPattern = 'href="https?://[^"]*"'
    $hrefs = [regex]::Matches($content, $hrefPattern)
    foreach ($h in $hrefs) {
        $startIdx = [Math]::Max(0, $h.Index - 100)
        $context = $content.Substring($startIdx, [Math]::Min(300, $content.Length - $startIdx))
        if ($context -match 'target\s*=\s*["'']_blank["'']' -and $context -notmatch 'rel\s*=\s*["'']noopener') {
            $lineNum = ($content.Substring(0, $h.Index).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
            $blankWithoutNoopener += "  $($f.Name): line ~$lineNum"
            break
        }
    }
}
if ($blankWithoutNoopener.Count -eq 0) { Pass "All target=_blank have rel=noopener" }
else {
    $msg = "target=_blank without rel=noopener:`n$($blankWithoutNoopener -join "`n")"
    Warn $msg "Add rel='noopener noreferrer' to all external links"
}

# --- CHECK 4: btn-primary referenced but missing CSS ---
Title "Referenced CSS classes"
$cssFile = "$root\src\styles\global.css"
$cssContent = Get-Content $cssFile -Raw
$btnPrimaryInJS = $jsContent -match 'btn-primary'
$btnPrimaryInAstro = (Select-String -Path "$root\src\components\*.astro" -Pattern 'btn-primary').Count
$btnPrimaryInCSS = $cssContent -match '\.btn-primary'
if (($btnPrimaryInJS -or $btnPrimaryInAstro -gt 0) -and -not $btnPrimaryInCSS) {
    $refs = @()
    if ($btnPrimaryInJS) { $refs += "client.js" }
    if ($btnPrimaryInAstro -gt 0) { $refs += "$btnPrimaryInAstro Astro component(s)" }
    Warn "btn-primary used in $($refs -join ', ') but NOT defined in CSS" "Define .btn-primary in global.css or remove the class"
} elseif ($btnPrimaryInCSS) { Pass "btn-primary defined in CSS" }
else { Pass "btn-primary not referenced -- N/A" }

# --- CHECK 5: window.* undeclared globals ---
Title "Global variables"
$windowRefs = [regex]::Matches($jsContent, 'window\.\w+')
$problematicGlobals = @()
foreach ($wr in $windowRefs) {
    $name = $wr.Value
    if ($name -match 'window\.(DATA|changeLanguage|renderAll)') {
        $lineNum = ($jsContent.Substring(0, $wr.Index).ToCharArray() | Where-Object { $_ -eq "`n" }).Count + 1
        $problematicGlobals += "  Line ${lineNum}: $name"
    }
}
if ($problematicGlobals.Count -eq 0) { Pass "No problematic window.* globals" }
else {
    $msg = "window.* found:`n$($problematicGlobals -join "`n")"
    Fail $msg "Remove window.* dependency -- data goes in data-data, events in addEventListener"
}

# --- CHECK 6: does init() call renderAll? ---
Title "Initialization flow"
if ($jsContent -match 'function\s+init\s*\(') {
    # Find the LAST (global) init() function, not nested ones
    $allInitStarts = [regex]::Matches($jsContent, 'function\s+init\s*\(')
    $lastInit = $allInitStarts[$allInitStarts.Count - 1]
    $initStart = $lastInit.Index
    $braceStart = $jsContent.IndexOf('{', $initStart)
    $depth = 0
    $initBody = ""
    for ($i = $braceStart; $i -lt $jsContent.Length; $i++) {
        if ($jsContent[$i] -eq '{') { $depth++ }
        elseif ($jsContent[$i] -eq '}') { $depth-- }
        if ($depth -le 0) { $initBody = $jsContent.Substring($braceStart, $i - $braceStart + 1); break }
    }
    if ($initBody -match 'renderAll') { Pass "init() calls renderAll()" }
    else {
        Fail "init() does NOT call renderAll() -- visitor with EN saved sees mixed ES/EN sections" "Add renderAll() or changeLanguage(savedLang) at end of init()"
    }
} else { Fail "Function init() not found in client.js" "Add init() as entry point" }

# --- CHECK 7: Quotes/inconsistent patterns ---
Title "Consistency"
$singleQuotes = ($jsContent.ToCharArray() | Where-Object { $_ -eq "'" }).Count
$doubleQuotes = ($jsContent.ToCharArray() | Where-Object { $_ -eq '"' }).Count
if ($singleQuotes -gt $doubleQuotes * 1.5 -or $doubleQuotes -gt $singleQuotes * 1.5) {
    $dominant = if ($singleQuotes -gt $doubleQuotes) { "single" } else { "double" }
    Warn "Predominantly $dominant quotes ($singleQuotes single vs $doubleQuotes double)" "Unify quote style if possible"
} else { Pass "Balanced quote usage ($singleQuotes single, $doubleQuotes double)" }

# --- SUMMARY ---
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  JS LOGIC SUMMARY" -ForegroundColor Cyan
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
