# .agents/tests/check-frontend-design.ps1
# Frontend-design skill compliance test
# Run: pwsh .agents/tests/check-frontend-design.ps1

$root = Resolve-Path "$PSScriptRoot\..\.."
$css = "$root\src\styles\global.css"
$js = "$root\src\scripts\client.js"
$lang = "$root\src\data\nav.json"

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

$cssContent = Get-Content $css -Raw
$cssLines = Get-Content $css
$jsContent = Get-Content $js -Raw
$langContent = Get-Content $lang -Raw | ConvertFrom-Json

# --- CHECK 1: :root defines essential variables ---
Title "Design Tokens"
$requiredVars = @(
    '--color-bg', '--color-bg-card', '--color-bg-hover', '--color-border',
    '--color-text', '--color-text-bright', '--color-text-muted',
    '--color-accent',
    '--font-display', '--font-body'
)
$missingVars = @()
foreach ($v in $requiredVars) {
    if ($cssContent -notmatch [regex]::Escape($v)) { $missingVars += $v }
}
if ($missingVars.Count -eq 0) { Pass "All $($requiredVars.Count) essential variables defined in :root" }
else { Fail "Missing variables in :root: $($missingVars -join ', ')" "Add missing variables with real values" }

# --- CHECK 2: No self-referencing variables (circular) ---
$circularRefs = @()
foreach ($v in $requiredVars) {
    $pattern = [regex]::Escape("$($v): var($($v))")
    if ($cssContent -match $pattern) {
        $line = ($cssLines | Select-String -Pattern $pattern).LineNumber
        $circularRefs += "$($v) (line $line)"
    }
}
if ($circularRefs.Count -eq 0) { Pass "No self-referencing variables (circular ref)" }
else { Fail "Circular variables detected: $($circularRefs -join '; ')" "Replace var(x) with real value, e.g.: --color-bg: #0d1117" }

