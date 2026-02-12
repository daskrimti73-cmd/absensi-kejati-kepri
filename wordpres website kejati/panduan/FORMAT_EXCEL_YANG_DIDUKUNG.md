# Format Excel Yang Didukung

Dokumen ini menjelaskan format Excel yang dapat dibaca oleh sistem parser.

## ✅ FORMAT YANG AMAN (Dijamin Berhasil)

### 1. Penamaan Sheet GABUNGAN

Parser akan mencari sheet dengan nama (prioritas dari atas ke bawah):
- ✅ "CLEAN ALL" (prioritas tertinggi)
- ✅ "ALL CLEAN"
- ✅ "CLEAN"
- ✅ "ALL"
- ✅ "GABUNGAN"
- ✅ Sheet pertama (fallback jika tidak ada yang cocok)

**Case insensitive:** "clean all" = "CLEAN ALL" = "Clean All"

### 2. Label Summary Rows

Parser mengenali berbagai variasi label:

#### WFO:
- ✅ "JUMLAH WFO"
- ✅ "TOTAL WFO"
- ✅ "JML WFO"
- ✅ "WFO"

#### DINAS LUAR:
- ✅ "JUMLAH DINAS LUAR"
- ✅ "TOTAL DINAS LUAR"
- ✅ "JML DINAS LUAR"
- ✅ "DINAS LUAR"

#### UNDANGAN:
- ✅ "JUMLAH UNDANGAN"
- ✅ "TOTAL UNDANGAN"
- ✅ "JML UNDANGAN"
- ✅ "UNDANGAN"

#### SAKIT (Optional):
- ✅ "JUMLAH SAKIT"
- ✅ "TOTAL SAKIT"
- ✅ "JML SAKIT"
- ✅ "SAKIT"

#### IJIN/IZIN:
- ✅ "JUMLAH IJIN" atau "JUMLAH IZIN"
- ✅ "TOTAL IJIN" atau "TOTAL IZIN"
- ✅ "JML IJIN" atau "JML IZIN"
- ✅ "IJIN" atau "IZIN"

#### CUTI:
- ✅ "JUMLAH CUTI"
- ✅ "TOTAL CUTI"
- ✅ "JML CUTI"
- ✅ "CUTI"

#### TIDAK ABSEN:
- ✅ "JUMLAH TIDAK ABSEN"
- ✅ "TOTAL TIDAK ABSEN"
- ✅ "JML TIDAK ABSEN"
- ✅ "TIDAK ABSEN"
- ✅ "ALPHA"
- ✅ "JUMLAH ALPHA"

#### ISOMAN (Optional):
- ✅ "JUMLAH ISOMAN"
- ✅ "TOTAL ISOMAN"
- ✅ "JML ISOMAN"
- ✅ "ISOMAN"
- ✅ "ISOLASI MANDIRI"

**Case insensitive:** Semua label di atas bisa huruf besar/kecil/campuran.

### 3. Struktur Excel

**Contoh untuk bulan 31 hari (Januari, Maret, Mei, Juli, Agustus, Oktober, Desember):**
```
Row 1: Header
| No | Nama | NIP | Satker | Golongan | Eselon | 01 | 02 | 03 | ... | 31 |

Row 2-N: Data Pegawai
| 1  | John | 123 | ...    | ...      | ...    | WFO| WFO| ... | ... |

Row N+1: JUMLAH WFO
| JUMLAH WFO | | | | | | 110 | 102 | 99 | ... | 2475 |
```

**Contoh untuk bulan 30 hari (April, Juni, September, November):**
```
Row 1: Header
| No | Nama | NIP | Satker | Golongan | Eselon | 01 | 02 | 03 | ... | 30 |

Row 2-N: Data Pegawai
| 1  | John | 123 | ...    | ...      | ...    | WFO| WFO| ... | ... |

Row N+1: JUMLAH WFO
| JUMLAH WFO | | | | | | 110 | 102 | 99 | ... | 2400 |
```

**Contoh untuk Februari (28 atau 29 hari):**
```
Row 1: Header
| No | Nama | NIP | Satker | Golongan | Eselon | 01 | 02 | 03 | ... | 28 |

Row 2-N: Data Pegawai
| 1  | John | 123 | ...    | ...      | ...    | WFO| WFO| ... | ... |

Row N+1: JUMLAH WFO
| JUMLAH WFO | | | | | | 110 | 102 | 99 | ... | 2240 |
```

... (dst untuk summary rows lainnya)

**Penting:**
- ✅ Kolom tanggal harus berisi: "01", "02", "03", ..., "28/29/30/31" (string)
- ✅ **TIDAK HARUS 31 hari** - Parser otomatis deteksi jumlah hari di bulan tersebut
  - Februari: 28 atau 29 hari ✅
  - April, Juni, September, November: 30 hari ✅
  - Januari, Maret, Mei, Juli, Agustus, Oktober, Desember: 31 hari ✅
- ✅ Kolom tanggal mulai dari kolom ke-6 atau lebih
- ✅ Header harus ada kata kunci: "No", "Nama", "NIP"
- ✅ Summary rows bisa di mana saja (parser scan dari bawah ke atas)

### 4. Field Required vs Optional

**REQUIRED (Harus ada):**
1. WFO
2. DINAS LUAR
3. UNDANGAN
4. IJIN
5. CUTI
6. TIDAK ABSEN

**OPTIONAL (Boleh tidak ada):**
1. SAKIT (default: 0)
2. ISOMAN (default: 0)

