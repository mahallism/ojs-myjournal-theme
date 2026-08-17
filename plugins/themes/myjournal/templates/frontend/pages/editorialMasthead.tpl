{**
 * plugins/themes/myjournal/templates/frontend/pages/editorialMasthead.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/pages/editorialMasthead.tpl (GPL v3)
 *
 * @brief Editorial masthead: full-width two-column people cards
 *}
{include file="frontend/components/header.tpl" pageTitle="common.editorialMasthead"}

{assign var="myjournalHasMastheadPeople" value=false}

{capture assign="myjournalOrcidIcon"}
<svg class="orcid-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="24" height="24" aria-hidden="true" focusable="false">
	<path fill="#A6CE39" d="M256 128c0 70.7-57.3 128-128 128S0 198.7 0 128 57.3 0 128 0s128 57.3 128 128z"/>
	<path fill="#fff" d="M86.3 186.2H70.9V79.1h15.4v107.1zM108.9 79.1h41.6c39.6 0 57 28.3 57 53.6 0 27.5-21.5 53.6-56.8 53.6h-41.8V79.1zm15.4 93.3h24.5c34.9 0 42.9-26.5 42.9-39.7 0-21.5-13.7-39.7-43.7-39.7h-23.7v79.4z"/>
	<circle fill="#fff" cx="78.6" cy="56.8" r="10.1"/>
</svg>
{/capture}

{function name=mjMastheadCard}
	<li>
		<span class="name">{$fullname|escape}</span>
		{if $aff != ''}
			<span class="affiliation">{$aff|escape}</span>
		{/if}
		{if $orcid != '' || $year != ''}
			<div class="user_listing-meta">
				{if $orcid != ''}
					<a class="orcid" href="{$orcid|escape}" target="_blank" rel="noopener noreferrer" aria-label="{translate key="common.editorialHistory.page.orcidLink" name=$fullname|escape}">
						{$myjournalOrcidIcon}
					</a>
				{else}
					<span class="orcid" aria-hidden="true"></span>
				{/if}
				{if $year != ''}
					<span class="date_start">{$year|escape}</span>
				{/if}
			</div>
		{/if}
	</li>
{/function}

