-- ============================================
-- DELETE ALL 2025 DATA - UNTUK TESTING
-- ============================================
-- Jalankan script ini di Supabase SQL Editor
-- Dashboard → SQL Editor → New Query → Paste & Run


-- ============================================
-- STEP 1: CEK DATA SEBELUM DELETE
-- ============================================

-- Lihat berapa banyak data yang akan dihapus
SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT bulan) as total_months,
    COUNT(DISTINCT bidang) as total_bidang
FROM absensi 
WHERE tahun = 2025;

-- Expected: Akan muncul jumlah data yang ada saat ini


-- ============================================
-- STEP 2: DELETE SEMUA DATA 2025
-- ============================================

DELETE FROM absensi WHERE tahun = 2025;

-- Expected: "DELETE X" (X = jumlah rows yang dihapus)


-- ============================================
-- STEP 3: VERIFIKASI SETELAH DELETE
-- ============================================

-- Cek apakah masih ada data 2025 (harusnya 0)
SELECT COUNT(*) as remaining_data 
FROM absensi 
WHERE tahun = 2025;

-- Expected: 0


-- ============================================
-- STEP 4: CEK SEMUA DATA (OPTIONAL)
-- ============================================

-- Lihat semua data yang tersisa (untuk memastikan)
SELECT tahun, bulan, bidang, COUNT(*) as total
FROM absensi
GROUP BY tahun, bulan, bidang
ORDER BY tahun DESC, bulan, bidang;

-- Expected: Tidak ada data tahun 2025


-- ============================================
-- SELESAI!
-- ============================================
-- Sekarang Anda bisa upload data baru untuk testing
-- Gunakan Admin Panel untuk upload data secara bertahap