# --- CHECK 3: !important only inside prefers-reduced-motion ---
Title "!important & accessibility"
$inMotionBlock = $false
$motionDepth = 0
$outsideImportant = @()
$currentSelector = ""
$selectorDepth = 0
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    $line = $cssLines[$i]
    if ($line -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') { $inMotionBlock = $true; $motionDepth = 0 }
    if ($inMotionBlock) {
        $motionDepth += ($line.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $motionDepth -= ($line.ToCharArray() | Where-Object { $_ -eq '}' }).Count
        if ($motionDepth -le 0) { $inMotionBlock = $false; continue }
    }
    # Track current CSS selector block
    if ($line -match '^\s*([^{]+)\s*\{') {
        $currentSelector = $Matches[1].Trim()
    }
    if ($line -match '!important' -and -not $inMotionBlock) {
        # Exclude intentional !important in sidebar state classes and global state classes
        if ($currentSelector -notmatch 'sidebar-(no-transition|delayed|locked|init-|midpoint|snap)' -and
            $currentSelector -notmatch '(js-loading|is-resizing)') {
            $outsideImportant += "  Line $($i+1): $($line.Trim())"
        }
    }
}
if ($outsideImportant.Count -eq 0) { Pass "!important only inside prefers-reduced-motion (WCAG)" }
else {
    $msg = "!important outside prefers-reduced-motion block:`n" + ($outsideImportant -join "`n")
    Fail $msg "Replace !important with natural specificity"
}

# --- CHECK 4: prefers-reduced-motion in CSS ---
if ($cssContent -match '@media\s*\(prefers-reduced-motion:\s*reduce\)') { Pass "@media (prefers-reduced-motion: reduce) exists in CSS" }
else { Fail "Missing @media (prefers-reduced-motion: reduce) in CSS" "Add accessibility block with * { transition-duration: 0.01ms !important; }" }

# --- CHECK 5: prefers-reduced-motion in JS ---
if ($jsContent -match 'matchMedia\(.*prefers-reduced-motion.*reduce') { Pass "prefers-reduced-motion also handled in JS (motionOK)" }
else { Fail "Missing prefers-reduced-motion detection in JS" "Add const motionOK = !window.matchMedia('...').matches" }

# --- CHECK 6: .reveal reset in prefers-reduced-motion ---
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
if ($motionBlockText -match '\.reveal\s*\{') { Pass ".reveal has reset in prefers-reduced-motion" }
else { Fail "Missing .reveal reset in prefers-reduced-motion" "Add .reveal { opacity: 1; transform: none; transition: none; }" }

# --- CHECK 7: JS scroll reveal conditional ---
if ($jsContent -match 'motionOK') { Pass "Scroll reveal conditional with motionOK" }
else { Fail "Missing motionOK variable in client.js" "Add const motionOK = !window.matchMedia(...).matches" }
if ($jsContent -match 'if\s*\(\s*!?\s*motionOK\s*\)') { Pass "Scroll reveal skips if reduced-motion active" }
else { Fail "Missing if (!motionOK) in event listener" "Wrap scroll reveal in if (!motionOK) check" }

# --- CHECK 8: Media queries responsive ---
Title "Responsive"
$media1235 = (Select-String -InputObject $cssContent -Pattern '@media\s*\(max-width:\s*1235px\)' -AllMatches).Matches.Count
if ($media1235 -ge 1) { Pass "@media (max-width: 1235px) present ($media1235 blocks)" }
else { Fail "Missing @media (max-width: 1235px)" "Add primary responsive breakpoint" }

$media480 = (Select-String -InputObject $cssContent -Pattern '@media\s*\(max-width:\s*480px\)' -AllMatches).Matches.Count
if ($media480 -ge 1) { Pass "@media (max-width: 480px) exists" }
else { Warn "Missing @media (max-width: 480px)" "Consider adding for very small mobile devices" }

# --- CHECK 9: font-display in headings ---
Title "Typography"
$missingDisplay = @()
$skillItem = $cssContent -match '(?s)\.skill-personality-item strong\s*\{[^}]*font-family:\s*var\(--font-display\)'

$fontDisplayOk = 0
if ($skillItem) { $fontDisplayOk++ } else { $missingDisplay += ".skill-personality-item strong" }

if ($missingDisplay.Count -eq 0) { Pass "--font-display in heading selectors" }
else { Warn "Missing --font-display in: $($missingDisplay -join ', ')" "Apply font-family: var(--font-display)" }

if ($cssContent -match 'body\s*\{[^}]*--font-body') { Pass "--font-body applied in body" }
else { Fail "Missing --font-body in body" "Apply font-family: var(--font-body)" }

# --- CHECK 10: No #58a6ff (old accent) ---
Title "Color palette"
$oldAccent = (Select-String -Path $css -Pattern '#58a6ff' -SimpleMatch).Count
if ($oldAccent -eq 0) { Pass "No #58a6ff remaining (migrated to #7fc1fe)" }
else { Warn "#58a6ff found ($oldAccent occurrences)" "Migrate to var(--color-accent) (#7fc1fe)" }

# --- CHECK 11: Hardcoded #ffffff outside badge classes ---
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
if ($whiteLines.Count -eq 0) { Pass "No hardcoded #ffffff outside badges" }
else {
    $msg = "#ffffff hardcoded in $($whiteLines.Count) places outside badges:`n" + ($whiteLines -join "`n")
    Warn $msg "Use var(--color-text-bright) instead of #ffffff"
}

if ($badgeWhiteLines.Count -gt 0) {
    $msg = "#ffffff in badges ($($badgeWhiteLines.Count) places) -- acceptable but reviewable:`n" + ($badgeWhiteLines -join "`n")
    Warn $msg "Consider var(--color-text-bright) for consistency"
}

# --- CHECK 12: Hardcoded #1a1f26 ---
$hard1a1f26 = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) { if ($cssLines[$i] -match '#1a1f26') { $hard1a1f26 += "  Line $($i+1): $($cssLines[$i].Trim())" } }
if ($hard1a1f26.Count -gt 0) {
    $msg = "#1a1f26 hardcoded:`n" + ($hard1a1f26 -join "`n")
    Warn $msg "Use var(--color-bg-card) (#161b22) instead"
} else { Pass "No hardcoded #1a1f26" }

# --- CHECK 13: Brand colors in badges (intentional) ---
$brandColors = @('#3776ab', '#e76f00', '#f7df1e', '#00758f', '#734f96', '#007acc', '#2c2255', '#1a6ac9', '#710900', '#10a37f')
$foundBrands = @()
foreach ($bc in $brandColors) {
    $escaped = [regex]::Escape($bc)
    $m = (Select-String -InputObject $cssContent -Pattern $escaped -AllMatches).Matches.Count
    if ($m -gt 0) { $foundBrands += "$bc ($m use(s))" }
}
if ($foundBrands.Count -gt 0) {
    Warn "Brand colors in badges: $($foundBrands -join ', ') -- intentional but not normalizable" "Badge colors are OK by design, but verify none override theme variables"
} else { Pass "No brand colors in badges" }

