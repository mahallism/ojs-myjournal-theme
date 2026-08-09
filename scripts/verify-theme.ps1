# Verify My Journal child theme structure
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$theme = Join-Path $root 'plugins\themes\myjournal'

$required = @(
	'index.php',
	'version.xml',
	'MyJournalThemePlugin.php',
	'styles\custom.less',
	'templates\frontend\pages\indexJournal.tpl',
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
if ($php -notmatch "setParent\('defaultthemeplugin'\)") {
	Write-Host "[FAIL] setParent('defaultthemeplugin') not found"
	$failed = $true
} else {
	Write-Host "[OK] setParent(defaultthemeplugin)"
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

$tpl = Get-Content -LiteralPath (Join-Path $theme 'templates\frontend\pages\indexJournal.tpl') -Raw
if ($tpl -notmatch 'myjournal_homepage') {
	Write-Host "[FAIL] homepage override missing myjournal_homepage class"
	$failed = $true
} else {
	Write-Host "[OK] homepage template override"
}

Write-Host ''
if ($failed) {
	Write-Host 'RESULT: FAILED'
	exit 1
}

Write-Host 'RESULT: PASSED'
Write-Host 'Next: copy plugins/themes/myjournal into your OJS install, then follow ENABLE-AND-TEST.md'
exit 0
