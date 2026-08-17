/**
 * My Journal — theme toggle, search expand, HTML galley TOC, early theme attribute.
 */
(function () {
	var STORAGE_KEY = 'myjournal-theme';
	var root = document.documentElement;
	var tocObserver = null;

	function getPreferred() {
		try {
			var saved = localStorage.getItem(STORAGE_KEY);
			if (saved === 'dark' || saved === 'light') {
				return saved;
			}
		} catch (e) {}
		return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches
			? 'dark'
			: 'light';
	}

	function apply(theme) {
		root.setAttribute('data-theme', theme);
		try {
			localStorage.setItem(STORAGE_KEY, theme);
		} catch (e) {}
		syncButtons();
		syncGalleyFrame(theme);
	}

	function syncButtons() {
		var dark = root.getAttribute('data-theme') === 'dark';
		document.querySelectorAll('[data-theme-toggle]').forEach(function (btn) {
			btn.setAttribute('aria-pressed', dark ? 'true' : 'false');
			btn.setAttribute(
				'aria-label',
				dark
					? (btn.getAttribute('data-label-light') || 'Light mode')
					: (btn.getAttribute('data-label-dark') || 'Dark mode')
			);
			btn.classList.toggle('is-dark', dark);
		});
	}

	function syncGalleyFrame(theme) {
		var frame = document.querySelector('.myjournal-html-galley__frame');
		if (!frame) {
			return;
		}
		try {
			var doc = frame.contentDocument || (frame.contentWindow && frame.contentWindow.document);
			if (doc && doc.documentElement) {
				doc.documentElement.setAttribute('data-theme', theme);
				if (doc.body) {
					doc.body.setAttribute('data-theme', theme);
				}
			}
		} catch (e) {}
	}

	function escapeHtml(text) {
		return String(text)
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;');
	}

	function setActiveTocLink(id) {
		document.querySelectorAll('[data-galley-toc-list] .myjournal-html-galley__toc-link').forEach(function (link) {
			link.classList.toggle('is-active', link.getAttribute('data-toc-target') === id);
		});
	}

	function disconnectTocObserver() {
		if (tocObserver) {
			tocObserver.disconnect();
			tocObserver = null;
		}
	}

	function buildGalleyToc(frame) {
		var nav = document.querySelector('[data-galley-toc]');
		var list = document.querySelector('[data-galley-toc-list]');
		if (!nav || !list) {
			return;
		}

		disconnectTocObserver();
		list.innerHTML = '';
		nav.hidden = true;

		var doc;
		try {
			doc = frame.contentDocument || (frame.contentWindow && frame.contentWindow.document);
		} catch (e) {
			return;
		}
		if (!doc || !doc.body) {
			return;
		}

		var headings = doc.querySelectorAll('h1, h2, h3, h4');
		if (!headings.length) {
			return;
		}

		var usedIds = {};
		var observed = [];
		var html = '';

		headings.forEach(function (heading, index) {
			var text = (heading.textContent || '').replace(/\s+/g, ' ').trim();
			if (!text) {
				return;
			}

			var id = heading.id;
			if (!id || usedIds[id]) {
				id = 'mj-toc-' + (index + 1);
				heading.id = id;
			}
			usedIds[id] = true;

			var level = heading.tagName.toLowerCase();
			html +=
				'<li class="myjournal-html-galley__toc-item">' +
				'<a class="myjournal-html-galley__toc-link is-' +
				level +
				'" href="#' +
				encodeURIComponent(id) +
				'" data-toc-target="' +
				escapeHtml(id) +
				'">' +
				escapeHtml(text) +
				'</a></li>';
			observed.push(heading);
		});

		if (!html) {
			return;
		}

		list.innerHTML = html;
		nav.hidden = false;

		list.querySelectorAll('.myjournal-html-galley__toc-link').forEach(function (link) {
			link.addEventListener('click', function (event) {
				event.preventDefault();
				var targetId = link.getAttribute('data-toc-target');
				var target = doc.getElementById(targetId);
				if (!target) {
					return;
				}
				target.scrollIntoView({ behavior: 'smooth', block: 'start' });
				setActiveTocLink(targetId);
				try {
					link.focus({ preventScroll: true });
				} catch (e) {
					link.focus();
				}
			});
		});

		if (typeof frame.contentWindow.IntersectionObserver === 'function') {
			tocObserver = new frame.contentWindow.IntersectionObserver(
				function (entries) {
					var visible = entries
						.filter(function (entry) {
							return entry.isIntersecting;
						})
						.sort(function (a, b) {
							return a.boundingClientRect.top - b.boundingClientRect.top;
						});
					if (visible.length && visible[0].target && visible[0].target.id) {
						setActiveTocLink(visible[0].target.id);
					}
				},
				{
					root: null,
					rootMargin: '0px 0px -65% 0px',
					threshold: [0, 0.1, 1],
				}
			);
			observed.forEach(function (heading) {
				tocObserver.observe(heading);
			});
		}
	}

	if (!root.getAttribute('data-theme')) {
		apply(getPreferred());
	} else {
		syncButtons();
	}

	document.addEventListener('click', function (event) {
		var toggle = event.target.closest('[data-theme-toggle]');
		if (!toggle) {
			return;
		}
		event.preventDefault();
		apply(root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark');
	});

	document.addEventListener('click', function (event) {
		var openBtn = event.target.closest('[data-search-open]');
		if (!openBtn) {
			return;
		}
		var form = openBtn.closest('.myjournal-header__search');
		if (!form) {
			return;
		}
		var input = form.querySelector('.myjournal-header__search-input');
		var isOpen = form.classList.contains('is-open');
		var hasQuery = input && input.value && input.value.trim();
		if (!isOpen || !hasQuery) {
			event.preventDefault();
			form.classList.add('is-open');
			if (input) {
				input.focus();
			}
		}
	});

	document.addEventListener('focusout', function (event) {
		var form = event.target.closest && event.target.closest('.myjournal-header__search');
		if (!form) {
			return;
		}
		window.setTimeout(function () {
			if (!form.contains(document.activeElement)) {
				var input = form.querySelector('.myjournal-header__search-input');
				if (input && !input.value) {
					form.classList.remove('is-open');
				}
			}
		}, 0);
	});

	var galleyFrame = document.querySelector('.myjournal-html-galley__frame');
	if (galleyFrame) {
		galleyFrame.addEventListener('load', function () {
			syncGalleyFrame(root.getAttribute('data-theme') || getPreferred());
			buildGalleyToc(galleyFrame);
		});
	}
})();
