# My Journal — OJS 3.5 child theme

Child theme untuk **Open Journal Systems 3.5.0.3**, parent: **Health Sciences** (`healthsciencesthemeplugin` **v1.1.3-1**).

Dirancang sebagai child theme Health Sciences yang bisa dipakai banyak jurnal: brand colour, aksen, logo, dan hero diatur di **Appearance**. Default tetap navy SLDPI.

## Mulai cepat

1. [PREP.md](PREP.md) — backup & parent
2. [PRODUCTION.md](PRODUCTION.md) — checklist deploy produksi
3. Salin `plugins/themes/myjournal` ke OJS, enable **Accessible Theme** (nama di Plugins/Appearance; folder tetap `myjournal`)
4. [ENABLE-AND-TEST.md](ENABLE-AND-TEST.md) — regresi UI + a11y
5. [OVERRIDES.md](OVERRIDES.md) — file yang di-override (untuk upgrade)
6. Lokal Laragon: [LOCAL-OJS.md](LOCAL-OJS.md)

Di **Settings → Website → Appearance** (setelah tema dipilih):

- **Brand colour** — header, tautan, hero, footer (default `#112d52`)
- **Accent colour** — tombol kirim naskah + skip link (default `#d9b800`)
- **Page Header Logo** — logo jurnal; jika kosong, tema memakai `images/logo-ijds.svg`
- Teks hero, tombol dark mode
- Clear Data Caches + Template Cache setelah ganti warna

```powershell
powershell -File .\scripts\verify-theme.ps1
```

## Isi utama

| Path | Fungsi |
|------|--------|
| `MyJournalThemePlugin.php` | `setParent`, LESS/JS/galley, Theme Options |
| `styles/custom.less` | Entrypoint (`@import` tokens/header/hero/…) |
| `styles/htmlGalley.less` | Font/warna di iframe galley |
| `fonts/` | Source Sans 3 (self-hosted, SIL OFL) |
| `js/theme.js` | Dark mode, search icon, galley TOC |
| `templates/frontend/components/header.tpl` | Header + skip link + `<main>` |
| `templates/frontend/components/footer.tpl` | Tutup `</main>` + footer |
| `templates/frontend/pages/indexJournal.tpl` | Hero + issue homepage |
| `templates/frontend/objects/article_summary.tpl` | Kartu artikel TOC |
| `locale/en\|id/locale.po` | String tema + opsi Appearance |

## Versi

Lihat `plugins/themes/myjournal/version.xml` (saat ini **1.1.11.0**).

## Referensi

- [PKP Theming Guide](https://docs.pkp.sfu.ca/pkp-theming-guide/)
- [pkp/healthSciences](https://github.com/pkp/healthSciences)
