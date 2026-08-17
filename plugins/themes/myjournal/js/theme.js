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
		var frame = document.querySelector('.myjournal-html-galley__frame');
		if (frame) {
			window.setTimeout(function () {
				resizeGalleyFrame(frame);
			}, 50);
		}
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

	function galleyDoc(frame) {
		try {
			return frame.contentDocument || (frame.contentWindow && frame.contentWindow.document);
		} catch (e) {
			return null;
		}
	}

	function prefersReducedMotion() {
		return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
	}

	function scrollBehavior() {
		return prefersReducedMotion() ? 'auto' : 'smooth';
	}

	function resizeGalleyFrame(frame) {
		var doc = galleyDoc(frame);
		if (!doc || !doc.body) {
			return;
		}
		var height = Math.max(
			doc.body.scrollHeight,
			doc.documentElement ? doc.documentElement.scrollHeight : 0,
			doc.body.offsetHeight
		);
		frame.style.height = Math.max(height, 320) + 'px';
	}

	function headingViewportTop(frame, heading) {
		var frameRect = frame.getBoundingClientRect();
		var headingRect = heading.getBoundingClientRect();
		return frameRect.top + headingRect.top;
	}

	function scrollToGalleyHeading(frame, heading) {
		var header = document.querySelector('.myjournal-header');
		var offset = header ? header.getBoundingClientRect().height + 12 : 72;
		var top = window.scrollY + headingViewportTop(frame, heading) - offset;
		window.scrollTo({ top: Math.max(0, top), behavior: scrollBehavior() });
	}

	function updateTocFromPageScroll(frame, headings) {
		if (!headings.length) {
			return;
		}
		var header = document.querySelector('.myjournal-header');
		var offset = header ? header.getBoundingClientRect().height + 24 : 80;
		var current = headings[0];
		headings.forEach(function (heading) {
			if (headingViewportTop(frame, heading) - offset <= 0) {
				current = heading;
			}
		});
		if (current && current.id) {
			setActiveTocLink(current.id);
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

		var doc = galleyDoc(frame);
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
				scrollToGalleyHeading(frame, target);
				setActiveTocLink(targetId);
				try {
					link.focus({ preventScroll: true });
				} catch (e) {
					link.focus();
				}
			});
		});

		var onPageScroll = function () {
			updateTocFromPageScroll(frame, observed);
		};
		window.addEventListener('scroll', onPageScroll, { passive: true });
		tocObserver = {
			disconnect: function () {
				window.removeEventListener('scroll', onPageScroll);
			}
		};
		onPageScroll();
	}

	function setupBackToTop() {
		var btn = document.querySelector('[data-back-top]');
		if (!btn) {
			return;
		}
		var toggle = function () {
			var show = window.scrollY > 360;
			if (show) {
				btn.removeAttribute('hidden');
			} else {
				btn.setAttribute('hidden', '');
			}
		};
		window.addEventListener('scroll', toggle, { passive: true });
		toggle();
		btn.addEventListener('click', function () {
			window.scrollTo({ top: 0, behavior: scrollBehavior() });
		});
	}

	if (!root.getAttribute('data-theme')) {
		apply(getPreferred());
	} else {
		syncButtons();
	}

	setupBackToTop();

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
		var prepareGalley = function () {
			syncGalleyFrame(root.getAttribute('data-theme') || getPreferred());
			buildGalleyToc(galleyFrame);
			resizeGalleyFrame(galleyFrame);
			window.setTimeout(function () {
				resizeGalleyFrame(galleyFrame);
			}, 250);
		};
		galleyFrame.addEventListener('load', prepareGalley);
		window.addEventListener('resize', function () {
			resizeGalleyFrame(galleyFrame);
		});
		if (galleyFrame.contentDocument && galleyFrame.contentDocument.readyState === 'complete') {
			prepareGalley();
		}
	}
})();
