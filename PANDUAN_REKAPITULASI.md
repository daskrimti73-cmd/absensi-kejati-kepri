# Panduan Implementasi Fitur Rekapitulasi

## 📋 Overview

Fitur ini memungkinkan sistem membaca data dari sheet "REKAPITULASI" di file Excel dan menampilkannya di grafik donut "Persentase Kehadiran Keseluruhan" di dashboard.

## 🎯 Yang Akan Dibaca

Sistem akan membaca section **"KEHADIRAN KESELURUHAN"** dari sheet REKAPITULASI dengan format:

```
KEHADIRAN KESELURUHAN
Jenis Kehadiran    | Jumlah
WFO                | 2284
DINAS LUAR         | 393
UNDANGAN           | 74
SAKIT              | 19
IJIN               | 1
CUTI               | 205
TIDAK ABSEN        | 6
TOTAL              | 2982
```

## 🔧 Langkah Implementasi

### 1. Buat Tabel di Supabase

Jalankan SQL berikut di Supabase SQL Editor:

```sql
-- Lihat file: CREATE_REKAPITULASI_TABLE.sql
```

### 2. Update Admin Panel

File yang perlu dimodifikasi:
- `github-pages/admin.html` - Tambahkan parser rekapitulasi
- `admin_rekapitulasi_parser.js` - File parser sudah dibuat

### 3. Update Dashboard

File yang perlu dimodifikasi:
- `github-pages/index.html` - Update fungsi `generateAttendanceDonut()` untuk mengambil data dari tabel rekapitulasi

## 📊 Alur Kerja

1. **Upload Excel** → Admin panel membaca semua sheet
2. **Deteksi Sheet REKAPITULASI** → Parser mencari sheet dengan nama "REKAPITULASI" atau "REKAP"
3. **Parse Data** → Ekstrak data dari section "KEHADIRAN KESELURUHAN"
4. **Upload ke Supabase** → Simpan ke tabel `rekapitulasi`
5. **Dashboard** → Ambil data dari tabel `rekapitulasi` untuk donut chart

## 🎨 Tampilan di Dashboard

Grafik donut "Persentase Kehadiran Keseluruhan" akan menampilkan:
- WFO: 76.59%
- Dinas Luar: 13.18%
- Undangan: 2.48%
- Sakit: 0.64%
- Ijin: 0.03%
- Cuti: 6.87%
- Tidak Absen: 0.20%

## ⚠️ Catatan Penting

1. **Format Excel harus konsisten** - Section "KEHADIRAN KESELURUHAN" harus ada di sheet REKAPITULASI
2. **Nama sheet** - Bisa "REKAPITULASI", "REKAP", atau mengandung kata tersebut
3. **Data per bulan** - Setiap upload akan menyimpan data untuk bulan dan tahun tertentu
4. **Update otomatis** - Jika data untuk bulan yang sama di-upload lagi, akan di-update

## 🚀 Testing

1. Upload file Excel yang memiliki sheet REKAPITULASI
2. Cek console log untuk melihat apakah data ter-parse dengan benar
3. Cek tabel `rekapitulasi` di Supabase
4. Refresh dashboard dan pilih bulan yang sesuai
5. Grafik donut harus menampilkan data dari rekapitulasi

## 📝 TODO

- [ ] Buat tabel `rekapitulasi` di Supabase
- [ ] Tambahkan script `admin_rekapitulasi_parser.js` ke admin.html
- [ ] Modifikasi fungsi upload di admin.html untuk memanggil `parseRekapitulasi()`
- [ ] Update fungsi `generateAttendanceDonut()` di index.html untuk fetch dari tabel rekapitulasi
- [ ] Testing dengan file Excel yang memiliki sheet REKAPITULASI
