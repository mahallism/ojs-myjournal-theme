<?php

/**
 * @file plugins/themes/myjournal/MyJournalThemePlugin.php
 *
 * Copyright (c) 2026 My Journal Theme
 * Distributed under the GNU GPL v3.
 *
 * @class MyJournalThemePlugin
 * @brief Child theme of the OJS default theme.
 */

namespace APP\plugins\themes\myjournal;

use PKP\plugins\ThemePlugin;

class MyJournalThemePlugin extends ThemePlugin
{
	/**
	 * Initialize the theme's styles, scripts and hooks.
	 * Only run for the currently active theme.
	 */
	public function init()
	{
		$this->setParent('defaultthemeplugin');
		$this->modifyStyle('stylesheet', ['addLess' => ['styles/custom.less']]);
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
