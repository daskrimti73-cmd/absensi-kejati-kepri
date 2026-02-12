# Panduan Ganti Akun GitHub dan Supabase

Dokumen ini menjelaskan cara memindahkan project ke akun GitHub dan Supabase yang berbeda.

---

## 📋 PERSIAPAN

Sebelum mulai, pastikan Anda punya:
- [ ] Akun GitHub baru (atau yang ingin digunakan)
- [ ] Akun Supabase baru (atau yang ingin digunakan)
- [ ] Backup data dari Supabase lama (export database)
- [ ] File Excel asli untuk re-upload (jika diperlukan)

---

## 🔄 BAGIAN 1: PINDAH KE GITHUB BARU

### Opsi A: Fork/Clone Repository (Recommended)

**Langkah 1: Clone repository lokal**
```bash
cd "C:\KUMPULAN PROJEK SAYA\PROGRES\wordpres website kejati"
cd github-pages
```

**Langkah 2: Hapus remote GitHub lama**
```bash
git remote remove origin
```

**Langkah 3: Buat repository baru di GitHub baru**
1. Login ke akun GitHub baru
2. Klik tombol "+" → "New repository"
3. Nama repository: `absensi-kejati-kepri` (atau nama lain)
4. Pilih "Public" atau "Private"
5. JANGAN centang "Initialize with README"
6. Klik "Create repository"

**Langkah 4: Tambahkan remote GitHub baru**
```bash
git remote add origin https://github.com/USERNAME_BARU/absensi-kejati-kepri.git
```
*Ganti `USERNAME_BARU` dengan username GitHub baru Anda*

**Langkah 5: Push ke GitHub baru**
```bash
git branch -M main
git push -u origin main
```

**Langkah 6: Aktifkan GitHub Pages**
1. Buka repository di GitHub
2. Klik "Settings" → "Pages"
3. Source: pilih "main" branch
4. Folder: pilih "/ (root)"
5. Klik "Save"
6. Tunggu beberapa menit, URL akan muncul

---

### Opsi B: Transfer Repository (Jika punya akses ke akun lama)

**Langkah 1: Transfer repository**
1. Buka repository di GitHub lama
2. Klik "Settings" → scroll ke bawah
3. Klik "Transfer" di bagian "Danger Zone"
4. Masukkan username GitHub baru
5. Konfirmasi transfer

**Langkah 2: Update remote lokal**
```bash
cd github-pages
git remote set-url origin https://github.com/USERNAME_BARU/absensi-kejati-kepri.git
```

---

## 🗄️ BAGIAN 2: SETUP SUPABASE BARU

### Langkah 1: Buat Project Supabase Baru

1. Login ke https://supabase.com dengan akun baru
2. Klik "New Project"
3. Isi:
   - Name: `absensi-kejati-kepri` (atau nama lain)
   - Database Password: buat password kuat (SIMPAN!)
   - Region: pilih yang terdekat (Singapore recommended)
4. Klik "Create new project"
5. Tunggu ~2 menit sampai project siap

### Langkah 2: Buat Tabel Database

**A. Buat tabel `absensi`**

Buka SQL Editor di Supabase, jalankan:

```sql
CREATE TABLE absensi (
    id BIGSERIAL PRIMARY KEY,
    tahun INTEGER NOT NULL,
    bulan TEXT NOT NULL,
    tanggal TEXT NOT NULL,
    hari TEXT NOT NULL,
    bidang TEXT NOT NULL,
    wfo INTEGER DEFAULT 0,
    dinas_luar INTEGER DEFAULT 0,
    undangan INTEGER DEFAULT 0,
    sakit INTEGER DEFAULT 0,
    ijin INTEGER DEFAULT 0,
    cuti INTEGER DEFAULT 0,
    isoman INTEGER DEFAULT 0,
    tidak_absen INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_absensi_tahun_bulan ON absensi(tahun, bulan);
CREATE INDEX idx_absensi_bidang ON absensi(bidang);
CREATE INDEX idx_absensi_tanggal ON absensi(tanggal);
```

**B. Buat tabel `rekapitulasi`**

```sql
CREATE TABLE rekapitulasi (
    id BIGSERIAL PRIMARY KEY,
    tahun INTEGER NOT NULL,
    bulan TEXT NOT NULL,
    bidang TEXT NOT NULL,
    total_pegawai INTEGER DEFAULT 0,
    total_hari_kerja INTEGER DEFAULT 0,
    total_hadir INTEGER DEFAULT 0,
    persentase_kehadiran NUMERIC(5,2) DEFAULT 0,
    wfo INTEGER DEFAULT 0,
    dinas_luar INTEGER DEFAULT 0,
    undangan INTEGER DEFAULT 0,
    sakit INTEGER DEFAULT 0,
    ijin INTEGER DEFAULT 0,
    cuti INTEGER DEFAULT 0,
    isoman INTEGER DEFAULT 0,
    tidak_absen INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(tahun, bulan, bidang)
);

-- Create indexes
CREATE INDEX idx_rekapitulasi_tahun_bulan ON rekapitulasi(tahun, bulan);
CREATE INDEX idx_rekapitulasi_bidang ON rekapitulasi(bidang);
```

**C. Enable Row Level Security (RLS)**

```sql
-- Enable RLS
ALTER TABLE absensi ENABLE ROW LEVEL SECURITY;
ALTER TABLE rekapitulasi ENABLE ROW LEVEL SECURITY;

-- Create policies (allow all for now - adjust based on your needs)
CREATE POLICY "Allow all access to absensi" ON absensi FOR ALL USING (true);
CREATE POLICY "Allow all access to rekapitulasi" ON rekapitulasi FOR ALL USING (true);
```

