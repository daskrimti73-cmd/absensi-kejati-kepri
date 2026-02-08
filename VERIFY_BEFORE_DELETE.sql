-- ============================================
-- VERIFY DATA BEFORE DELETE
-- ============================================
-- Query untuk melihat data tahun 2025 sebelum dihapus

-- 1. Lihat ringkasan data absensi per bulan
SELECT 
    bulan,
    bidang,
    COUNT(*) as jumlah_rows,
    SUM(wfo) as total_wfo,
    SUM(dinas_luar) as total_dinas_luar,
    SUM(tidak_absen) as total_tidak_absen
FROM absensi 
WHERE tahun = 2025
GROUP BY bulan, bidang
ORDER BY bulan, bidang;

-- 2. Lihat total data absensi tahun 2025
SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT bulan) as jumlah_bulan,
    COUNT(DISTINCT bidang) as jumlah_bidang
FROM absensi 
WHERE tahun = 2025;

-- 3. Lihat data rekapitulasi tahun 2025 (jika ada)
SELECT * FROM rekapitulasi WHERE tahun = 2025 ORDER BY bulan;

-- 4. Lihat bulan apa saja yang ada
SELECT DISTINCT bulan FROM absensi WHERE tahun = 2025 ORDER BY bulan;

-- 5. Lihat bidang apa saja yang ada
SELECT DISTINCT bidang FROM absensi WHERE tahun = 2025 ORDER BY bidang;
