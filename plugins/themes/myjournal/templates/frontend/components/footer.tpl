{**
 * plugins/themes/myjournal/templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2026 My Journal Theme
 * Based on Health Sciences templates/frontend/components/footer.tpl (GPL v3)
 *
 * @brief Closes main landmark opened in header.tpl, then site footer.
 *}
</main>

<footer class="site-footer">
	<div class="container site-footer-sidebar" role="complementary"
	     aria-label="{translate|escape key="common.navigation.sidebar"}">
		<div class="row">
			{call_hook name="Templates::Common::Sidebar"}
		</div>
	</div>
	<div class="container site-footer-content">
		<div class="row">
			{if $pageFooter}
				<div class="col-md site-footer-content align-self-center">
					{$pageFooter}
				</div>
			{/if}

			<div class="col-md col-md-2 align-self-center text-right" role="complementary">
				<a href="{url page="about" op="aboutThisPublishingSystem"}">
					<img class="footer-brand-image" alt="{translate key="about.aboutThisPublishingSystem"}"
					     src="{$baseUrl}/{$brandImage}">
				</a>
			</div>
		</div>
	</div>
</footer><!-- pkp_structure_footer_wrapper -->

<button type="button" class="myjournal-back-top" data-back-top hidden>
	<span class="visually-hidden">{translate key="plugins.themes.myjournal.backToTop"}</span>
	<svg class="myjournal-back-top__icon" width="20" height="20" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
		<path fill="currentColor" d="M12 4.5l-7 7 1.4 1.4L11 8.8V20h2V8.8l4.6 4.1L19 11.5z"/>
	</svg>
</button>

{* Load author biography modals if they exist *}
{if !empty($smarty.capture.authorBiographyModals|default:""|trim)}
	{$smarty.capture.authorBiographyModals}
{/if}

{* Login modal *}
<div id="loginModal" class="modal fade" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-body">
				<button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				{include file="frontend/components/loginForm.tpl" formType = "loginModal"}
			</div>
		</div>
	</div>
</div>

{load_script context="frontend" scripts=$scripts}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