### Langkah 3: Setup Storage untuk Excel Files

**A. Buat bucket**

1. Klik "Storage" di sidebar Supabase
2. Klik "Create a new bucket"
3. Name: `excel-files`
4. Public bucket: ✅ CENTANG (agar file bisa diakses)
5. Klik "Create bucket"

**B. Set bucket policy**

Buka SQL Editor, jalankan:

```sql
-- Allow public access to excel-files bucket
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'excel-files' );

CREATE POLICY "Allow uploads"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'excel-files' );

CREATE POLICY "Allow updates"
ON storage.objects FOR UPDATE
USING ( bucket_id = 'excel-files' );

CREATE POLICY "Allow deletes"
ON storage.objects FOR DELETE
USING ( bucket_id = 'excel-files' );
```

### Langkah 4: Dapatkan Supabase Credentials

1. Klik "Settings" → "API" di Supabase
2. Copy:
   - **Project URL** (contoh: `https://xxxxx.supabase.co`)
   - **anon public key** (key yang panjang)

---

## 🔧 BAGIAN 3: UPDATE KODE

### Langkah 1: Update Supabase Credentials di index.html

Buka file `github-pages/index.html`, cari baris ini (sekitar baris 1330-1331):

```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Ganti dengan credentials Supabase baru Anda.

### Langkah 2: Update Supabase Credentials di admin.html

Buka file `github-pages/admin.html`, cari baris ini (sekitar baris 1330-1331):

```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Ganti dengan credentials Supabase baru Anda.

### Langkah 3: Commit dan Push Perubahan

```bash
cd github-pages
git add index.html admin.html
git commit -m "Update Supabase credentials to new account"
git push
```

---

## 📊 BAGIAN 4: MIGRASI DATA (Optional)

Jika Anda ingin memindahkan data dari Supabase lama:

### Opsi A: Export/Import via SQL

**Export dari Supabase lama:**
1. Buka SQL Editor di Supabase lama
2. Jalankan:
```sql
COPY (SELECT * FROM absensi) TO STDOUT WITH CSV HEADER;
COPY (SELECT * FROM rekapitulasi) TO STDOUT WITH CSV HEADER;
```
3. Save hasil ke file CSV

**Import ke Supabase baru:**
1. Buka Table Editor di Supabase baru
2. Pilih table `absensi` → "Insert" → "Import data from CSV"
3. Upload file CSV
4. Ulangi untuk table `rekapitulasi`

### Opsi B: Re-upload Excel Files

Cara paling mudah:
1. Buka admin panel baru: `https://USERNAME_BARU.github.io/absensi-kejati-kepri/admin.html`
2. Login dengan credentials yang sama
3. Upload ulang file Excel untuk setiap bulan
4. Sistem akan otomatis populate database

---

## ✅ VERIFIKASI

Setelah semua selesai, cek:

1. **GitHub Pages aktif:**
   - Buka `https://USERNAME_BARU.github.io/absensi-kejati-kepri/`
   - Dashboard harus muncul (mungkin kosong jika belum ada data)

2. **Supabase terhubung:**
   - Buka Console browser (F12)
   - Harus muncul: "Supabase initialized successfully"
   - Tidak ada error koneksi

3. **Upload berfungsi:**
   - Login ke admin panel
   - Upload file Excel test
   - Cek apakah data masuk ke database Supabase

4. **Dashboard menampilkan data:**
   - Refresh dashboard
   - Pilih tahun dan bulan
   - Grafik harus muncul

---

## 🆘 TROUBLESHOOTING

### Error: "Failed to fetch" atau "Network error"

**Penyebab:** Supabase credentials salah atau RLS policy terlalu ketat

**Solusi:**
1. Cek kembali SUPABASE_URL dan SUPABASE_ANON_KEY
2. Pastikan RLS policy allow all (lihat Bagian 2, Langkah 2C)

### Error: "Bucket not found"

**Penyebab:** Bucket `excel-files` belum dibuat atau nama salah

**Solusi:**
1. Cek Storage di Supabase, pastikan bucket `excel-files` ada
2. Pastikan bucket bersifat PUBLIC

### Dashboard kosong setelah upload

**Penyebab:** Browser cache atau data belum ter-sync

**Solusi:**
1. Hard refresh (Ctrl+Shift+R)
2. Clear browser cache
3. Cek database di Supabase Table Editor

---

## 📝 CHECKLIST LENGKAP

- [ ] Clone repository lokal
- [ ] Buat repository GitHub baru
- [ ] Push ke GitHub baru
- [ ] Aktifkan GitHub Pages
- [ ] Buat project Supabase baru
- [ ] Buat tabel `absensi` dan `rekapitulasi`
- [ ] Enable RLS dan set policies
- [ ] Buat bucket `excel-files`
- [ ] Set bucket policies
- [ ] Copy Supabase credentials
- [ ] Update credentials di `index.html`
- [ ] Update credentials di `admin.html`
- [ ] Commit dan push perubahan
- [ ] Verifikasi dashboard berfungsi
- [ ] Verifikasi upload berfungsi
- [ ] (Optional) Migrasi data lama

---

## 💡 TIPS

1. **Simpan credentials Supabase** di tempat aman (password manager)
2. **Backup data** sebelum migrasi
3. **Test di environment baru** sebelum hapus yang lama
4. **Update bookmark** browser ke URL GitHub Pages baru
5. **Inform users** jika ada yang menggunakan sistem ini

---

## 📞 BANTUAN

Jika ada masalah saat migrasi:
1. Screenshot error message
2. Cek console log browser (F12)
3. Cek SQL Editor di Supabase untuk error database
4. Hubungi developer dengan informasi di atas
