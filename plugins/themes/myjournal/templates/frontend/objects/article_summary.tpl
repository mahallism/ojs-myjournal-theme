{**
 * plugins/themes/myjournal/templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/objects/article_summary.tpl (GPL v3)
 *
 * @brief Article summary as a card: title, authors, pages left / galleys right
 *}
{assign var="articlePath" value=$article->getBestId()}
{assign var="publication" value=$article->getCurrentPublication()}

{if (!$section.hideAuthor && $publication->getData('hideAuthor') == \APP\submission\Submission::AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == \APP\submission\Submission::AUTHOR_TOC_SHOW}
	{assign var="showAuthor" value=true}
{/if}

{assign var="submissionPages" value=$publication->getData('pages')}
{assign var="submissionDatePublished" value=$publication->getData('datePublished')}
{assign var="galleys" value=$article->getGalleys()}

<div class="article-summary">
	<div class="article-summary-title">
		<a {if $journal}href="{url journal=$journal->getPath() page="article" op="view" path=$articlePath}"{else}href="{url page="article" op="view" path=$articlePath}"{/if}>
			{$publication->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}
		</a>
	</div>

	{if $showAuthor}
		<div class="article-summary-authors">{$publication->getAuthorString($authorUserGroups)|escape}</div>
	{/if}

	{if $showDatePublished && $submissionDatePublished}
		<div class="article-summary-date">
			{$submissionDatePublished|date_format:$dateFormatLong}
		</div>
	{/if}

	{* Get DOI from DOIPubIdPlugin object *}
	{if $requestedPage === 'issue'}
		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{if $pubIdPlugin->getPubIdType() != 'doi'}
				{continue}
			{/if}
			{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
			{if $pubId}
				{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				<div class="article-summary-doi">
					<a href="{$doiUrl}">{$doiUrl}</a>
				</div>
			{/if}
		{/foreach}
	{* Get DOI from PublishedArticle object ($pubIdPlugin isn't assigned to indexJournal template) *}
	{elseif ($requestedPage === "search" || $requestedPage === "catalog") && $article->getStoredPubId('doi')}
		{assign var="doiUrl" value=$article->getStoredPubId('doi')|substr_replace:'https://doi.org/':0:0|escape}
		{if $doiUrl}
			<div class="article-summary-doi">
				<a href="{$doiUrl}">{$doiUrl}</a>
			</div>
		{/if}
	{/if}

	{if $submissionPages || (!$hideGalleys && $galleys)}
		<div class="article-summary-footer">
			<div class="article-summary-pages">
				{if $submissionPages}{$submissionPages|escape}{/if}
			</div>
			{if !$hideGalleys && $galleys}
				<div class="article-summary-galleys">
					{foreach from=$galleys item=galley}
						{if $primaryGenreIds}
							{assign var="file" value=$galley->getFile()}
							{if !$galley->getData('urlRemote') && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
								{continue}
							{/if}
						{/if}
						{assign var="hasArticleAccess" value=$hasAccess}
						{if $currentContext->getSetting('publishingMode') == \APP\journal\Journal::PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == \APP\submission\Submission::ARTICLE_ACCESS_OPEN}
							{assign var="hasArticleAccess" value=1}
						{/if}
						{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication hasAccess=$hasArticleAccess}
					{/foreach}
				</div>
			{/if}
		</div>
	{/if}

	{call_hook name="Templates::Issue::Issue::Article"}
</div>
