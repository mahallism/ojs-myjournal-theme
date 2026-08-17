# Template & asset overrides — My Journal

Track these when upgrading OJS or Health Sciences. Paths are relative to `plugins/themes/myjournal/`.

| Override | Parent / source | Purpose |
|----------|-----------------|--------|
| `templates/frontend/components/header.tpl` | Health Sciences `header.tpl` | Sticky navy header, logo, icon search, optional theme toggle, skip link |
| `templates/frontend/components/footer.tpl` | Health Sciences `footer.tpl` | Closes `<main id="myjournal-main">` opened in header |
| `templates/frontend/pages/editorialMasthead.tpl` | Health Sciences `editorialMasthead.tpl` | Full-width two-column editors/board/reviewers |
| `templates/frontend/objects/article_summary.tpl` | Health Sciences `article_summary.tpl` | Card layout (title → authors → pages/galleys) |
| `templates/plugins/generic/htmlArticleGalley/templates/display.tpl` | HTML Galley plugin | Site chrome + article metadata + iframe + heading TOC |
| `styles/custom.less` | (added via `modifyStyle`) | Entrypoint `@import` for split LESS |
| `styles/fonts.less` | (new) | Self-hosted Source Sans 3 `@font-face` |
| `styles/tokens.less` | (new) | Brand tokens, type, skip-link |
| `styles/header.less` | (new) | Sticky header |
| `styles/hero.less` | (new) | Homepage hero |
| `styles/pages.less` | (new) | Search, archive, article, about/submissions, login/register |
| `styles/galley.less` | (new) | HTML galley reader + sticky TOC sidebar |
| `styles/dark.less` | (new) | Dark-mode surfaces and hover contrast |
| `styles/htmlGalley.less` | replaces parent `htmlFont` | Source Sans 3 + dark-friendly galley body |
| `js/theme.js` | (new) | Theme toggle, search expand, galley theme sync + TOC |
| `fonts/*.woff2` | Adobe Source Sans 3 | Self-hosted webfonts (SIL OFL 1.1; see `fonts/OFL.txt`) |
| `images/logo-ijds.svg` | (new) | Journal logo |
| `locale/en/locale.po`, `locale/id/locale.po` | (new keys) | Hero, a11y, theme labels, Appearance options |

## Parent dependency

- Plugin name: `healthsciencesthemeplugin`
- Compatible release for OJS 3.5.0.3: **v1.1.3-1**
- Child removes parent style `htmlFont` and registers `myjournalHtmlGalley` instead
- Appearance: **Brand colour** (header/links/hero/footer), accent colour, dark-mode toggle, hero label/title/tagline. Page Header Logo in Appearance overrides the bundled SVG. Health Sciences’ own colour picker is superseded by Brand colour.
