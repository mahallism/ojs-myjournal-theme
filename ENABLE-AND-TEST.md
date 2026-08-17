# Enable & test checklist — My Journal theme

Target: **OJS 3.5.0.3**, parent **Health Sciences v1.1.3-1**, theme **Accessible Theme** (plugin folder `myjournal`, ≥ 1.1.10).

Full production steps: [PRODUCTION.md](PRODUCTION.md). Override inventory: [OVERRIDES.md](OVERRIDES.md).

## Instalasi

1. Pasang Health Sciences ke `OJS_ROOT/plugins/themes/healthSciences/` dan **enable** plugin itu.
2. Salin folder `plugins/themes/myjournal/` ke root OJS (hasil: `OJS_ROOT/plugins/themes/myjournal/`).
3. Pastikan nama folder tepat `myjournal` (bukan `myjournal-main` atau `ojs-myjournal-theme`).
4. Izin file readable oleh web server (biasanya cukup 644 / 755).



## Enable & aktifkan

1. Login sebagai Journal Manager / Site Admin.
2. **Settings → Website → Plugins** → enable **Health Sciences**, lalu enable **Accessible Theme**.
3. **Settings → Website → Appearance** → pilih theme **Accessible Theme** → Save.
4. **Administration → Clear Data Caches** dan **Clear Template Cache**.



## Regresi UI (desktop + mobile)



### Brand & layout

- [x] Layout Health Sciences (bukan Default Theme)
- [x] Light mode: aksen navy SLDPI `#112d52` (bukan cyan `#10BECA` / hijau lama)
- [x] Dark mode: aksen turquoise lembut `#7ed4c8` pada tautan/judul kartu
- [x] Header sticky biru; logo kiri, menu, tools kanan
- [x] Anak menu dropdown vertikal
- [x] Hero: label UB, judul, tagline; CTA submit **kuning keemasan**; Current issue outline



### Halaman

- [x] Homepage: issue description + tombol More; TOC dua kolom; kartu artikel (judul → penulis → halaman|galley)
- [x] Jarak antar section TOC wajar; “View all issues” tidak mepet
- [x] Issue archive / issue view: deskripsi gelap OK di dark mode
- [x] Article details: `#articleMain` ikut dark mode
- [x] HTML galley: header + metadata + iframe + sticky TOC (h1–h4); font Source Sans 3 (self-hosted)
- [x] Search, About, Submissions, Login/Register (teks putih di header biru)
- [ ] Login / Register / lost password: kartu form, judul bold, ukuran teks selaras body
- [ ] Search: kartu hasil selaras TOC; panel filter sticky (bukan blok abu HS)
- [ ] Archive: lima kolom dari 768px; urutan Terbaru/Terlama; filter tahun
- [ ] Article details: heading brand; kolom utama bukan abu HS; galley/tautan dark OK



### Interaksi

- [x] Search ikon → expand; submit hanya jika ada query
- [x] Theme toggle: light/dark + persist `localStorage`; hormati `prefers-color-scheme` bila belum disimpan
- [x] **Appearance**: accent colour mengubah tombol Submit; hero text override bila diisi; hide dark-mode toggle bila opsi Hide
- [x] Dark mode ikut ke iframe HTML galley
- [x] Bahasa EN/ID (hero + toggle labels)
- [x] Tidak ada error CSS 500 / console JS



### Aksesibilitas

- [x] **Skip to main content** muncul saat Tab pertama; fokus ke `#myjournal-main`
- [x] Fokus keyboard terlihat (outline) di menu, tombol, form — light & dark
- [x] Kontras judul/tautan dark mode terbaca
- [x] `prefers-reduced-motion`: tidak ada animasi mengganggu
- [x] Sticky header tidak menutupi target skip (fokus main)



### Cache

- [x] Setelah Clear Caches, LESS custom tetap terlihat (bukan hanya `app.min.css`)



## Verifikasi struktur lokal

```powershell
powershell -File .\scripts\verify-theme.ps1
```

