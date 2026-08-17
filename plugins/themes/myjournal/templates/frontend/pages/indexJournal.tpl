{**
 * plugins/themes/myjournal/templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/pages/indexJournal.tpl (GPL v3)
 *
 * @brief Journal homepage: SLDPI-styled hero plus Health Sciences issue layout
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<section class="myjournal-hero" aria-labelledby="myjournal-hero-title">
	<div class="container">
		<div class="myjournal-hero__inner">
			<p class="myjournal-hero__label">{if $myjournalHeroLabel}{$myjournalHeroLabel|escape}{else}{translate key="plugins.themes.myjournal.heroLabel"}{/if}</p>
			<p class="myjournal-hero__title" id="myjournal-hero-title">{if $myjournalHeroTitle}{$myjournalHeroTitle|escape}{else}{translate key="plugins.themes.myjournal.heroTitle"}{/if}</p>
			<p class="myjournal-hero__tagline">{if $myjournalHeroTagline}{$myjournalHeroTagline|escape}{else}{translate key="plugins.themes.myjournal.heroTagline"}{/if}</p>
			<div class="myjournal-hero__actions">
				<a class="myjournal-hero__btn myjournal-hero__btn--primary" href="{url page="about" op="submissions"}">
					{translate key="plugins.themes.myjournal.heroSubmit"}
				</a>
				{if $issue}
					<a class="myjournal-hero__btn myjournal-hero__btn--ghost" href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
						{translate key="plugins.themes.myjournal.heroCurrentIssue"}
					</a>
				{/if}
			</div>
		</div>
	</div>
</section>

{if $homepageImage}
	<div class="homepage-image{if $issue} homepage-image-behind-issue{/if}">
		<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="{$homepageImageAltText|escape}">
	</div>
{/if}

<div class="container container-homepage-issue page-content">
	{if $issue}
		<div class="myjournal-issue-kicker">
			<h2 class="h5 homepage-issue-current">
				{translate key="journal.currentIssue"}
			</h2>
			<div class="h1 homepage-issue-identifier">
				{$issue->getIssueSeries()|escape}
			</div>
			<div class="h6 homepage-issue-published">
				{translate key="plugins.themes.healthSciences.currentIssuePublished" date=$issue->getDatePublished()|date_format:$dateFormatLong}
			</div>
		</div>

		{if $issue->getLocalizedCoverImageUrl() || $issue->hasDescription() || $issueGalleys}
			<div class="row justify-content-center homepage-issue-header">
				{if $issue->getLocalizedCoverImageUrl()}
					<div class="col-lg-3">
						<a href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
							<img class="img-fluid homepage-issue-cover" src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText() != ''} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
						</a>
					</div>
				{/if}
				{if $issue->hasDescription() || $journalDescription || $issueGalleys}
					<div class="col-lg-9">
						<div class="homepage-issue-description-wrapper">
							{if $issue->hasDescription()}
								<div class="homepage-issue-description">
									<div class="h2">
										{if $issue->getLocalizedTitle()}
											{$issue->getLocalizedTitle()|escape}
										{else}
											{translate key="plugins.themes.healthSciences.issueDescription"}
										{/if}
									</div>
									{$issue->getLocalizedDescription()|strip_unsafe_html}
									<div class="homepage-issue-description-more">
										<a class="btn btn-primary myjournal-more-btn" href="{url op="view" page="issue" path=$issue->getBestIssueId()}">{translate key="common.more"}</a>
									</div>
								</div>
							{elseif $journalDescription}
								<div class="homepage-journal-description long-text" id="homepageDescription">
									{$journalDescription|strip_unsafe_html}
								</div>
								<div class="homepage-description-buttons hidden" id="homepageDescriptionButtons">
									<a class="homepage-journal-description-more hidden" id="homepageDescriptionMore">{translate key="common.more"}</a>
									<a class="homepage-journal-description-less hidden" id="homepageDescriptionLess">{translate key="common.less"}</a>
								</div>
							{/if}
							{if $issueGalleys}
								<div class="homepage-issue-galleys">
									<div class="h3">
										{translate key="issue.fullIssue"}
									</div>
									{foreach from=$issueGalleys item=galley}
										{include file="frontend/objects/galley_link.tpl" parent=$issue purchaseFee=$currentJournal->getSetting('purchaseIssueFee') purchaseCurrency=$currentJournal->getSetting('currency')}
									{/foreach}
								</div>
							{/if}
						</div>
					</div>
				{/if}
			</div>
		{/if}

	{/if}

	{if $issue}
		<div class="row issue-wrapper{if $homepageImage && $issue->hasDescription()} issue-full-data{elseif $homepageImage && $issue->getLocalizedCoverImageUrl()} issue-image-cover{elseif $homepageImage} issue-only-image{/if}">
			<div class="col-12">
				{include file="frontend/objects/issue_toc.tpl" sectionHeading="h3"}
			</div>
		</div>

		<div class="myjournal-view-all-issues">
			<a class="btn" href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}">
				{translate key="journal.viewAllIssues"}
			</a>
		</div>
	{/if}

	{if $numAnnouncementsHomepage && $announcements|@count}
	<section class="myjournal-announcements" aria-labelledby="myjournal-announcements-heading">
		<h2 class="myjournal-announcements__heading" id="myjournal-announcements-heading">{translate key="announcement.announcementsHome"}</h2>
		<div class="row myjournal-announcements__grid">
			{foreach from=$announcements item=announcement}
				<div class="col-md-4">
					<article class="myjournal-announcement-card">
						<h3 class="myjournal-announcement-card__title">
							<a href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->id}">
								{$announcement->getLocalizedData('title')|escape}
							</a>
						</h3>
						<p class="myjournal-announcement-card__excerpt">{$announcement->getLocalizedData('descriptionShort')|strip_unsafe_html}</p>
						<footer class="myjournal-announcement-card__footer">
							<small class="myjournal-announcement-card__date">{$announcement->datePosted|date_format:$dateFormatLong}</small>
							<a class="myjournal-announcement-card__more" href="{url router=$smarty.const.ROUTE_PAGE page="announcement" op="view" path=$announcement->id}">
								{translate key="common.more"}
							</a>
						</footer>
					</article>
				</div>
			{/foreach}
		</div>
	</section>
	{/if}

	{if $additionalHomeContent}
		<div class="row justify-content-center homepage-additional-content">
			<div class="col-lg-9">{$additionalHomeContent}</div>
		</div>
	{/if}
</div><!-- .container -->

{include file="frontend/components/footer.tpl"}
