-- ============================================
-- QUICK DELETE AND VERIFY SCRIPT
-- Version: 3.1.1
-- Date: 7 Februari 2026
-- ============================================

-- ============================================
-- STEP 1: BACKUP (Optional)
-- ============================================
-- Jika ingin backup, export dulu sebelum delete
-- Supabase Dashboard → Table Editor → Export to CSV


-- ============================================
-- STEP 2: DELETE ALL 2025 DATA
-- ============================================

-- Delete semua data tahun 2025
DELETE FROM absensi WHERE tahun = 2025;

-- Expected: Deleted X rows (tergantung berapa banyak data sebelumnya)


-- ============================================
-- STEP 3: VERIFY DELETE
-- ============================================

-- Cek apakah masih ada data 2025 (harusnya 0)
SELECT COUNT(*) as remaining_2025_data 
FROM absensi 
WHERE tahun = 2025;
-- Expected: 0


-- ============================================
-- STEP 4: AFTER UPLOAD - VERIFY DATA
-- ============================================

-- A. Cek total data per bulan
SELECT 
    bulan,
    COUNT(*) as total_rows,
    COUNT(DISTINCT bidang) as total_bidang,
    COUNT(DISTINCT tanggal) as total_dates
FROM absensi 
WHERE tahun = 2025
GROUP BY bulan
ORDER BY 
    CASE bulan
        WHEN 'Januari' THEN 1
        WHEN 'Februari' THEN 2
        WHEN 'Maret' THEN 3
        WHEN 'April' THEN 4
        WHEN 'Mei' THEN 5
        WHEN 'Juni' THEN 6
        WHEN 'Juli' THEN 7
        WHEN 'Agustus' THEN 8
        WHEN 'September' THEN 9
        WHEN 'Oktober' THEN 10
        WHEN 'November' THEN 11
        WHEN 'Desember' THEN 12
    END;

-- Expected per bulan:
-- total_rows: ~180 (20 dates × 9 bidang)
-- total_bidang: 9 (8 bidang + GABUNGAN)
-- total_dates: ~20 (hari kerja dalam bulan)


-- B. Cek GABUNGAN data (harus ada untuk semua bulan)
SELECT 
    bulan,
    COUNT(*) as gabungan_dates,
    SUM(wfo) as total_wfo,
    SUM(dinas_luar) as total_dinas_luar,
    SUM(undangan) as total_undangan,
    SUM(sakit) as total_sakit,
    SUM(ijin) as total_ijin,
    SUM(cuti) as total_cuti,
    SUM(tidak_absen) as total_tidak_absen
FROM absensi 
WHERE tahun = 2025 AND bidang = 'GABUNGAN'
GROUP BY bulan
ORDER BY 
    CASE bulan
        WHEN 'Mei' THEN 5
        WHEN 'Juni' THEN 6
        WHEN 'Juli' THEN 7
        WHEN 'Agustus' THEN 8
        WHEN 'September' THEN 9
        WHEN 'Oktober' THEN 10
        WHEN 'November' THEN 11
        WHEN 'Desember' THEN 12
    END;

-- Expected:
-- Semua bulan harus ada (gabungan_dates > 0)
-- Total WFO, Dinas Luar, dll harus match dengan Excel


-- C. Cek semua bidang (harus ada 9 bidang termasuk GABUNGAN)
SELECT DISTINCT bidang 
FROM absensi 
WHERE tahun = 2025
ORDER BY bidang;

-- Expected (9 bidang):
-- DATUN
-- GABUNGAN
-- HUKUM & HUBUNGAN MASYARAKAT
-- INTELIJEN
-- KOORDINATOR
-- PEMBINAAN
-- PERDATA TUN
-- PIDUM
-- PIDSUS


-- D. Cek detail per bidang per bulan (untuk validasi mendalam)
SELECT 
    bulan,
    bidang,
    COUNT(*) as dates,
    SUM(wfo) as wfo,
    SUM(dinas_luar) as dinas_luar,
    SUM(undangan) as undangan,
    SUM(sakit) as sakit,
    SUM(ijin) as ijin,
    SUM(cuti) as cuti,
    SUM(tidak_absen) as tidak_absen,
    SUM(wfo + dinas_luar + undangan + sakit + ijin + cuti + tidak_absen) as total
FROM absensi 
WHERE tahun = 2025
GROUP BY bulan, bidang
ORDER BY 
    CASE bulan
        WHEN 'Mei' THEN 5
        WHEN 'Juni' THEN 6
        WHEN 'Juli' THEN 7
        WHEN 'Agustus' THEN 8
        WHEN 'September' THEN 9
        WHEN 'Oktober' THEN 10
        WHEN 'November' THEN 11
        WHEN 'Desember' THEN 12
    END,
    bidang;

-- Bandingkan hasil ini dengan Excel untuk setiap bulan dan bidang


-- E. Cek apakah ada duplicate data (harusnya 0)
SELECT 
    tahun,
    bulan,
    tanggal,
    bidang,
    COUNT(*) as duplicate_count
FROM absensi 
WHERE tahun = 2025
GROUP BY tahun, bulan, tanggal, bidang
HAVING COUNT(*) > 1;

-- Expected: No rows (tidak ada duplicate)


