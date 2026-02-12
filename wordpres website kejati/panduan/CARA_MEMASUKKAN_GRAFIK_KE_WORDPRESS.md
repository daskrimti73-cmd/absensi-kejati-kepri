# CARA MEMASUKKAN GRAFIK KE WORDPRESS

## Metode 1: Menggunakan Block HTML Custom

### Langkah-langkah:

1. **Buka halaman ABSENSI MOBILE di WordPress**
   - Pergi ke Laman → Semua Laman
   - Klik Edit pada halaman "ABSENSI MOBILE"

2. **Tambahkan Block HTML**
   - Klik tombol + (Add Block)
   - Cari "HTML Khusus" atau "Custom HTML"
   - Tambahkan block tersebut

3. **Copy seluruh kode HTML dari file `absensi-mobile.html`**
   - Buka file `grafik-absensi/absensi-mobile.html`
   - Copy semua isinya (Ctrl+A, Ctrl+C)
   - Paste ke block HTML di WordPress

4. **Publish/Update halaman**

---

## Metode 2: Menggunakan WPBakery Page Builder

Karena saya lihat website Anda menggunakan WPBakery Page Builder:

1. **Klik "Edit with WPBakery Page Builder"** di halaman ABSENSI MOBILE
2. **Tambahkan element "Raw HTML"**
3. **Paste kode HTML grafik**
4. **Save changes**

---

## Metode 3: Menggunakan Shortcode (Untuk Pengguna Advanced)

Jika ingin lebih rapi, bisa buat shortcode di file functions.php tema:

### 1. Akses File Manager atau FTP

### 2. Buka file: `wp-content/themes/tema-aktif/functions.php`

### 3. Tambahkan kode berikut di akhir file:

```php
// Shortcode Grafik Absensi Mobile
function grafik_absensi_shortcode() {
    ob_start();
    ?>
    <!-- PASTE KODE HTML GRAFIK DI SINI -->
    <?php
    return ob_get_clean();
}
add_shortcode('grafik_absensi', 'grafik_absensi_shortcode');
```

### 4. Gunakan shortcode di halaman:
```
[grafik_absensi]
```

---

## CATATAN PENTING

### Untuk Data Asli dari Excel:

1. Buka file Excel absensi Anda
2. Convert data ke format JavaScript array
3. Ganti data contoh di kode dengan data asli Anda

### Contoh konversi:

**Data Excel:**
| Tanggal | Hadir | Izin | Sakit |
|---------|-------|------|-------|
| 1 | 135 | 3 | 2 |
| 2 | 138 | 2 | 1 |

**Menjadi JavaScript:**
```javascript
hadir: [135, 138, ...],
izin: [3, 2, ...],
sakit: [2, 1, ...]
```

---

## TOOLS UNTUK CONVERT EXCEL KE JSON

Gunakan website ini untuk convert Excel ke JSON:
- https://www.convertcsv.com/csv-to-json.htm
- https://products.aspose.app/cells/conversion/excel-to-json

Kemudian sesuaikan format JSON-nya dengan struktur kode.

---

*Lanjut ke step berikutnya setelah grafik berhasil tampil*
