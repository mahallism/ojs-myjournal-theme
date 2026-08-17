{**
 * plugins/themes/myjournal/templates/frontend/components/navigationMenus/dashboardMenuItem.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences dashboardMenuItem.tpl (GPL v3)
 *
 * @brief User dashboard menu label: name + notification count as siblings
 *}
<span class="myjournal-user-name">{$navigationMenuItem->getLocalizedTitle()|escape}</span>
<span class="badge badge-light">{$unreadNotificationCount}</span>