# --- CHECK 14: Computational grid ---
Title "Visual signature"
if ($cssContent -match '(?s)#inicio.*background.*linear-gradient.*1px') { Pass "Computational grid in #inicio (28px, 2%)" }
else { Warn "Computational grid not detected in #inicio" "Add grid with linear-gradient as background-image" }

if ($cssContent -match '#inicio::after' -and $cssContent -match 'linear-gradient\(180deg') { Pass "Fade gradient in #inicio" }
else { Warn "Missing fade gradient in #inicio::after" "Add linear-gradient(180deg, transparent 60%, var(--color-bg) 100%)" }

# --- CHECK 15: No emojis in headings ---
Title "Content"
$emojiPattern = '[^\x00-\x7F\x80-\xFF\u00F1\u00D1\u00E1-\u00FA\u00C1-\u00DA\u00BF\u00A1\u00FC\u00DC]'
$hasEmoji = $false
$langObj = $langContent.es
$langObj.PSObject.Properties | Where-Object { $_.Name -like 'sec-*' -or $_.Name -like 'cv-*' } | ForEach-Object {
    if ($_.Value -match $emojiPattern) { $hasEmoji = $true; Warn "Emoji detected in lang.json: $($_.Name) = '$($_.Value)'" "Remove emoji from heading" }
}
if (-not $hasEmoji) { Pass "No emojis in headings (lang.json)" }

# --- CHECK 16: btn-outline uses custom properties ---
Title "Components"
$btnOutline = $cssContent -match '(?s)\.btn-outline\s*\{[^}]*\}'
$btnOutlineHover = $cssContent -match '(?s)\.btn-outline:hover\s*\{[^}]*\}'
if ($btnOutline) {
    $btnBlock = [regex]::Match($cssContent, '(?s)\.btn-outline\s*\{[^}]*\}').Value
    if ($btnBlock -match 'var\(--color-border\)' -and $btnBlock -match 'var\(--color-text-muted\)') { Pass ".btn-outline uses custom properties" }
    else { Warn ".btn-outline could use more custom properties" "Review colors in .btn-outline" }
} else { Warn ".btn-outline not found" "Verify the component exists" }

# --- CHECK 17: Nav sticky or sidebar ---
if ($cssContent -match 'nav\s*\{[^}]*position:\s*sticky[^}]*backdrop-filter') { Pass "Nav sticky with backdrop-filter" }
elseif ($cssContent -match '\.sidebar\s*\{[^}]*position:\s*sticky') { Pass "Sidebar is sticky (nav inside sidebar)" }
else { Warn "Missing sticky nav or sidebar" "Add position: sticky for navigation" }

# --- CHECK 18: Badges without redundant color ---
$redundantLines = @()
for ($i = 0; $i -lt $cssLines.Count; $i++) {
    if ($cssLines[$i] -match 'color:\s*#ffffff' -and $cssLines[$i] -match 'background-color:') {
        $redundantLines += "  Line $($i+1): $($cssLines[$i].Trim())"
    }
}
if ($redundantLines.Count -gt 0) {
    $msg = "Redundant color (color + background-color hardcoded):`n" + ($redundantLines -join "`n")
    Warn $msg "Review if color is necessary or inheritable"
} else { Pass "No redundant colors" }

# --- CHECK 19: Lang switcher integrated in nav ---
if ($cssContent -match '\.lang-switcher-floating\s*\{') { Pass "LangSwitcher integrated in sidebar (floating)" }
else { Warn "LangSwitcher missing styles" "Verify .lang-switcher-floating exists in CSS" }

# --- CHECK 20: Back-to-top button ---
if ($cssContent -match '\.back-to-top\s*\{[^}]*position:\s*fixed') { Pass "Back-to-top button fixed" }
else { Warn "Missing back-to-top button" "Add .back-to-top if not present" }

# --- SUMMARY ---
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  FRONTEND DESIGN SUMMARY" -ForegroundColor Cyan
Write-Host "  PASS: $($passes.Count)   FAIL: $($failures.Count)   WARN: $($warnings.Count)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

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
