# Verify My Journal child theme structure
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$theme = Join-Path $root 'plugins\themes\myjournal'

$required = @(
	'index.php',
	'version.xml',
	'MyJournalThemePlugin.php',
	'styles\custom.less',
	'styles\fonts.less',
	'styles\tokens.less',
	'styles\header.less',
	'styles\hero.less',
	'styles\homepage.less',
	'styles\pages.less',
	'styles\galley.less',
	'styles\dark.less',
	'styles\htmlGalley.less',
	'fonts\SourceSans3-Regular.ttf.woff2',
	'fonts\SourceSans3-It.ttf.woff2',
	'fonts\SourceSans3-Semibold.ttf.woff2',
	'fonts\SourceSans3-Bold.ttf.woff2',
	'js\theme.js',
	'templates\frontend\pages\indexJournal.tpl',
	'templates\frontend\components\header.tpl',
	'templates\frontend\components\footer.tpl',
	'templates\frontend\objects\article_summary.tpl',
	'templates\frontend\pages\issueArchive.tpl',
	'images\logo-ijds.svg',
	'locale\en\locale.po',
	'locale\id\locale.po'
)

$failed = $false
Write-Host "Theme root: $theme"
Write-Host ''

foreach ($rel in $required) {
	$path = Join-Path $theme $rel
	if (Test-Path -LiteralPath $path) {
		Write-Host "[OK] $rel"
	} else {
		Write-Host "[MISSING] $rel"
		$failed = $true
	}
}

$pluginPhp = Join-Path $theme 'MyJournalThemePlugin.php'
$php = Get-Content -LiteralPath $pluginPhp -Raw
if ($php -notmatch "setParent\('healthsciencesthemeplugin'\)") {
	Write-Host "[FAIL] setParent('healthsciencesthemeplugin') not found"
	$failed = $true
} else {
	Write-Host "[OK] setParent(healthsciencesthemeplugin)"
}

if ($php -match "setParent\('defaultthemeplugin'\)") {
	Write-Host "[FAIL] still setParent(defaultthemeplugin)"
	$failed = $true
} else {
	Write-Host "[OK] Default Theme is no longer the parent"
}

if ($php -notmatch "modifyStyle\('stylesheet'") {
	Write-Host "[FAIL] modifyStyle('stylesheet') not found"
	$failed = $true
} else {
	Write-Host "[OK] modifyStyle(stylesheet)"
}

if ($php -notmatch "styles/custom\.less") {
	Write-Host "[FAIL] styles/custom.less not registered"
	$failed = $true
} else {
	Write-Host "[OK] custom.less registered"
}

$homepage = Join-Path $theme 'templates\frontend\pages\indexJournal.tpl'
$homepageTpl = Get-Content -LiteralPath $homepage -Raw
if ($homepageTpl -notmatch 'myjournal-hero') {
	Write-Host "[FAIL] homepage missing myjournal-hero"
	$failed = $true
} else {
	Write-Host "[OK] homepage hero (myjournal-hero)"
}
if ($homepageTpl -notmatch 'container-homepage-issue') {
	Write-Host "[FAIL] homepage missing Health Sciences issue layout (container-homepage-issue)"
	$failed = $true
} else {
	Write-Host "[OK] Health Sciences homepage issue layout"
}

$lessDir = Join-Path $theme 'styles'
$less = @(
	Get-Content -LiteralPath (Join-Path $lessDir 'custom.less') -Raw
	Get-Content -LiteralPath (Join-Path $lessDir 'tokens.less') -Raw
	Get-Content -LiteralPath (Join-Path $lessDir 'header.less') -Raw
	Get-Content -LiteralPath (Join-Path $lessDir 'fonts.less') -Raw
) -join "`n"
if ($less -notmatch '#112d52') {
	Write-Host "[FAIL] styles missing SLDPI brand #112d52"
	$failed = $true
} else {
	Write-Host "[OK] SLDPI brand colour #112d52"
}

$localeEn = Get-Content -LiteralPath (Join-Path $theme 'locale\en\locale.po') -Raw
if ($localeEn -notmatch 'plugins\.themes\.myjournal\.heroTagline') {
	Write-Host "[FAIL] EN locale missing heroTagline"
	$failed = $true
} else {
	Write-Host "[OK] EN hero strings"
}

$headerTpl = Get-Content -LiteralPath (Join-Path $theme 'templates\frontend\components\header.tpl') -Raw
if ($headerTpl -notmatch 'myjournal-header' -or $headerTpl -notmatch 'myjournal-header__search') {
	Write-Host "[FAIL] header missing logo/menu/search layout"
	$failed = $true
} else {
	Write-Host "[OK] header logo-menu-tools layout"
}

if ($headerTpl -notmatch 'data-theme-toggle' -or $headerTpl -notmatch 'data-search-open') {
	Write-Host "[FAIL] header missing theme toggle or icon search"
	$failed = $true
} else {
	Write-Host "[OK] theme toggle + icon search"
}

if ($headerTpl -notmatch 'myjournal-skip' -or $headerTpl -notmatch 'myjournal-main') {
	Write-Host "[FAIL] header missing skip link or main landmark"
	$failed = $true
} else {
	Write-Host "[OK] skip link + main landmark"
}

