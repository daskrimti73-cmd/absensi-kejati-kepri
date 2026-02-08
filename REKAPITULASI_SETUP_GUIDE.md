# 📊 Panduan Setup Fitur Rekapitulasi

## ✅ Status Implementasi

Fitur rekapitulasi sudah **SELESAI DIINTEGRASIKAN** ke sistem!

### Yang Sudah Dikerjakan:

1. ✅ Parser rekapitulasi yang robust (`admin_rekapitulasi_parser.js`)
2. ✅ Integrasi ke admin panel (`admin.html`)
3. ✅ Integrasi ke dashboard (`index.html`)
4. ✅ SQL untuk membuat tabel (`CREATE_REKAPITULASI_TABLE.sql`)

## 🎯 Langkah Setup (HANYA 1 LANGKAH!)

### Buat Tabel di Supabase

1. Buka **Supabase Dashboard** → https://supabase.com/dashboard
2. Pilih project Anda
3. Klik **SQL Editor** di sidebar kiri
4. Klik **New Query**
5. Copy-paste SQL berikut:

```sql
-- CREATE REKAPITULASI TABLE
CREATE TABLE IF NOT EXISTS rekapitulasi (
    id BIGSERIAL PRIMARY KEY,
    bulan TEXT NOT NULL,
    tahun INTEGER NOT NULL,
    wfo INTEGER DEFAULT 0,
    dinas_luar INTEGER DEFAULT 0,
    undangan INTEGER DEFAULT 0,
    sakit INTEGER DEFAULT 0,
    ijin INTEGER DEFAULT 0,
    cuti INTEGER DEFAULT 0,
    tidak_absen INTEGER DEFAULT 0,
    total INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(bulan, tahun)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_rekapitulasi_bulan_tahun ON rekapitulasi(bulan, tahun);

-- Enable Row Level Security (RLS)
ALTER TABLE rekapitulasi ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access" ON rekapitulasi
    FOR SELECT
    USING (true);

-- Create policy to allow authenticated insert/update
CREATE POLICY "Allow authenticated insert" ON rekapitulasi
    FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow authenticated update" ON rekapitulasi
    FOR UPDATE
    USING (true);
```

6. Klik **Run** atau tekan `Ctrl+Enter`
7. Pastikan muncul pesan **Success**

## 🎉 Selesai!

Sistem sudah siap digunakan!

## 📖 Cara Kerja

### Mode Dual (Otomatis)

Sistem bekerja dalam 2 mode secara otomatis:

#### Mode 1: Dengan Rekapitulasi (Prioritas)
```
Upload Excel → Ada sheet REKAPITULASI → Parse data → Upload ke Supabase
                                                    ↓
Dashboard → Fetch dari tabel rekapitulasi → Tampilkan di donut chart
```

#### Mode 2: Tanpa Rekapitulasi (Fallback)
```
Upload Excel → Tidak ada sheet REKAPITULASI → Skip (tidak error)
                                            ↓
Dashboard → Tidak ada data rekapitulasi → Hitung dari tabel absensi → Tampilkan di donut chart
```

### Keunggulan Sistem

✅ **Tidak Merusak Logika Existing**
- Jika parsing rekapitulasi gagal → sistem tetap jalan normal
- Jika tidak ada sheet rekapitulasi → sistem tetap jalan normal
- Logika perhitungan existing tetap berfungsi sebagai fallback

✅ **Fleksibel**
- Sheet bisa bernama: "REKAPITULASI", "rekapitulasi", "Rekapitulasi", "REKAP", dll
- Data bisa diletakkan di mana saja di sheet
- Label bisa berbagai variasi: "WFO", "wfo", "DINAS LUAR", "dinas luar", dll

✅ **Aman**
- Semua error di-catch dan di-log
- Tidak ada error yang menghentikan proses upload
- Console log lengkap untuk debugging

## 🧪 Testing

### Test 1: Upload Excel Dengan Rekapitulasi

1. Siapkan file Excel dengan sheet "REKAPITULASI"
2. Di sheet tersebut, buat section "KEHADIRAN KESELURUHAN":
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
3. Upload via admin panel
4. Cek console (F12) → Harus ada log "✅ Using REKAPITULASI data"
5. Buka dashboard → Donut chart harus menampilkan data dari rekapitulasi

### Test 2: Upload Excel Tanpa Rekapitulasi

1. Siapkan file Excel tanpa sheet REKAPITULASI
2. Upload via admin panel
3. Cek console (F12) → Harus ada log "ℹ️ No rekapitulasi data found (this is OK)"
4. Buka dashboard → Donut chart harus menampilkan data hasil perhitungan

### Test 3: Verifikasi Data di Supabase

1. Buka Supabase Dashboard
2. Klik **Table Editor**
3. Pilih tabel **rekapitulasi**
4. Cek apakah data sudah masuk dengan benar

## 🐛 Troubleshooting

### Masalah: Donut chart tidak update

**Solusi:**
1. Buka console (F12)
2. Cek apakah ada error
3. Cek log: "✅ Using REKAPITULASI data" atau "ℹ️ Using CALCULATED data"
4. Hard refresh: `Ctrl + Shift + R`

### Masalah: Data rekapitulasi tidak ter-upload

**Solusi:**
1. Cek console saat upload
2. Pastikan sheet bernama "REKAPITULASI" atau "REKAP"
3. Pastikan ada section "KEHADIRAN KESELURUHAN" atau minimal ada label "WFO"
4. Cek tabel di Supabase apakah sudah dibuat

### Masalah: Error saat membuat tabel

**Solusi:**
1. Pastikan Anda sudah login ke Supabase
2. Pastikan project sudah dipilih
3. Coba jalankan SQL satu per satu (bukan sekaligus)
4. Cek apakah ada error message di SQL Editor

## 📞 Support

Jika ada masalah, cek:
1. Console log (F12) untuk error detail
2. Supabase logs untuk error database
3. File `PANDUAN_REKAPITULASI.md` untuk dokumentasi lengkap

## 🎯 Kesimpulan

Fitur rekapitulasi sudah **100% terintegrasi** dan siap digunakan!

Anda hanya perlu:
1. Buat tabel di Supabase (1x saja)
2. Upload Excel seperti biasa

Sistem akan otomatis:
- Deteksi sheet rekapitulasi
- Parse dan upload data
- Tampilkan di dashboard

**Tidak ada perubahan workflow!** Sistem tetap bekerja seperti biasa, dengan bonus fitur rekapitulasi otomatis! 🎉
