{**
 * plugins/themes/myjournal/templates/frontend/pages/issueArchive.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/pages/issueArchive.tpl (GPL v3)
 *
 * @brief Issue archive: five-column cards, newest/oldest sort, year filter
 *}
{capture assign="pageTitle"}
	{if $prevPage}
		{translate key="archive.archivesPageNumber" pageNumber=$prevPage+1}
	{else}
		{translate key="archive.archives"}
	{/if}
{/capture}
{include file="frontend/components/header.tpl" pageTitleTranslated=$pageTitle}

{if !$myjournalArchiveSort}{assign var="myjournalArchiveSort" value="newest"}{/if}
{if !$myjournalArchiveYear}{assign var="myjournalArchiveYear" value=0}{/if}
{capture assign="archiveUrl"}{url page="issue" op="archive"}{/capture}

<div class="container page-archives">
	<div class="page-header page-archives-header">
		<h1>{$pageTitle|escape}</h1>
	</div>

	{if empty($issues) && !$myjournalArchiveYear}
		<div class="page-header page-issue-header">
			{include file="frontend/components/notification.tpl" messageKey="current.noCurrentIssueDesc"}
		</div>
	{else}
		{capture assign="archiveNewestUrl"}{$archiveUrl|escape}?sort=newest{if $myjournalArchiveYear}&amp;year={$myjournalArchiveYear|escape}{/if}{/capture}
		{capture assign="archiveOldestUrl"}{$archiveUrl|escape}?sort=oldest{if $myjournalArchiveYear}&amp;year={$myjournalArchiveYear|escape}{/if}{/capture}

		<div class="myjournal-archive-toolbar">
			<div class="myjournal-archive-sort" role="group" aria-label="{translate key="plugins.themes.myjournal.archiveSortLabel"}">
				<a
					class="myjournal-archive-sort__btn{if $myjournalArchiveSort != 'oldest'} is-active{/if}"
					href="{$archiveNewestUrl}"
					{if $myjournalArchiveSort != 'oldest'}aria-current="true"{/if}
				>
					{translate key="plugins.themes.myjournal.archiveSortNewest"}
				</a>
				<a
					class="myjournal-archive-sort__btn{if $myjournalArchiveSort == 'oldest'} is-active{/if}"
					href="{$archiveOldestUrl}"
					{if $myjournalArchiveSort == 'oldest'}aria-current="true"{/if}
				>
					{translate key="plugins.themes.myjournal.archiveSortOldest"}
				</a>
			</div>

			<form class="myjournal-archive-year" method="get" action="{$archiveUrl|escape}">
				<input type="hidden" name="sort" value="{$myjournalArchiveSort|escape}">
				<label class="myjournal-archive-year__label" for="myjournal-archive-year">
					{translate key="plugins.themes.myjournal.archiveYearLabel"}
				</label>
				<select class="myjournal-archive-year__select" id="myjournal-archive-year" name="year" onchange="this.form.submit()">
					<option value=""{if !$myjournalArchiveYear} selected{/if}>
						{translate key="plugins.themes.myjournal.archiveYearAll"}
					</option>
					{foreach from=$myjournalArchiveYears item=archiveYear}
						<option value="{$archiveYear|escape}"{if $myjournalArchiveYear == $archiveYear} selected{/if}>
							{$archiveYear|escape}
						</option>
					{/foreach}
				</select>
				<button class="myjournal-archive-year__submit" type="submit">
					{translate key="plugins.themes.myjournal.archiveApply"}
				</button>
			</form>
		</div>

		{if empty($issues)}
			<p class="myjournal-archive-empty">{translate key="plugins.themes.myjournal.archiveEmptyYear"}</p>
		{else}
			<div class="myjournal-archive">
				{foreach $issues as $issue}
					{include file="frontend/objects/issue_summary.tpl" heading="h2"}
				{/foreach}
			</div>
		{/if}
	{/if}
</div>

{include file="frontend/components/footer.tpl"}
