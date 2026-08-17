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
	private const BRAND_DEFAULT = '#112d52';
	private const ACCENT_DEFAULT = '#d9b800';

	/**
	 * Initialize the theme's styles, scripts and hooks.
	 * Only run for the currently active theme.
	 */
	public function init()
	{
		$this->setParent('healthsciencesthemeplugin');

		$this->addOption('brandColour', 'colour', [
			'label' => 'plugins.themes.myjournal.option.baseColour.label',
			'description' => 'plugins.themes.myjournal.option.baseColour.description',
			'default' => self::BRAND_DEFAULT,
		]);

		$this->addOption('accentColour', 'colour', [
			'label' => 'plugins.themes.myjournal.option.accentColour.label',
			'description' => 'plugins.themes.myjournal.option.accentColour.description',
			'default' => self::ACCENT_DEFAULT,
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
		$lessVariables = $this->brandLessVariables($fontBase);

		$this->modifyStyle('stylesheet', [
			'addLessVariables' => $lessVariables,
			'addLess' => ['styles/custom.less'],
		]);

		// Drop parent HTML galley font pack (Fira/PT Serif); use self-hosted Source Sans
		$this->removeStyle('htmlFont');

		$this->addStyle('myjournalHtmlGalley', 'styles/htmlGalley.less', [
			'contexts' => 'htmlGalley',
			'addLessVariables' => $lessVariables,
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
	 * Resolve Appearance colours into LESS variables (header, tokens, HTML galley).
	 */
	private function brandLessVariables(string $fontBase): string
	{
		$brand = $this->sanitiseHex($this->getOption('brandColour'), self::BRAND_DEFAULT);
		$accent = $this->sanitiseHex($this->getOption('accentColour'), self::ACCENT_DEFAULT);

		$headerInk = $this->isColourDark($brand) ? '#ffffff' : '#142033';
		$accentInk = $this->isColourDark($accent) ? '#ffffff' : '#0a1a33';
		$logoFilter = $this->isColourDark($brand)
			? '~"brightness(0) invert(1)"'
			: '~"none"';

		// Keep IJDS turquoise when brand is the default navy; otherwise derive from brand.
		$useDefaultDarkAccent = strcasecmp($brand, self::BRAND_DEFAULT) === 0;

		return implode("\n", [
			'@font-sans: "Source Sans 3", "Source Sans Pro", system-ui, sans-serif;',
			'@font-serif: "Source Sans 3", "Source Sans Pro", system-ui, sans-serif;',
			'@mj-font-base: "' . $fontBase . '";',
			'@mj-brand-colour: ' . $brand . ';',
			'@primary: @mj-brand-colour;',
			'@mj-gold: ' . $accent . ';',
			'@mj-gold-hover: lighten(@mj-gold, 8%);',
			'@mj-accent-ink: ' . $accentInk . ';',
			'@header-ink: ' . $headerInk . ';',
			'@header-logo-filter: ' . $logoFilter . ';',
			'@mj-dark-accent: ' . ($useDefaultDarkAccent ? '#7ed4c8' : 'lighten(@primary, 42%)') . ';',
			'@mj-dark-accent-hover: ' . ($useDefaultDarkAccent ? '#a8ebe3' : 'lighten(@primary, 52%)') . ';',
		]);
	}

	private function sanitiseHex(mixed $value, string $fallback): string
	{
		$value = trim((string) $value);
		if (preg_match('/^#[0-9a-fA-F]{3}$/', $value)) {
			return sprintf('#%s%s%s%s%s%s', $value[1], $value[1], $value[2], $value[2], $value[3], $value[3]);
		}
		if (preg_match('/^#[0-9a-fA-F]{6}$/', $value)) {
			return $value;
		}
		return $fallback;
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
