-- ============================================
-- STEP 1: CEK DATA ABSENSI
-- Copy dan jalankan query ini dulu
-- ============================================
SELECT tahun, bulan, bidang, COUNT(*) as total
FROM absensi
WHERE tahun = 2025
GROUP BY tahun, bulan, bidang
ORDER BY bulan, bidang;


-- ============================================
-- STEP 2: CEK DATA REKAPITULASI
-- Copy dan jalankan query ini
-- ============================================
SELECT tahun, bulan, bidang, COUNT(*) as total
FROM rekapitulasi
WHERE tahun = 2025
GROUP BY tahun, bulan, bidang
ORDER BY bulan, bidang;

-- ============================================
-- STEP 3: CEK TOTAL DATA
-- Copy dan jalankan query ini
-- ============================================
SELECT COUNT(*) as total_absensi FROM absensi WHERE tahun = 2025;

-- ============================================
-- STEP 4: CEK TOTAL REKAPITULASI
-- Copy dan jalankan query ini
-- ============================================
SELECT COUNT(*) as total_rekapitulasi FROM rekapitulasi WHERE tahun = 2025;

-- ============================================
-- STEP 5: HAPUS SEMUA DATA 2025 (HATI-HATI!)
-- Copy dan jalankan query ini untuk menghapus
-- ============================================
DELETE FROM absensi WHERE tahun = 2025;

-- ============================================
-- STEP 6: HAPUS SEMUA REKAPITULASI 2025
-- Copy dan jalankan query ini untuk menghapus
-- ============================================
DELETE FROM rekapitulasi WHERE tahun = 2025;

-- ============================================
-- STEP 7: VERIFIKASI SETELAH DELETE
-- Copy dan jalankan query ini untuk verifikasi
-- ============================================
SELECT COUNT(*) as remaining_absensi FROM absensi WHERE tahun = 2025;
SELECT COUNT(*) as remaining_rekapitulasi FROM rekapitulasi WHERE tahun = 2025;