<div class="container page page-masthead">
	<div class="page-header">
		<h1>{translate key="common.editorialMasthead"}</h1>
	</div>

	<div class="row">
		<div class="col-12">
			<div class="page-content">
				{capture assign="myjournalMastheadRolesHtml"}
					{foreach from=$mastheadRoles item="mastheadRole"}
						{if array_key_exists($mastheadRole->id, $mastheadUsers)}
							{assign var="myjournalHasMastheadPeople" value=true}
							<h2>{$mastheadRole->getLocalizedData('name')|escape}</h2>
							<ul class="user_listing" role="list">
							{foreach from=$mastheadUsers[$mastheadRole->id] item="mastheadUser"}
								{capture assign="mjYear"}{translate key="common.fromUntil" from=$mastheadUser['dateStart'] until=""}{/capture}
								{if $mastheadUser['user']->getData('orcid') && $mastheadUser['user']->hasVerifiedOrcid()}
									{assign var="mjOrcid" value=$mastheadUser['user']->getData('orcid')}
								{else}
									{assign var="mjOrcid" value=""}
								{/if}
								{mjMastheadCard
									fullname=$mastheadUser['user']->getFullName()
									aff=$mastheadUser['user']->getLocalizedData('affiliation')|default:''
									year=$mjYear
									orcid=$mjOrcid
								}
							{/foreach}
							</ul>
						{/if}
					{/foreach}
				{/capture}
				{$myjournalMastheadRolesHtml}

				{if !$myjournalHasMastheadPeople}
					<p class="myjournal-masthead-preview">{translate key="plugins.themes.myjournal.mastheadPreview"}</p>
					<h2>{translate key="plugins.themes.myjournal.mastheadEditors"}</h2>
					<ul class="user_listing" role="list">
						{mjMastheadCard fullname="Dr. Amina Rahmawati" aff="Universitas Brawijaya, Indonesia" year="2021–" orcid="https://orcid.org/0000-0001-2345-6780"}
						{mjMastheadCard fullname="Prof. Kenji Hartono" aff="Universitas Indonesia, Indonesia" year="2019–" orcid="https://orcid.org/0000-0001-2345-6781"}
						{mjMastheadCard fullname="Dr. Siti Nurhaliza Putri" aff="Universitas Gadjah Mada, Indonesia" year="2022–" orcid="https://orcid.org/0000-0001-2345-6782"}
						{mjMastheadCard fullname="Assoc. Prof. Maya Kusuma" aff="Universitas Airlangga, Indonesia" year="2020–" orcid="https://orcid.org/0000-0001-2345-6783"}
						{mjMastheadCard fullname="Prof. Dimas Prasetyo" aff="Institut Teknologi Bandung, Indonesia" year="2018–" orcid="https://orcid.org/0000-0001-2345-6784"}
						{mjMastheadCard fullname="Dr. Lestari Wulandari" aff="Universitas Diponegoro, Indonesia" year="2023–" orcid="https://orcid.org/0000-0001-2345-6785"}
						{mjMastheadCard fullname="Dr. Ahmad Fauzan" aff="Universitas Hasanuddin, Indonesia" year="2021–" orcid="https://orcid.org/0000-0001-2345-6786"}
						{mjMastheadCard fullname="Prof. Maria Christina Tan" aff="Universitas Padjadjaran, Indonesia" year="2017–" orcid="https://orcid.org/0000-0001-2345-6787"}
						{mjMastheadCard fullname="Dr. Yoga Mahendra Putra" aff="Universitas Sebelas Maret, Indonesia" year="2024–" orcid="https://orcid.org/0000-0001-2345-6788"}
						{mjMastheadCard fullname="Assoc. Prof. Nurul Aisyah" aff="Universitas Negeri Malang, Indonesia" year="2020–" orcid="https://orcid.org/0000-0001-2345-6789"}
					</ul>
					<h2>{translate key="plugins.themes.myjournal.mastheadBoard"}</h2>
					<ul class="user_listing" role="list">
						{mjMastheadCard fullname="Prof. Laila Wibowo" aff="Universitas Padjadjaran, Indonesia" year="2016–" orcid="https://orcid.org/0000-0002-2345-6780"}
						{mjMastheadCard fullname="Dr. Farhan Malik" aff="Universitas Hasanuddin, Indonesia" year="2019–" orcid="https://orcid.org/0000-0002-2345-6781"}
						{mjMastheadCard fullname="Dr. Rina Suryani" aff="Universitas Diponegoro, Indonesia" year="2021–" orcid="https://orcid.org/0000-0002-2345-6782"}
						{mjMastheadCard fullname="Prof. Andi Pratama" aff="Universitas Negeri Malang, Indonesia" year="2018–" orcid="https://orcid.org/0000-0002-2345-6783"}
						{mjMastheadCard fullname="Dr. Putri Anindita" aff="Universitas Brawijaya, Indonesia" year="2022–" orcid="https://orcid.org/0000-0002-2345-6784"}
						{mjMastheadCard fullname="Prof. Hiroshi Nakamura" aff="Kyoto University, Japan" year="2015–" orcid="https://orcid.org/0000-0002-2345-6785"}
						{mjMastheadCard fullname="Assoc. Prof. Sari Melati" aff="Universitas Gadjah Mada, Indonesia" year="2020–" orcid="https://orcid.org/0000-0002-2345-6786"}
						{mjMastheadCard fullname="Dr. Carlos Mendes" aff="Universidade de Lisboa, Portugal" year="2017–" orcid="https://orcid.org/0000-0002-2345-6787"}
						{mjMastheadCard fullname="Dr. Fitri Handayani" aff="Universitas Airlangga, Indonesia" year="2023–" orcid="https://orcid.org/0000-0002-2345-6788"}
						{mjMastheadCard fullname="Prof. Elena Petrova" aff="Lomonosov Moscow State University, Russia" year="2019–" orcid="https://orcid.org/0000-0002-2345-6789"}
					</ul>
				{/if}

				<p>
					{capture assign=editorialHistoryUrl}{url page="about" op="editorialHistory" router=\PKP\core\PKPApplication::ROUTE_PAGE}{/capture}
					{translate key="about.editorialMasthead.linkToEditorialHistory" url=$editorialHistoryUrl}
				</p>
				<hr>

				{assign var="myjournalHasReviewers" value=false}
				{capture assign="myjournalReviewersHtml"}
					{if $reviewers}
						{foreach from=$reviewers item="reviewer"}
							{assign var="myjournalHasReviewers" value=true}
							{if $reviewer->getData('orcid') && $reviewer->hasVerifiedOrcid()}
								{assign var="mjOrcid" value=$reviewer->getData('orcid')}
							{else}
								{assign var="mjOrcid" value=""}
							{/if}
							{mjMastheadCard
								fullname=$reviewer->getFullName()
								aff=$reviewer->getLocalizedData('affiliation')|default:''
								year=""
								orcid=$mjOrcid
							}
						{/foreach}
					{/if}
				{/capture}

				<h2>{translate key="common.editorialMasthead.peerReviewers"}</h2>
				<p>{translate key="common.editorialMasthead.peerReviewers.description" year=$previousYear}</p>
				<ul class="user_listing" role="list">
					{if $myjournalHasReviewers}
						{$myjournalReviewersHtml}
					{else}
						{mjMastheadCard fullname="Dr. Nadia Kartika" aff="Universitas Brawijaya, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6780"}
						{mjMastheadCard fullname="Prof. Budi Santoso" aff="Universitas Indonesia, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6781"}
						{mjMastheadCard fullname="Dr. Elena Wijaya" aff="Universitas Gadjah Mada, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6782"}
						{mjMastheadCard fullname="Dr. Hendra Gunawan" aff="Institut Teknologi Bandung, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6783"}
						{mjMastheadCard fullname="Assoc. Prof. Dewi Lestari" aff="Universitas Airlangga, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6784"}
						{mjMastheadCard fullname="Dr. Yosef Mahendra" aff="Universitas Sebelas Maret, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6785"}
						{mjMastheadCard fullname="Prof. Intan Permata" aff="Universitas Padjadjaran, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6786"}
						{mjMastheadCard fullname="Dr. Arif Rahman" aff="Universitas Hasanuddin, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6787"}
						{mjMastheadCard fullname="Dr. Mei Ling Chen" aff="National Taiwan University, Taiwan" year="" orcid="https://orcid.org/0000-0003-2345-6788"}
						{mjMastheadCard fullname="Assoc. Prof. Raden Bagus Wijaya" aff="Universitas Diponegoro, Indonesia" year="" orcid="https://orcid.org/0000-0003-2345-6789"}
					{/if}
				</ul>
				{if !$myjournalHasReviewers}
					<p class="myjournal-masthead-preview">{translate key="plugins.themes.myjournal.mastheadPreview"}</p>
				{/if}
			</div>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
