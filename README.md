# My Journal — OJS 3 child theme

Child theme untuk **Open Journal Systems 3.4+**, parent: `defaultthemeplugin`.

Struktur siap salin ke `plugins/themes/myjournal/` di instalasi OJS Anda.

## Isi

| Path | Fungsi |
|------|--------|
| `plugins/themes/myjournal/index.php` | Bootstrap plugin |
| `plugins/themes/myjournal/version.xml` | Metadata versi |
| `plugins/themes/myjournal/MyJournalThemePlugin.php` | Class theme (`setParent` + `modifyStyle`) |
| `plugins/themes/myjournal/styles/custom.less` | Override warna & gaya |
| `plugins/themes/myjournal/templates/frontend/pages/indexJournal.tpl` | Override homepage |
| `plugins/themes/myjournal/locale/en/locale.po` | String EN |
| `plugins/themes/myjournal/locale/id/locale.po` | String ID |

## Mulai cepat

1. Baca [PREP.md](PREP.md) (backup & asumsi versi).
2. Salin `plugins/themes/myjournal` ke OJS.
3. Ikuti [ENABLE-AND-TEST.md](ENABLE-AND-TEST.md).

## Referensi

- [PKP Theming Guide](https://docs.pkp.sfu.ca/pkp-theming-guide/)
- [pkp/defaultChild](https://github.com/pkp/defaultChild)
