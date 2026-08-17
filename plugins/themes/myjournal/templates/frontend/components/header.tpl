{**
 * plugins/themes/myjournal/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/components/header.tpl (GPL v3)
 *
 * @brief Site header: logo, primary menu, then tools (search icon, theme, language, user)
 *}
{capture assign="homeUrl"}
	{url page="index" router=$smarty.const.ROUTE_PAGE}
{/capture}

{if $requestedOp == 'index'}
	{assign var="siteNameTag" value="h1"}
{else}
	{assign var="siteNameTag" value="div"}
{/if}

{capture assign="brand"}{strip}
	{if $displayPageHeaderLogo}
		<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}"
		     {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"
		     {else}alt="{translate key="common.pageHeaderLogo.altText"}"{/if}
		     class="myjournal-header__logo-img">
	{elseif $myjournalLogoUrl}
		<img src="{$myjournalLogoUrl|escape}" alt="{if $currentContext}{$currentContext->getLocalizedName()|escape}{else}{$applicationName|escape}{/if}" class="myjournal-header__logo-img" width="256" height="52">
	{elseif $displayPageHeaderTitle}
		<span class="navbar-logo-text">{$displayPageHeaderTitle|escape}</span>
	{else}
		<span class="navbar-logo-text">{$applicationName|escape}</span>
	{/if}
{/strip}{/capture}

<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
<script>
(function () {
	try {
		var saved = localStorage.getItem('myjournal-theme');
		var theme = saved || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
		document.documentElement.setAttribute('data-theme', theme);
	} catch (e) {
		document.documentElement.setAttribute('data-theme', 'light');
	}
})();
</script>
{include file="frontend/components/headerHead.tpl"}
<body dir="{$currentLocaleLangDir|escape|default:"ltr"}">

<a class="myjournal-skip" href="#myjournal-main">{translate key="plugins.themes.myjournal.skipToContent"}</a>

<header class="main-header myjournal-header">
	<div class="container myjournal-header__bar">
		<{$siteNameTag} class="visually-hidden">{$pageTitleTranslated|escape}</{$siteNameTag}>

		<nav class="navbar navbar-expand-lg navbar-light myjournal-header__nav" aria-label="{translate key="plugins.themes.myjournal.siteNav"}">
			<a class="myjournal-header__logo" href="{$homeUrl}">{$brand}</a>
			<button class="navbar-toggler myjournal-header__toggler" type="button" data-bs-toggle="collapse" data-bs-target="#main-navbar"
			        aria-controls="main-navbar" aria-expanded="false"
			        aria-label="{translate key="plugins.themes.myjournal.navToggle"}">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse myjournal-header__collapse" id="main-navbar">
				{capture assign="primaryMenu"}
					{load_menu name="primary" id="primaryNav" ulClass="navbar-nav myjournal-header__menu" liClass="nav-item"}
				{/capture}
				{if !empty(trim($primaryMenu)) || $currentContext}
					{$primaryMenu}
				{/if}

				<div class="myjournal-header__tools">
					<form class="myjournal-header__search" role="search" method="get" action="{url page="search"}">
						<label class="visually-hidden" for="myjournal-header-search">{translate key="common.search"}</label>
						<input class="myjournal-header__search-input" type="search" id="myjournal-header-search" name="query" value="{$query|escape}" placeholder="{translate key="common.search"}">
						<button class="myjournal-header__search-submit" type="submit" aria-label="{translate key="common.search"}" data-search-open>
							<svg class="myjournal-header__icon" width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path fill="currentColor" d="M15.5 14h-.79l-.28-.27A6.47 6.47 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
							</svg>
						</button>
					</form>

					{if $myjournalEnableThemeToggle}
						<button
							type="button"
							class="myjournal-header__theme"
							data-theme-toggle
							data-label-dark="{translate key="plugins.themes.myjournal.themeDark"}"
							data-label-light="{translate key="plugins.themes.myjournal.themeLight"}"
							aria-pressed="false"
							aria-label="{translate key="plugins.themes.myjournal.themeDark"}"
						>
							<svg class="myjournal-header__icon myjournal-header__icon--moon" width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path fill="currentColor" d="M12.1 22c-5.05 0-9.1-4.05-9.1-9.1 0-4.1 2.7-7.6 6.5-8.75.5-.15.95.35.75.82A7.1 7.1 0 0 0 18.9 14c.5-.2 1 .25.85.75C18.65 19.05 15.5 22 12.1 22z"/>
							</svg>
							<svg class="myjournal-header__icon myjournal-header__icon--sun" width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
								<path fill="currentColor" d="M6.76 4.84l-1.8-1.79-1.41 1.41 1.79 1.8 1.42-1.42zM1 13h3v-2H1v2zm10 10h2v-3h-2v3zm9-10v-2h-3v2h3zm-2.05-6.54l1.41-1.41-1.79-1.8-1.41 1.42 1.79 1.79zM13 1h-2v3h2V1zm0 9a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm5.24 8.16l1.79 1.8 1.41-1.41-1.8-1.79-1.4 1.4zM4.96 18.36l-1.8 1.79 1.41 1.41 1.8-1.79-1.41-1.41zM12 6a6 6 0 1 1 0 12A6 6 0 0 1 12 6z"/>
							</svg>
						</button>
					{/if}

					{include file="frontend/components/languageSwitcher.tpl" id="languageHeaderNav"}
					{load_menu name="user" id="userNav" ulClass="navbar-nav myjournal-header__user" liClass="nav-item"}
				</div>
			</div>
		</nav>
	</div>
</header>

<main id="myjournal-main" class="myjournal-main" tabindex="-1">
