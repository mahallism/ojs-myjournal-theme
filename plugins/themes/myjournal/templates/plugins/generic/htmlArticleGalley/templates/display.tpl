{**
 * plugins/themes/myjournal/templates/plugins/generic/htmlArticleGalley/templates/display.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on htmlArticleGalley display.tpl and Health Sciences article page (GPL v3)
 *
 * @brief HTML galley view with site header/menu, TOC sidebar, and article metadata
 *}
{capture assign="pageTitleTranslated"}{translate key="article.pageTitle" title=$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitleTranslated}

{capture assign="articleUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
{if !$isLatestPublication}
	{capture assign="htmlUrl"}
		{url page="article" op="download" path=$article->getBestId()|to_array:'version':$galleyPublication->getId():$galley->getBestGalleyId():$submissionFile->getId() inline=true}
	{/capture}
{else}
	{capture assign="htmlUrl"}
		{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId():$submissionFile->getId() inline=true}
	{/capture}
{/if}

<div class="container page-article myjournal-html-galley">
	{include file="frontend/objects/article_details.tpl"}

	<section class="myjournal-html-galley__reader" aria-label="{translate key="plugins.themes.myjournal.htmlGalleyLabel"}">
		<div class="myjournal-html-galley__reader-head">
			<h2 class="myjournal-html-galley__reader-title">{translate key="plugins.themes.myjournal.htmlGalleyLabel"}</h2>
			<a class="myjournal-html-galley__back" href="{$articleUrl}">
				{translate key="plugins.themes.myjournal.htmlGalleyBack"}
			</a>
		</div>

		{if !$isLatestPublication}
			<div class="alert alert-primary myjournal-html-galley__notice" role="alert">
				{translate key="submission.outdatedVersion"
					datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong
					urlRecentVersion=$articleUrl
				}
			</div>
		{/if}

		<div class="myjournal-html-galley__body">
			<nav
				class="myjournal-html-galley__toc"
				data-galley-toc
				hidden
				aria-label="{translate key="plugins.themes.myjournal.htmlGalleyToc"}"
			>
				<details class="myjournal-html-galley__toc-details" open>
					<summary class="myjournal-html-galley__toc-summary">
						{translate key="plugins.themes.myjournal.htmlGalleyToc"}
					</summary>
					<ol class="myjournal-html-galley__toc-list" data-galley-toc-list></ol>
				</details>
			</nav>

			<div class="myjournal-html-galley__frame-wrap">
				<iframe
					class="myjournal-html-galley__frame"
					name="htmlFrame"
					src="{$htmlUrl}"
					title="{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$galleyPublication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}"
					allowfullscreen
					webkitallowfullscreen
				></iframe>
			</div>
		</div>
	</section>
</div>

{include file="frontend/components/footer.tpl"}