Jika field optional tidak ada, sistem akan set nilai 0 otomatis.

---

## ⚠️ FORMAT YANG BERPOTENSI MASALAH

### 1. Label Tidak Standar

❌ **TIDAK DIDUKUNG:**
- "JUMLAH KERJA" (bukan WFO)
- "TUGAS LUAR" (bukan DINAS LUAR)
- "MANGKIR" (bukan TIDAK ABSEN)
- "PERMIT" (bukan IJIN)

**Solusi:** Gunakan label standar yang ada di daftar di atas.

### 2. Kolom Tanggal Tidak Standar

❌ **TIDAK DIDUKUNG:**
- Kolom tanggal: "A", "B", "C" (bukan "01", "02", "03")
- Kolom tanggal: 1, 2, 3 (number, bukan string "01", "02", "03")
- Kolom tanggal: "Senin", "Selasa", "Rabu" (nama hari)

✅ **DIDUKUNG:**
- Kolom tanggal: "01", "02", ..., "28" (Februari)
- Kolom tanggal: "01", "02", ..., "30" (April, Juni, September, November)
- Kolom tanggal: "01", "02", ..., "31" (bulan lainnya)
- **Parser otomatis deteksi jumlah hari, tidak harus 31!**

**Solusi:** Gunakan format "01", "02", "03", ..., "28/29/30/31" (string dengan leading zero) sesuai jumlah hari di bulan tersebut.

### 3. Header Tidak Standar

❌ **TIDAK DIDUKUNG:**
- Header tanpa "No", "Nama", "NIP"
- Header dengan bahasa Inggris: "Number", "Name", "ID"

**Solusi:** Pastikan header memiliki minimal: "No", "Nama", "NIP".

### 4. Struktur Berbeda Total

❌ **TIDAK DIDUKUNG:**
- Data pegawai tidak ada (hanya summary)
- Summary rows di tengah data pegawai
- Multiple summary sections

**Solusi:** Ikuti struktur standar: Header → Data Pegawai → Summary Rows.

---

## 🛡️ TIPS UNTUK KEAMANAN DATA

### 1. Konsistensi Format
Gunakan template yang sama untuk semua bulan. Jangan ubah:
- Nama kolom header
- Urutan kolom
- Format label summary

### 2. Validasi Sebelum Upload
Sebelum upload, pastikan:
- ✅ Sheet GABUNGAN ada (nama: "ALL CLEAN", "CLEAN", dll)
- ✅ Ada baris "JUMLAH WFO" (atau variasi lainnya)
- ✅ Kolom tanggal berisi "01"-"31"
- ✅ Data tidak ada yang kosong di summary rows

### 3. Cek Console Log
Setelah upload, cek console log (F12) untuk melihat:
```
✅ Found "JUMLAH WFO" at row X → wfo
✅ Found all 6 required summary rows (including WFO)
✅ Extracted 23 rows from "GABUNGAN"
```

Jika ada error, log akan menunjukkan field mana yang tidak ditemukan.

### 4. Backup Data
Sebelum upload bulan baru:
1. Export data bulan sebelumnya dari database
2. Simpan file Excel asli
3. Test upload di mode REPLACE (bukan INSERT)

---

## 📋 CHECKLIST SEBELUM UPLOAD

- [ ] Sheet GABUNGAN ada dengan nama standar
- [ ] Header memiliki "No", "Nama", "NIP"
- [ ] Kolom tanggal berisi "01"-"31"
- [ ] Ada baris "JUMLAH WFO" (atau variasi)
- [ ] Ada baris "JUMLAH DINAS LUAR" (atau variasi)
- [ ] Ada baris "JUMLAH UNDANGAN" (atau variasi)
- [ ] Ada baris "JUMLAH IJIN" (atau variasi)
- [ ] Ada baris "JUMLAH CUTI" (atau variasi)
- [ ] Ada baris "JUMLAH TIDAK ABSEN" (atau variasi)
- [ ] Data summary tidak ada yang kosong
- [ ] Total di Excel sesuai dengan sum manual

---

## 🆘 TROUBLESHOOTING

### Error: "Tidak ditemukan baris summary: WFO"

**Penyebab:**
- Label WFO tidak sesuai format yang didukung
- Baris WFO ada tapi di sheet yang salah
- Typo di label (misal: "JUMLA WFO" tanpa H)

**Solusi:**
1. Cek sheet GABUNGAN, pastikan ada baris dengan label "JUMLAH WFO"
2. Pastikan tidak ada spasi ekstra: "JUMLAH  WFO" (2 spasi)
3. Gunakan salah satu variasi yang didukung

### Error: "Tidak ditemukan kolom tanggal"

**Penyebab:**
- Kolom tanggal tidak berisi "01"-"31"
- Kolom tanggal berupa number, bukan string

**Solusi:**
1. Format kolom tanggal sebagai TEXT
2. Pastikan berisi "01", "02", ..., "31" (dengan leading zero)

### Dashboard menunjukkan angka yang salah

**Penyebab:**
- Data GABUNGAN tidak ter-upload
- Browser cache belum di-refresh

**Solusi:**
1. Hard refresh browser (Ctrl+Shift+R)
2. Cek console log untuk error
3. Jalankan query SQL untuk verifikasi data di database

---

## 📞 KONTAK

Jika menemui masalah yang tidak tercantum di sini, silakan:
1. Screenshot error message di console
2. Export Excel yang bermasalah
3. Hubungi developer dengan informasi di atas
