-- ============================================
-- DELETE ALL 2025 REKAPITULASI DATA
-- ============================================
-- Jalankan script ini di Supabase SQL Editor jika Anda juga ingin
-- menghapus data rekapitulasi untuk testing ulang


-- ============================================
-- STEP 1: CEK DATA REKAPITULASI SEBELUM DELETE
-- ============================================

-- Lihat berapa banyak data rekapitulasi yang akan dihapus
SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT bulan) as total_months
FROM rekapitulasi 
WHERE tahun = 2025;

-- Expected: Akan muncul jumlah data yang ada saat ini


-- ============================================
-- STEP 2: DELETE SEMUA DATA REKAPITULASI 2025
-- ============================================

DELETE FROM rekapitulasi WHERE tahun = 2025;

-- Expected: "DELETE X" (X = jumlah rows yang dihapus)


-- ============================================
-- STEP 3: VERIFIKASI SETELAH DELETE
-- ============================================

-- Cek apakah masih ada data rekapitulasi 2025 (harusnya 0)
SELECT COUNT(*) as remaining_data 
FROM rekapitulasi 
WHERE tahun = 2025;

-- Expected: 0


-- ============================================
-- SELESAI!
-- ============================================
-- Data rekapitulasi tahun 2025 sudah dihapus
-- Anda bisa upload ulang dari Admin Panel
