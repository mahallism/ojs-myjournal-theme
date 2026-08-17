# Persiapan child theme My Journal

## Asumsi

| Item | Nilai |
|------|--------|
| Target OJS | **3.5.0.3** |
| Parent theme | `healthsciencesthemeplugin` (Health Sciences **v1.1.3-1**) |
| Bidang jurnal | Disability studies |
| Plugin folder name | `myjournal` |
| Install path di OJS | `plugins/themes/myjournal/` |

Instalasi lokal (Laragon) tercatat di [LOCAL-OJS.md](LOCAL-OJS.md).

## Parent yang harus terpasang

1. Unduh [healthSciences-v1_1_3-1.tar.gz](https://github.com/pkp/healthSciences/releases/download/v1_1_3-1/healthSciences-v1_1_3-1.tar.gz).
2. Ekstrak ke `plugins/themes/healthSciences/` (nama folder tanpa sufiks versi).
3. Enable **Health Sciences** di **Settings → Website → Plugins** *sebelum* memilih **Accessible Theme** di Appearance.
4. Jangan pakai **v1.1.3-2** pada OJS 3.5.0.3 — rilis itu untuk 3.5.0-4+.

## Checklist backup (lakukan di server/staging OJS Anda)

1. Backup seluruh folder instalasi OJS (atau setidaknya `plugins/themes/` + `config.inc.php`).
2. Backup database (mysqldump / panel hosting).
3. Catat versi OJS: **Administration → System Information** atau file `version.xml` di root OJS. Target: **3.5.0.3**.
4. Uji di staging sebelum production.
5. Uji di staging sebelum production — lihat [PRODUCTION.md](PRODUCTION.md).
6. Pastikan akses admin journal dan tulis ke `plugins/themes/`.

## Catatan kompatibilitas

- Child theme mewarisi template Bootstrap 5 Health Sciences, bukan Default Theme.
- Nama folder plugin tidak boleh mengandung tanda hubung (`-`); `myjournal` sudah sesuai.
- OJS **3.3 ke bawah** tidak didukung.
- Daftar file override: [OVERRIDES.md](OVERRIDES.md).
