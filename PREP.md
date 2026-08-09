# Persiapan child theme My Journal

## Asumsi (tidak ada instalasi OJS lokal di mesin ini)

| Item | Nilai |
|------|--------|
| Target OJS | **3.4+** (namespace `APP\plugins\themes\...`) |
| Parent theme | `defaultthemeplugin` (Default Theme OJS) |
| Plugin folder name | `myjournal` |
| Install path di OJS | `plugins/themes/myjournal/` |

## Checklist backup (lakukan di server/staging OJS Anda)

1. Backup seluruh folder instalasi OJS (atau setidaknya `plugins/themes/` + `config.inc.php`).
2. Backup database (mysqldump / panel hosting).
3. Catat versi OJS: **Administration → System Information** atau file `version.xml` di root OJS.
4. Uji di staging sebelum production.
5. Pastikan akses admin journal dan tulis ke `plugins/themes/`.

## Catatan kompatibilitas

- OJS **3.3 ke bawah** memakai file class `*.inc.php` tanpa namespace PHP modern. Plugin ini mengikuti pola OJS **3.4+** seperti [pkp/defaultChild](https://github.com/pkp/defaultChild).
- Jika OJS Anda 3.3, sesuaikan class loader sesuai dokumentasi theme untuk versi tersebut.
