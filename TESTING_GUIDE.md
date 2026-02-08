# 🧪 Panduan Testing Upload Ulang

## 📋 Langkah-Langkah Testing

### Step 1: Verifikasi Data Existing (Opsional)

Sebelum menghapus, Anda bisa cek data yang ada:

1. Buka **Supabase Dashboard** → SQL Editor
2. Copy-paste query dari file `VERIFY_BEFORE_DELETE.sql`
3. Klik **Run**
4. Lihat data apa saja yang akan dihapus

### Step 2: Hapus Data Tahun 2025

1. Buka **Supabase Dashboard** → SQL Editor
2. Copy-paste query berikut:

```sql
-- Hapus data absensi tahun 2025
DELETE FROM absensi WHERE tahun = 2025;

-- Hapus data rekapitulasi tahun 2025 (jika tabel sudah dibuat)
DELETE FROM rekapitulasi WHERE tahun = 2025;

-- Verifikasi data sudah terhapus
SELECT 'absensi' as tabel, COUNT(*) as jumlah_data FROM absensi WHERE tahun = 2025
UNION ALL
SELECT 'rekapitulasi' as tabel, COUNT(*) as jumlah_data FROM rekapitulasi WHERE tahun = 2025;
```

3. Klik **Run**
4. Pastikan hasil verifikasi menunjukkan **0** untuk kedua tabel

### Step 3: Buat Tabel Rekapitulasi (Jika Belum)

Jika Anda belum membuat tabel rekapitulasi, jalankan SQL dari file `CREATE_REKAPITULASI_TABLE.sql`:

```sql
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

CREATE INDEX IF NOT EXISTS idx_rekapitulasi_bulan_tahun ON rekapitulasi(bulan, tahun);

ALTER TABLE rekapitulasi ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access" ON rekapitulasi
    FOR SELECT USING (true);

CREATE POLICY "Allow authenticated insert" ON rekapitulasi
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated update" ON rekapitulasi
    FOR UPDATE USING (true);
```

### Step 4: Upload Excel

1. Buka admin panel: `https://kejati-kepulauanriau.kejaksaan.go.id/absensi-mobile-3/admin.html`
2. Pilih bulan dan tahun (contoh: Desember 2025)
3. Pilih file Excel
4. Klik **Upload**
5. **PENTING:** Buka Console (tekan F12) untuk melihat log detail

### Step 5: Cek Console Log

Saat upload, perhatikan log di console:

#### ✅ Log yang Harus Muncul (Data Absensi):

```
📊 Total sheets found: X
📋 Sheet names: [...]
🔍 Processing sheet: PEMBINAAN → Detected as: PEMBINAAN
  ✅ Found "JUMLAH WFO" at row X → wfo
  ✅ Found "JUMLAH DINAS LUAR" at row X → dinas_luar
  ...
✅ Extracted X rows for PEMBINAAN
```

#### ✅ Log yang Harus Muncul (Rekapitulasi - Jika Ada):

```
═══════════════════════════════════════════════════════════════════════════════
📊 PARSING REKAPITULASI (OPTIONAL)
═══════════════════════════════════════════════════════════════════════════════
📊 Parsing REKAPITULASI sheet...
✅ Found sheet: "REKAPITULASI"
📄 Sheet has X rows
✅ Found "KEHADIRAN KESELURUHAN" at row X, col X
  ✅ WFO: 2284 (found at row X, col X)
  ✅ DINAS LUAR: 393 (found at row X, col X)
  ...
📊 Rekapitulasi data parsed successfully: {...}
✅ Rekapitulasi data found, uploading to Supabase...
✅ Rekapitulasi uploaded successfully!
```

#### ℹ️ Log Jika Tidak Ada Rekapitulasi (Normal):

```
═══════════════════════════════════════════════════════════════════════════════
📊 PARSING REKAPITULASI (OPTIONAL)
═══════════════════════════════════════════════════════════════════════════════
📊 Parsing REKAPITULASI sheet...
⚠️ Sheet REKAPITULASI tidak ditemukan
   Available sheets: PEMBINAAN, INTELIJEN, PIDUM, ...
ℹ️ No rekapitulasi data found (this is OK, using calculated data)
```

#### ❌ Log Error yang Perlu Diperhatikan:

```
❌ Error parsing sheet "XXX": ...
❌ Error uploading rekapitulasi: ...
```

### Step 6: Verifikasi Data di Supabase

1. Buka **Supabase Dashboard** → Table Editor
2. Pilih tabel **absensi**
3. Filter: `tahun = 2025`
4. Cek apakah data sudah masuk dengan benar
5. Pilih tabel **rekapitulasi** (jika ada sheet REKAPITULASI)
6. Cek apakah data rekapitulasi sudah masuk

