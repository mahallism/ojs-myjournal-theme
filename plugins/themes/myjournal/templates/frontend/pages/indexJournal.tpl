{**
 * plugins/themes/myjournal/templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on OJS templates/frontend/pages/indexJournal.tpl (GPL v3)
 *
 * @brief Journal homepage override for My Journal child theme
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal myjournal_homepage">

	{call_hook name="Templates::Index::journal"}

	<div class="myjournal_homepage_intro">
		<span class="myjournal_homepage_intro__label">{translate key="plugins.themes.myjournal.homepageLabel"}</span>
		<h1 class="myjournal_homepage_intro__title">{$currentJournal->getLocalizedName()|escape}</h1>
	</div>

	{if $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{if $activeTheme && !$activeTheme->getOption('useHomepageImageAsHeader') && $homepageImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}

	{if $categories && $categories->count() > 0}
		{include file="frontend/components/categoryHeader.tpl" categories=$categories}
	{/if}

	{* Journal Description *}
	{if $activeTheme && $activeTheme->getOption('showDescriptionInJournalIndex')}
		<section class="homepage_about">
			<a id="homepageAbout"></a>
			<h2>{translate key="about.aboutContext"}</h2>
			{$currentContext->getLocalizedData('description')}
		</section>
	{/if}

	{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

	{* Latest Published Publications *}
	{if $publishedPublications && $publishedPublications->count()}
		{include file="frontend/objects/latest_article.tpl" articles=$publishedPublications heading="h2"}
	{/if}

	{* Latest issue *}
	{if $issue}
		<section class="current_issue">
			<a id="homepageIssue"></a>
			<h2>
				{translate key="journal.currentIssue"}
			</h2>
			<div class="current_issue_title">
				{$issue->getIssueIdentification()|escape}
			</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="read_more">
				{translate key="journal.viewAllIssues"}
			</a>
		</section>
	{/if}

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
