# Dashboard Absensi Mobile - Kejaksaan Tinggi Kepulauan Riau

Dashboard interaktif untuk visualisasi data absensi pegawai dengan grafik batang dan statistik lengkap.

**Version**: 3.1.3 (Updated: 8 Feb 2026)  
**Status**: ✅ PRODUCTION READY

---

## 📁 Struktur Folder

```
├── admin.html                    # Admin panel untuk upload data (v3.1.3)
├── analytics.html                # Analytics Dashboard (NEW v3.1.3)
├── comparison.html               # Comparison Mode (NEW v3.1.3)
├── github-pages/
│   ├── admin.html                # Production admin panel (v3.1.3)
│   └── index.html                # Dashboard website
├── data-absensi/                 # Backup CSV files (Mei-Des 2025)
├── panduan/                      # Panduan WordPress integration
├── README.md                     # Dokumentasi utama (file ini)
├── CHANGELOG.md                  # Version history
├── CARA_UPLOAD_DATA.md           # Panduan upload
├── TROUBLESHOOTING_GRAFIK.md     # Troubleshooting guide
├── FAQ.md                        # Frequently Asked Questions (NEW v3.1.3)
├── QUICK_DELETE_AND_VERIFY.sql   # SQL queries
├── PREVENT_DUPLICATES.sql        # Duplicate prevention
├── UPDATE_v3.1.3.md              # Latest version docs (NEW)
├── .github/workflows/
│   └── deploy.yml                # CI/CD Pipeline (NEW v3.1.3)
└── admin_v3_smart_parser.js      # Reference implementation
```

---

## 🚀 Fitur

### Dashboard (index.html)
- ✅ Grafik batang interaktif dengan Chart.js
- ✅ Filter bulan, tahun, dan kategori data
- ✅ Statistik real-time (Total Pegawai, WFO, Dinas Luar, dll)
- ✅ Tabel detail data harian
- ✅ Responsive design (mobile-friendly)

### Admin Panel (admin.html) - v3.1.3
- ✅ **Smart Parser**: Auto-detect format Excel
- ✅ **Auto-calculate GABUNGAN**: Jika tidak ada baris ringkasan
- ✅ **CLEAN Priority**: Prioritize "CLEAN" sheet
- ✅ **Duplicate Prevention**: 2-layer protection
- ✅ **Progress Bar**: Visual feedback saat upload (NEW)
- ✅ **Upload History**: Riwayat 10 upload terakhir (NEW)
- ✅ Upload Excel dengan berbagai format
- ✅ Validation & error handling

### Analytics Dashboard (analytics.html) - NEW v3.1.3
- ✅ **Trend Analysis**: WFO, Dinas Luar, Tidak Absen
- ✅ **6 Months Trend**: Line chart historical data
- ✅ **Top 5 Bidang**: Ranking WFO tertinggi
- ✅ **Alerts**: Deteksi perubahan signifikan
- ✅ **Comparison Chart**: Per bidang visualization

### Comparison Mode (comparison.html) - NEW v3.1.3
- ✅ **Side-by-Side**: Bandingkan 2 bulan sekaligus
- ✅ **Difference Indicator**: Persentase & arrow
- ✅ **Visual Charts**: Bar chart perbandingan
- ✅ **Per Bidang**: Detailed comparison

### CI/CD Pipeline - NEW v3.1.3
- ✅ **Auto-deploy**: Push ke main → auto-deploy
- ✅ **Validation**: File & syntax check
- ✅ **GitHub Actions**: Automated workflow

---

## 📊 Kategori Data

1. **WFO (Hadir)** - Pegawai yang hadir di kantor
2. **Dinas Luar** - Pegawai yang bertugas di luar kantor
3. **Undangan** - Pegawai yang menghadiri undangan
4. **Sakit** - Pegawai yang sakit
5. **Ijin** - Pegawai yang ijin
6. **Cuti** - Pegawai yang cuti
7. **Tidak Absen** - Pegawai yang tidak melakukan absensi

---

## 🎯 Quick Start

### Upload Data
1. Buka `admin.html`
2. Pilih bulan & tahun
3. Pilih file Excel
4. Mode: **Replace** (recommended)
5. Klik **Upload Data**

### View Data
1. Buka website: `https://daskrimti73-cmd.github.io/absensi-kejati-kepri/`
2. Pilih bulan & tahun
3. Lihat grafik & statistik

---

## 📚 Dokumentasi

- **README.md** (file ini) - Overview & quick start
- **CHANGELOG.md** - Version history & changes
- **CARA_UPLOAD_DATA.md** - Panduan upload lengkap
- **TROUBLESHOOTING_GRAFIK.md** - Troubleshooting guide
- **UPDATE_v3.1.2.md** - Latest version documentation

---

## 🔧 Version History (Summary)

### v3.1.3 (Current) - UI Improvements & Analytics
- ✅ Progress Bar saat upload
- ✅ Upload History (10 terakhir)
- ✅ Analytics Dashboard (analytics.html)
- ✅ Comparison Mode (comparison.html)
- ✅ FAQ Interaktif (FAQ.md)
- ✅ CI/CD Pipeline (GitHub Actions)

