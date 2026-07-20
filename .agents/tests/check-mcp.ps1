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
    Write-Host "`n-- $t --" -ForegroundColor Cyan
}

# --- CHECK 1: onclick ---
Title "Inline events"
$astroFiles = Get-ChildItem -Path "$src\components" -Filter *.astro
$onclickCount = 0
$onclickFiles = @()
foreach ($f in $astroFiles) {
    $m = Select-String -Path $f.FullName -Pattern 'onclick=' -SimpleMatch
    if ($m) { $onclickCount += $m.Count; $onclickFiles += $f.Name }
}
if ($onclickCount -eq 0) { Pass "No onclick= in .astro -- 0 occurrences" }
else { Fail "onclick= found in $($onclickFiles -join ', ') ($onclickCount occurrences)" "Migrate to data-lang + addEventListener" }

# --- CHECK 2: is:inline set:html in <script> ---
$inlineScriptCount = 0
$inlineScriptFiles = @()
foreach ($f in (Get-ChildItem -Path "$src\components" -Filter *.astro)) {
    $content = Get-Content $f.FullName -Raw
    if ($content -match '<script[^>]*set:html') {
        $inlineScriptCount++
        $inlineScriptFiles += $f.Name
    }
}
if ($inlineScriptCount -eq 0) { Pass "No <script set:html> -- 0 occurrences" }
else { Fail "<script set:html> in $($inlineScriptFiles -join ', ')" "Use data-data on <body> instead of inline script" }

# --- CHECK 3: window globals ---
$windowDATA = (Select-String -Path "$src\scripts\client.js" -Pattern 'window\.(DATA|changeLanguage)' -SimpleMatch).Count
if ($windowDATA -eq 0) { Pass "No window.DATA or window.changeLanguage -- 0 occurrences" }
else { Fail "window.DATA or window.changeLanguage found" "Move data to data-data and events to addEventListener" }

# --- CHECK 4: Astro.serialize ---
$astroSer = (Select-String -Path "$src\layouts\*.astro" -Pattern 'Astro\.serialize' -SimpleMatch).Count
if ($astroSer -eq 0) { Pass "No Astro.serialize() -- uses JSON.stringify" }
else { Fail "Astro.serialize() found" "Replace with JSON.stringify()" }

# --- CHECK 5: data-data on <body> ---
Title "MCP Structure"
$baseLayout = Get-Content "$src\layouts\BaseLayout.astro" -Raw
if ($baseLayout -match 'data-data=') { Pass "data-data on <body> in BaseLayout.astro" }
else { Fail "data-data NOT found in BaseLayout.astro" "Add data-data={dataBundle} to <body>" }

# --- CHECK 6: body tag complete ---
if ($baseLayout -match '<body[^>]*data-data=.*?>') { Pass "<body> tag complete with data-data" }
else { Warn "Could not verify <body> syntax" "Review BaseLayout.astro manually" }

# --- CHECK 7: tsconfig.json ---
$tsconfig = Test-Path "$root\tsconfig.json" -PathType Leaf
if ($tsconfig) {
    $tsc = Get-Content "$root\tsconfig.json" -Raw
    if ($tsc -match 'astro/tsconfigs/base') { Pass "tsconfig.json exists and extends astro/tsconfigs/base" }
    else { Fail "tsconfig.json does not extend astro/tsconfigs/base" "Add 'extends': 'astro/tsconfigs/base'" }
} else { Fail "tsconfig.json NOT found" "Create tsconfig.json with extends astro/tsconfigs/base" }

# --- CHECK 8: addEventListener ---
Title "Client JavaScript"
$clientJs = Get-Content "$src\scripts\client.js" -Raw
if ($clientJs -match "querySelectorAll\('\[data-lang\]'\)") { Pass "client.js uses addEventListener with [data-lang]" }
else { Fail "client.js does NOT use addEventListener with [data-lang]" "Migrate onclick to addEventListener" }

# --- CHECK 9: data fetch pattern ---
if ($clientJs -match 'document\.body\.dataset\.data') { Pass "client.js reads data from data-data" }
else { Fail "client.js does NOT use document.body.dataset.data" "Read data from document.body.dataset.data" }

# --- CHECK 10: LangSwitcher (in LangSwitcher.astro) ---
$langSwitcher = Get-Content "$src\components\LangSwitcher.astro" -Raw
if ($langSwitcher -match 'data-lang=' -and $langSwitcher -notmatch 'onclick=') { Pass "LangSwitcher.astro includes data-lang buttons (no onclick)" }
else { Fail "LangSwitcher.astro missing data-lang or has onclick" "Include ES/EN buttons with data-lang in LangSwitcher.astro" }

# --- CHECK 11: set:html on HTML elements ---
Title "Astro Directives"
$setHtmlCount = (Select-String -Path "$src\components\*.astro" -Pattern 'set:html=' -SimpleMatch).Count
if ($setHtmlCount -gt 0) { Pass "set:html used correctly on $setHtmlCount HTML elements" }
else { Warn "set:html not used -- may be normal if all is data-i18n" "Verify dynamic content works" }

# --- CHECK 12: data-i18n attributes ---
$i18nCount = (Select-String -Path "$src\components\*.astro" -Pattern 'data-i18n=' -SimpleMatch).Count
if ($i18nCount -gt 0) { Pass "data-i18n present on $i18nCount elements -- i18n working" }
else { Warn "No data-i18n -- static translation?" "Verify translation system" }

# --- CHECK 13: skills-lock.json ---
$lockFile = Test-Path "$root\.agents\skills-lock.json" -PathType Leaf
if ($lockFile) { Pass "skills-lock.json exists in .agents/" }
else { Warn "skills-lock.json NOT found in .agents/" "Run skill tool or create skills-lock.json manually" }

# --- CHECK 14: .agents/skills/ exists ---
$skillsDir = Test-Path "$root\.agents\skills" -PathType Container
if ($skillsDir) { Pass ".agents/skills/ exists" }
else { Warn ".agents/skills/ NOT found" "Create .agents/skills/ with frontend-design skill" }

# --- CHECK 15: No obsolete imports ---
if ($clientJs -match 'import\s') {
    $imports = [regex]::Matches($clientJs, 'import\s+[^;]+;').Value
    Warn "client.js has import declarations ($imports)" "Verify they work with Astro bundler"
} else { Pass "client.js has no imports -- flat module" }

# --- CHECK 16: Script bundled correctly ---
$baseLayoutLines = Get-Content "$src\layouts\BaseLayout.astro"
$scriptSrc = $baseLayoutLines | Where-Object { $_ -match '<script\s+src=' }
if ($scriptSrc) { Pass "Script included as src (Astro bundle)" }
else { Fail "Script not found as src in BaseLayout" "Add <script src='.../client.js'></script>" }

# --- SUMMARY ---
Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "  MCP SUMMARY" -ForegroundColor Cyan
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