### Step 7: Cek Dashboard

1. Buka dashboard: `https://kejati-kepulauanriau.kejaksaan.go.id/absensi-mobile-3/`
2. Pilih bulan yang baru di-upload
3. **Buka Console (F12)** untuk melihat log
4. Perhatikan log:

#### ✅ Jika Ada Data Rekapitulasi:

```
🔍 Checking for rekapitulasi data: Desember 2025
✅ Using rekapitulasi data from database: {...}
✅ Using REKAPITULASI data for donut chart
```

#### ℹ️ Jika Tidak Ada Data Rekapitulasi:

```
🔍 Checking for rekapitulasi data: Desember 2025
ℹ️ No rekapitulasi data found, will use calculated data
ℹ️ Using CALCULATED data for donut chart
```

5. Cek apakah grafik donut "Persentase Kehadiran Keseluruhan" menampilkan data dengan benar
6. Cek apakah treemap menampilkan 9 bidang (termasuk PEMULIHAN ASET)
7. Cek apakah dashboard per bidang menampilkan semua bidang

## ✅ Checklist Testing

### Upload Excel:
- [ ] File Excel ter-upload tanpa error
- [ ] Console log menampilkan parsing untuk semua sheet
- [ ] Console log menampilkan "✅ Extracted X rows" untuk setiap bidang
- [ ] Console log menampilkan parsing rekapitulasi (jika ada sheet)
- [ ] Status menampilkan "✅ Berhasil upload X data"

### Data di Supabase:
- [ ] Tabel `absensi` memiliki data untuk semua bidang
- [ ] Tabel `rekapitulasi` memiliki data (jika ada sheet REKAPITULASI)
- [ ] Jumlah rows sesuai dengan yang di-upload
- [ ] Data WFO, DINAS LUAR, dll sesuai dengan Excel

### Dashboard:
- [ ] Treemap menampilkan 9 bidang dengan jumlah pegawai yang benar
- [ ] Donut chart "Persentase Kehadiran" menampilkan data yang benar
- [ ] Donut chart "Tanpa Keterangan" menampilkan data yang benar
- [ ] Dashboard per bidang menampilkan semua bidang yang ada datanya
- [ ] Info cards menampilkan angka yang benar

## 🐛 Troubleshooting

### Masalah: Upload gagal dengan error

**Cek:**
1. Console log untuk error detail
2. Format Excel sesuai dengan panduan
3. Sheet memiliki baris ringkasan (JUMLAH WFO, dll)
4. Nama sheet sesuai dengan bidang yang valid

### Masalah: Data tidak muncul di dashboard

**Cek:**
1. Hard refresh: `Ctrl + Shift + R`
2. Console log di dashboard
3. Filter bulan/tahun sudah benar
4. Data sudah ada di Supabase

### Masalah: Rekapitulasi tidak ter-parse

**Cek:**
1. Nama sheet mengandung "REKAPITULASI" atau "REKAP"
2. Ada section "KEHADIRAN KESELURUHAN" atau minimal label "WFO"
3. Console log untuk error detail
4. Tabel rekapitulasi sudah dibuat di Supabase

### Masalah: PEMULIHAN ASET tidak muncul

**Cek:**
1. Excel memiliki sheet "PEMULIHAN ASET"
2. Sheet memiliki format yang sama dengan bidang lain
3. Console log menampilkan "Processing sheet: PEMULIHAN ASET"
4. Data sudah ada di Supabase

## 📊 Expected Results

Setelah upload berhasil, Anda harus melihat:

### Di Console (Admin Panel):
```
✅ Berhasil upload X data untuk Desember 2025!
⚠️ CEK CONSOLE (F12) untuk validasi hasil!
```

### Di Supabase (Tabel absensi):
- Data untuk semua bidang (PEMBINAAN, INTELIJEN, PIDUM, PIDSUS, DATUN, PENGAWASAN, TATA USAHA, KOORDINATOR, PEMULIHAN ASET, GABUNGAN)
- Setiap bidang memiliki data per tanggal
- Jumlah WFO, DINAS LUAR, dll sesuai dengan Excel

### Di Supabase (Tabel rekapitulasi):
- 1 row untuk bulan yang di-upload
- Data WFO, DINAS LUAR, dll sesuai dengan sheet REKAPITULASI

### Di Dashboard:
- Treemap: 9 kotak dengan nama bidang lengkap dan jumlah pegawai
- Donut chart: Persentase yang sesuai dengan data
- Dashboard per bidang: Card untuk setiap bidang dengan data

## 🎯 Kesimpulan

Jika semua checklist di atas ✅, maka sistem bekerja dengan sempurna!

Jika ada masalah, cek console log dan Supabase untuk debugging.