-- F. Cek apakah GABUNGAN = Sum of all bidang (untuk 1 bulan sample)
-- Ganti 'November' dengan bulan yang ingin dicek
WITH bidang_sum AS (
    SELECT 
        tanggal,
        SUM(wfo) as sum_wfo,
        SUM(dinas_luar) as sum_dinas_luar,
        SUM(undangan) as sum_undangan,
        SUM(sakit) as sum_sakit,
        SUM(ijin) as sum_ijin,
        SUM(cuti) as sum_cuti,
        SUM(tidak_absen) as sum_tidak_absen
    FROM absensi 
    WHERE tahun = 2025 
        AND bulan = 'November' 
        AND bidang != 'GABUNGAN'
    GROUP BY tanggal
),
gabungan_data AS (
    SELECT 
        tanggal,
        wfo as gabungan_wfo,
        dinas_luar as gabungan_dinas_luar,
        undangan as gabungan_undangan,
        sakit as gabungan_sakit,
        ijin as gabungan_ijin,
        cuti as gabungan_cuti,
        tidak_absen as gabungan_tidak_absen
    FROM absensi 
    WHERE tahun = 2025 
        AND bulan = 'November' 
        AND bidang = 'GABUNGAN'
)
SELECT 
    b.tanggal,
    b.sum_wfo,
    g.gabungan_wfo,
    CASE WHEN b.sum_wfo = g.gabungan_wfo THEN '✅' ELSE '❌' END as wfo_match,
    b.sum_dinas_luar,
    g.gabungan_dinas_luar,
    CASE WHEN b.sum_dinas_luar = g.gabungan_dinas_luar THEN '✅' ELSE '❌' END as dl_match
FROM bidang_sum b
JOIN gabungan_data g ON b.tanggal = g.tanggal
ORDER BY b.tanggal;

-- Expected: Semua kolom *_match harus '✅'
-- Jika ada '❌', berarti GABUNGAN tidak match dengan sum bidang


-- ============================================
-- TROUBLESHOOTING QUERIES
-- ============================================

-- T1. Cek bulan mana yang belum diupload
SELECT 
    m.month_name,
    CASE WHEN a.bulan IS NULL THEN '❌ MISSING' ELSE '✅ EXISTS' END as status
FROM (
    SELECT 'Mei' as month_name UNION ALL
    SELECT 'Juni' UNION ALL
    SELECT 'Juli' UNION ALL
    SELECT 'Agustus' UNION ALL
    SELECT 'September' UNION ALL
    SELECT 'Oktober' UNION ALL
    SELECT 'November' UNION ALL
    SELECT 'Desember'
) m
LEFT JOIN (
    SELECT DISTINCT bulan 
    FROM absensi 
    WHERE tahun = 2025
) a ON m.month_name = a.bulan
ORDER BY 
    CASE m.month_name
        WHEN 'Mei' THEN 5
        WHEN 'Juni' THEN 6
        WHEN 'Juli' THEN 7
        WHEN 'Agustus' THEN 8
        WHEN 'September' THEN 9
        WHEN 'Oktober' THEN 10
        WHEN 'November' THEN 11
        WHEN 'Desember' THEN 12
    END;


-- T2. Cek bidang mana yang missing untuk bulan tertentu
-- Ganti 'November' dengan bulan yang ingin dicek
SELECT 
    b.bidang_name,
    CASE WHEN a.bidang IS NULL THEN '❌ MISSING' ELSE '✅ EXISTS' END as status
FROM (
    SELECT 'PEMBINAAN' as bidang_name UNION ALL
    SELECT 'DATUN' UNION ALL
    SELECT 'KOORDINATOR' UNION ALL
    SELECT 'INTELIJEN' UNION ALL
    SELECT 'PIDUM' UNION ALL
    SELECT 'PIDSUS' UNION ALL
    SELECT 'PERDATA TUN' UNION ALL
    SELECT 'HUKUM & HUBUNGAN MASYARAKAT' UNION ALL
    SELECT 'GABUNGAN'
) b
LEFT JOIN (
    SELECT DISTINCT bidang 
    FROM absensi 
    WHERE tahun = 2025 AND bulan = 'November'
) a ON b.bidang_name = a.bidang
ORDER BY b.bidang_name;


-- T3. Cek tanggal mana yang missing untuk bulan dan bidang tertentu
-- Ganti 'November' dan 'GABUNGAN' sesuai kebutuhan
SELECT 
    d.date_num,
    CASE WHEN a.tanggal IS NULL THEN '❌ MISSING' ELSE '✅ EXISTS' END as status
FROM (
    SELECT 1 as date_num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
    SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
    SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
    SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
    SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL
    SELECT 24 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL
    SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31
) d
LEFT JOIN (
    SELECT DISTINCT tanggal 
    FROM absensi 
    WHERE tahun = 2025 AND bulan = 'November' AND bidang = 'GABUNGAN'
) a ON d.date_num = a.tanggal
ORDER BY d.date_num;


-- ============================================
-- CLEANUP QUERIES (Jika Ada Masalah)
-- ============================================

-- C1. Delete data bulan tertentu saja
-- DELETE FROM absensi WHERE tahun = 2025 AND bulan = 'November';

-- C2. Delete data bidang tertentu untuk bulan tertentu
-- DELETE FROM absensi WHERE tahun = 2025 AND bulan = 'November' AND bidang = 'GABUNGAN';

-- C3. Delete duplicate data (keep only first occurrence)
-- DELETE FROM absensi a
-- USING absensi b
-- WHERE a.id > b.id
--   AND a.tahun = b.tahun
--   AND a.bulan = b.bulan
--   AND a.tanggal = b.tanggal
--   AND a.bidang = b.bidang;


-- ============================================
-- NOTES
-- ============================================
-- 1. Jalankan query satu per satu, jangan sekaligus
-- 2. Cek hasil setiap query sebelum lanjut
-- 3. Bandingkan hasil dengan Excel untuk validasi
-- 4. Jika ada yang tidak match, cek Console (F12) saat upload
-- 5. Gunakan troubleshooting queries untuk debug
