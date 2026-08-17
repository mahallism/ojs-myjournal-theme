<?php

/**
 * @file plugins/themes/myjournal/MyJournalThemePlugin.php
 *
 * Copyright (c) 2026 My Journal Theme
 * Distributed under the GNU GPL v3.
 *
 * @class MyJournalThemePlugin
 * @brief Child theme of the OJS 3.5 Health Sciences theme.
 */

namespace APP\plugins\themes\myjournal;

use APP\core\Application;
use APP\facades\Repo;
use APP\issue\Collector;
use APP\issue\Issue;
use APP\template\TemplateManager;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;

class MyJournalThemePlugin extends ThemePlugin
{
	/**
	 * Initialize the theme's styles, scripts and hooks.
	 * Only run for the currently active theme.
	 */
	public function init()
	{
		$this->setParent('healthsciencesthemeplugin');

		$this->addOption('accentColour', 'colour', [
			'label' => 'plugins.themes.myjournal.option.accentColour.label',
			'description' => 'plugins.themes.myjournal.option.accentColour.description',
			'default' => '#d9b800',
		]);

		$this->addOption('enableThemeToggle', 'radio', [
			'label' => 'plugins.themes.myjournal.option.enableThemeToggle.label',
			'description' => 'plugins.themes.myjournal.option.enableThemeToggle.description',
			'options' => [
				'1' => 'plugins.themes.myjournal.option.enableThemeToggle.yes',
				'0' => 'plugins.themes.myjournal.option.enableThemeToggle.no',
			],
			'default' => '1',
		]);

		$this->addOption('heroLabel', 'text', [
			'label' => 'plugins.themes.myjournal.option.heroLabel.label',
			'description' => 'plugins.themes.myjournal.option.heroText.description',
			'default' => '',
		]);

		$this->addOption('heroTitle', 'text', [
			'label' => 'plugins.themes.myjournal.option.heroTitle.label',
			'description' => 'plugins.themes.myjournal.option.heroText.description',
			'default' => '',
		]);

		$this->addOption('heroTagline', 'text', [
			'label' => 'plugins.themes.myjournal.option.heroTagline.label',
			'description' => 'plugins.themes.myjournal.option.heroText.description',
			'default' => '',
		]);

		$request = Application::get()->getRequest();
		$fontBase = $request->getBaseUrl() . '/' . $this->getPluginPath() . '/fonts';
		$accent = $this->getOption('accentColour');
		if (!preg_match('/^#[0-9a-fA-F]{1,6}$/', (string) $accent)) {
			$accent = '#d9b800';
		}

		$lessVariables = implode("\n", [
			'@font-sans: "Source Sans 3", "Source Sans Pro", system-ui, sans-serif;',
			'@font-serif: "Source Sans 3", "Source Sans Pro", system-ui, sans-serif;',
			'@mj-font-base: "' . $fontBase . '";',
			'@mj-gold: ' . $accent . ';',
			'@mj-gold-hover: lighten(@mj-gold, 8%);',
		]);

		$this->modifyStyle('stylesheet', [
			'addLessVariables' => $lessVariables,
			'addLess' => ['styles/custom.less'],
		]);

		// Drop parent HTML galley font pack (Fira/PT Serif); use self-hosted Source Sans
		$this->removeStyle('htmlFont');

		$this->addStyle('myjournalHtmlGalley', 'styles/htmlGalley.less', [
			'contexts' => 'htmlGalley',
			'addLessVariables' => '@mj-font-base: "' . $fontBase . '";',
		]);

		$this->addScript('myjournalTheme', 'js/theme.js');

		Hook::add('TemplateManager::display', [$this, 'setupArchiveListing']);

		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->assign([
			'myjournalLogoUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath() . '/images/logo-ijds.svg',
			'myjournalEnableThemeToggle' => (string) $this->getOption('enableThemeToggle') !== '0',
			'myjournalHeroLabel' => trim((string) $this->getOption('heroLabel')),
			'myjournalHeroTitle' => trim((string) $this->getOption('heroTitle')),
			'myjournalHeroTagline' => trim((string) $this->getOption('heroTagline')),
		]);
	}

	/**
	 * Sort/filter the issue archive (newest/oldest + year) without paging.
	 */
	public function setupArchiveListing(string $hookName, array $args): bool
	{
		$templateMgr = $args[0];
		$template = $args[1] ?? '';
		$templatePath = is_string($template) ? $template : '';
		if (!str_contains(str_replace('\\', '/', $templatePath), 'frontend/pages/issueArchive.tpl')) {
			return false;
		}

		$request = Application::get()->getRequest();
		$context = $request->getContext();
		if (!$context) {
			return false;
		}

		$sort = $request->getUserVar('sort') === 'oldest' ? 'oldest' : 'newest';
		$yearParam = trim((string) $request->getUserVar('year'));
		$year = ctype_digit($yearParam) ? (int) $yearParam : 0;

		$allIssues = Repo::issue()->getCollector()
			->filterByContextIds([$context->getId()])
			->filterByPublished(true)
			->orderBy(Collector::ORDERBY_DATE_PUBLISHED)
			->getMany()
			->toArray();

		$years = [];
		foreach ($allIssues as $issue) {
			$issueYear = $this->issueYear($issue);
			if ($issueYear) {
				$years[$issueYear] = $issueYear;
			}
		}
		rsort($years, SORT_NUMERIC);

		$issues = $allIssues;
		if ($year) {
			$issues = array_values(array_filter($allIssues, function ($issue) use ($year) {
				return $this->issueYear($issue) === $year;
			}));
		}
		if ($sort === 'oldest') {
			$issues = array_reverse($issues);
		}

		$templateMgr->assign([
			'issues' => $issues,
			'myjournalArchiveSort' => $sort,
			'myjournalArchiveYear' => $year,
			'myjournalArchiveYears' => $years,
			'nextPage' => null,
			'prevPage' => null,
			'showingStart' => $issues ? 1 : 0,
			'showingEnd' => count($issues),
			'total' => count($issues),
		]);

		return false;
	}

	private function issueYear(Issue $issue): int
	{
		$year = (int) $issue->getYear();
		if ($year > 0) {
			return $year;
		}
		$published = (string) $issue->getDatePublished();
		if ($published !== '' && preg_match('/^(\d{4})/', $published, $match)) {
			return (int) $match[1];
		}
		return 0;
	}

	/**
	 * Get the display name of this plugin.
	 */
	public function getDisplayName()
	{
		return __('plugins.themes.myjournal.name');
	}

	/**
	 * Get the description of this plugin.
	 */
	public function getDescription()
	{
		return __('plugins.themes.myjournal.description');
	}
}

if (!PKP_STRICT_MODE) {
	class_alias('\APP\plugins\themes\myjournal\MyJournalThemePlugin', '\MyJournalThemePlugin');
}
