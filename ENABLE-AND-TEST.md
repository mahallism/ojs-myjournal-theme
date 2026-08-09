# Enable & test checklist — My Journal theme

Tidak ada instalasi OJS di mesin pengembangan ini. Setelah Anda menyalin plugin ke server OJS, ikuti langkah berikut.

## Instalasi

1. Salin folder `plugins/themes/myjournal/` ke root OJS Anda (hasil: `OJS_ROOT/plugins/themes/myjournal/`).
2. Pastikan nama folder tepat `myjournal` (bukan `myjournal-main` atau `ojs-myjournal-theme`).
3. Izin file readable oleh web server (biasanya cukup 644 / 755).

## Enable & aktifkan

1. Login sebagai Journal Manager / Site Admin.
2. **Settings → Website → Plugins** → bagian Theme Plugins → **enable** "My Journal".
3. **Settings → Website → Appearance** → pilih theme **My Journal** → Save.
4. **Administration → Clear Data Caches** dan **Clear Template Cache** (atau hapus isi `cache/t_compile` dan `cache/t_cache` dengan hati-hati).

## Uji halaman

Centang setelah dicek di desktop dan mobile:

- [ ] Homepage journal menampilkan label/intro My Journal dan warna primer hijau
- [ ] Issue TOC / current issue
- [ ] Article detail
- [ ] Search
- [ ] About
- [ ] Submission
- [ ] Tidak ada error CSS/JS di console browser
- [ ] Setelah clear cache, LESS custom tetap terlihat

## Verifikasi struktur lokal

Dari root repo ini, jalankan:

```powershell
powershell -File .\scripts\verify-theme.ps1
```

Script memeriksa file wajib child theme ada dan `setParent` / `modifyStyle` terkonfigurasi.
