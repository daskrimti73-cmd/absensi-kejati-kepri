-- ============================================
-- DELETE ALL 2025 DATA FOR TESTING
-- ============================================
-- Query untuk menghapus semua data tahun 2025
-- Gunakan ini untuk testing upload ulang

-- 1. Hapus data absensi tahun 2025
DELETE FROM absensi WHERE tahun = 2025;

-- 2. Hapus data rekapitulasi tahun 2025 (jika tabel sudah dibuat)
DELETE FROM rekapitulasi WHERE tahun = 2025;

-- 3. Verifikasi data sudah terhapus
SELECT 'absensi' as tabel, COUNT(*) as jumlah_data FROM absensi WHERE tahun = 2025
UNION ALL
SELECT 'rekapitulasi' as tabel, COUNT(*) as jumlah_data FROM rekapitulasi WHERE tahun = 2025;

-- Expected result: 
-- absensi: 0
-- rekapitulasi: 0