$footerTpl = Get-Content -LiteralPath (Join-Path $theme 'templates\frontend\components\footer.tpl') -Raw
if ($footerTpl -notmatch '</main>') {
	Write-Host "[FAIL] footer does not close main landmark"
	$failed = $true
} else {
	Write-Host "[OK] footer closes main"
}

$articleSummary = Get-Content -LiteralPath (Join-Path $theme 'templates\frontend\objects\article_summary.tpl') -Raw
if ($articleSummary -notmatch 'article-summary-footer') {
	Write-Host "[FAIL] article_summary missing card footer layout"
	$failed = $true
} else {
	Write-Host "[OK] article summary card layout"
}

if ($less -notmatch '--mj-gold' -or $less -notmatch 'LESS pitfalls') {
	Write-Host "[FAIL] styles missing gold token or LESS pitfalls note"
	$failed = $true
} else {
	Write-Host "[OK] design tokens + LESS pitfalls documented"
}

if ($less -notmatch 'myjournal-skip') {
	Write-Host "[FAIL] styles missing skip-link"
	$failed = $true
} else {
	Write-Host "[OK] skip-link styles"
}

$customLess = Get-Content -LiteralPath (Join-Path $lessDir 'custom.less') -Raw
if ($customLess -notmatch '@import "tokens.less"' -or $customLess -notmatch '@import "pages.less"' -or $customLess -notmatch '@import "dark.less"') {
	Write-Host "[FAIL] custom.less is not a split-LESS entrypoint"
	$failed = $true
} else {
	Write-Host "[OK] custom.less imports split stylesheets"
}

if ($php -notmatch "addOption\('accentColour'" -or $php -notmatch "addOption\('enableThemeToggle'" -or $php -notmatch "addOption\('heroTitle'") {
	Write-Host "[FAIL] Theme Options missing"
	$failed = $true
} else {
	Write-Host "[OK] Theme Options (accent, toggle, hero)"
}

if ($php -match 'fonts\.googleapis') {
	Write-Host "[FAIL] Google Fonts CDN still registered"
	$failed = $true
} else {
	Write-Host "[OK] no Google Fonts CDN"
}

if ($php -notmatch 'Source Sans 3' -or $less -notmatch 'Source Sans 3') {
	Write-Host "[FAIL] Source Sans 3 font not configured"
	$failed = $true
} else {
	Write-Host "[OK] Source Sans 3 font"
}

if ($php -notmatch "contexts' => 'htmlGalley'" -and $php -notmatch 'htmlGalley') {
	Write-Host "[FAIL] HTML galley style context missing"
	$failed = $true
} else {
	Write-Host "[OK] HTML galley Source Sans stylesheet"
}

$tplDisplay = Get-Content -LiteralPath (Join-Path $theme 'templates\plugins\generic\htmlArticleGalley\templates\display.tpl') -Raw
$js = Get-Content -LiteralPath (Join-Path $theme 'js\theme.js') -Raw
if ($tplDisplay -notmatch 'data-galley-toc' -or $js -notmatch 'buildGalleyToc') {
	Write-Host "[FAIL] HTML galley TOC missing"
	$failed = $true
} else {
	Write-Host "[OK] HTML galley TOC"
}

$archiveTpl = Get-Content -LiteralPath (Join-Path $theme 'templates\frontend\pages\issueArchive.tpl') -Raw
$pagesLess = Get-Content -LiteralPath (Join-Path $lessDir 'pages.less') -Raw
if ($archiveTpl -notmatch 'myjournal-archive' -or $pagesLess -notmatch '\.page-search' -or $pagesLess -notmatch '\.issue-summary') {
	Write-Host "[FAIL] search/archive inner-page styles missing"
	$failed = $true
} else {
	Write-Host "[OK] search + archive card layout"
}

if ($pagesLess -notmatch 'repeat\(5' -or $archiveTpl -notmatch 'myjournal-archive-sort' -or $php -notmatch 'setupArchiveListing') {
	Write-Host "[FAIL] archive 5-col grid or sort/year filter missing"
	$failed = $true
} else {
	Write-Host "[OK] archive 5-col + sort/year filter"
}

if ($pagesLess -notmatch '\.page-login' -or $pagesLess -notmatch '\.page-register') {
	Write-Host "[FAIL] login/register page styles missing"
	$failed = $true
} else {
	Write-Host "[OK] login/register card forms"
}

if ($localeEn -notmatch 'plugins\.themes\.myjournal\.themeDark') {
	Write-Host "[FAIL] EN locale missing themeDark"
	$failed = $true
} else {
	Write-Host "[OK] EN theme toggle strings"
}

if ($less -notmatch '#primaryNav \.dropdown-menu\.show' -or $less -notmatch 'display: block') {
	Write-Host "[FAIL] header.less missing vertical dropdown override"
	$failed = $true
} else {
	Write-Host "[OK] primary menu uses vertical dropdowns"
}

Write-Host ''
if ($failed) {
	Write-Host 'RESULT: FAILED'
	exit 1
}

Write-Host 'RESULT: PASSED'
Write-Host 'Next: follow PRODUCTION.md then ENABLE-AND-TEST.md (Health Sciences v1.1.3-1 required)'
exit 0