### v3.1.2 - Duplicate Prevention
- ✅ 2-layer duplicate protection
- ✅ Warning before creating duplicates
- ✅ Database unique constraint support

### v3.1.1 - CLEAN Sheet Priority
- ✅ Prioritize "CLEAN" sheet for GABUNGAN
- ✅ Handle multiple GABUNGAN sheets

### v3.1.0 - Auto-calculate GABUNGAN
- ✅ Calculate GABUNGAN from bidang totals
- ✅ Support Excel without summary rows

### v3.0.0 - Smart Excel Parser
- ✅ Auto-detect date columns
- ✅ Auto-detect summary rows
- ✅ Support multiple Excel formats

**See CHANGELOG.md for complete history**

---

## 🌐 Deployment

Website di-deploy menggunakan GitHub Pages:
- URL: `https://daskrimti73-cmd.github.io/absensi-kejati-kepri/`

---

## 📞 Support

**Troubleshooting:**
- Check **TROUBLESHOOTING_GRAFIK.md**
- Check Console (F12) untuk error messages

**Upload Issues:**
- Read **CARA_UPLOAD_DATA.md**
- Check **QUICK_DELETE_AND_VERIFY.sql** for SQL queries

**Duplicate Prevention:**
- Read **UPDATE_v3.1.2.md**
- Run **PREVENT_DUPLICATES.sql**

---

## ✅ System Status

**Version**: 3.1.3  
**Status**: ✅ PRODUCTION READY  
**Tested**: ✅ 8 months (Mei-Des 2025)  
**Success Rate**: 100%  
**Data Accuracy**: 100%  

**New Features (v3.1.3):**
- 📊 Analytics Dashboard
- ⚖️ Comparison Mode
- 📈 Progress Bar
- 📜 Upload History
- ❓ FAQ Interaktif
- 🚀 CI/CD Pipeline

**System is stable and ready for production use!** 🚀
- Auto-deploy setiap kali push ke branch `main`

## 📝 Cara Update Data

1. Edit file `github-pages/index.html`
2. Cari bagian `const dataAbsensi`
3. Tambahkan/update data bulan baru
4. Commit dan push ke GitHub
5. Website akan otomatis ter-update

## 🛠️ Teknologi

- HTML5
- CSS3 (Grid, Flexbox, Gradient)
- JavaScript (ES6+)
- Chart.js v4.x
- Supabase (Database)
- GitHub Pages

## 🔧 Troubleshooting

Jika grafik menampilkan data yang salah atau tidak sesuai:

1. **Cek data duplikat:**
   ```sql
   -- Jalankan di Supabase SQL Editor
   -- File: check_duplicate_all_months.sql
   ```

2. **Bersihkan duplikat:**
   ```sql
   -- File: fix_duplicate_all_months.sql
   ```

3. **Refresh browser dengan Ctrl + Shift + R**

4. **Cek browser console (F12) untuk error**

Lihat file `TROUBLESHOOTING_GRAFIK.md` untuk panduan lengkap.

## 📚 Dokumentasi

- **CARA_UPLOAD_DATA.md** - Panduan lengkap upload data Excel
- **TROUBLESHOOTING_GRAFIK.md** - Troubleshooting grafik tidak muncul
- **panduan/STEP_BY_STEP_PANDUAN.md** - Panduan step-by-step lengkap

## 🚀 Cara Upload Data

### Quick Start:
1. Buka `admin.html` di browser
2. Tekan F12, cek Console: harus ada `📦 Admin Panel Version: 2.0.0`
3. Jika version lama, tekan **Ctrl + Shift + R** (hard refresh)
4. Pilih bulan, tahun, dan file Excel
5. Klik "Upload Data"
6. Cek validation summary di Console
7. Verifikasi di website

### Format Excel:
- Sheet GABUNGAN: Nama harus mengandung CLEAN/ALL CLEAN/GABUNGAN/SEMUA
- Sheet per bidang: DATUN, KOORDINATOR, PEMBINAAN, dll
- Kolom tanggal: 01-31
- Baris summary: JUMLAH WFO, JUMLAH DINAS LUAR, dll

## ✅ Fitur v2.0.0

1. **Auto-Detect GABUNGAN Sheet** - Otomatis mencari sheet GABUNGAN (tidak peduli posisi)
2. **Cache Busting** - Browser tidak akan cache versi lama
3. **Validation After Upload** - Otomatis tampilkan total per bidang di Console
4. **Multi-Sheet Support** - Upload banyak sheet sekaligus

## 🔧 Upgrade ke v3.0.0 (Optional)

File `admin_v3_smart_parser.js` berisi kode untuk smart Excel parser yang bisa:
- Otomatis deteksi posisi kolom tanggal (tidak hard-coded)
- Bisa baca Excel dengan format berbeda
- Validasi lebih ketat sebelum upload
- Error message yang lebih jelas

**Cara implementasi**: Copy code dari `admin_v3_smart_parser.js` ke `admin.html`

## 📄 Lisensi

© 2025 Kejaksaan Tinggi Kepulauan Riau
