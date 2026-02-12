-- Check if GABUNGAN data exists for Oktober 2025
SELECT 
    bidang,
    COUNT(*) as total_rows,
    SUM(wfo) as total_wfo,
    SUM(dinas_luar) as total_dinas_luar,
    SUM(undangan) as total_undangan,
    SUM(sakit) as total_sakit,
    SUM(ijin) as total_ijin,
    SUM(cuti) as total_cuti,
    SUM(isoman) as total_isoman,
    SUM(tidak_absen) as total_tidak_absen
FROM absensi
WHERE tahun = 2025 
  AND bulan = 'Oktober'
  AND bidang = 'GABUNGAN'
GROUP BY bidang;

-- Expected result for Oktober:
-- total_rows: 23 (hari kerja)
-- total_wfo: 2475
-- total_dinas_luar: 408
-- total_undangan: 44
-- total_sakit: 8
-- total_ijin: 0
-- total_cuti: 57
-- total_isoman: 0
-- total_tidak_absen: 0
-- TOTAL: 2992

-- Also check all bidang to see if GABUNGAN exists
SELECT DISTINCT bidang
FROM absensi
WHERE tahun = 2025 AND bulan = 'Oktober'
ORDER BY bidang;

-- Check sample data from GABUNGAN
SELECT tanggal, wfo, dinas_luar, undangan, sakit, ijin, cuti, isoman, tidak_absen
FROM absensi
WHERE tahun = 2025 
  AND bulan = 'Oktober' 
  AND bidang = 'GABUNGAN'
ORDER BY tanggal
LIMIT 10;

-- Check REKAPITULASI data (this might be causing the issue)
SELECT bulan, tahun, wfo, dinas_luar, undangan, sakit, ijin, cuti, tidak_absen, total
FROM rekapitulasi
WHERE tahun = 2025 AND bulan = 'Oktober';

-- Expected: Should match GABUNGAN totals, NOT sum of all bidang
