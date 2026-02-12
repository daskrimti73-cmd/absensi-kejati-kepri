-- ============================================
-- ADD ISOMAN COLUMN TO ABSENSI TABLE
-- ============================================
-- Jalankan script ini di Supabase SQL Editor


-- ============================================
-- STEP 1: ADD ISOMAN COLUMN
-- ============================================

-- Tambah kolom isoman (default 0)
ALTER TABLE absensi 
ADD COLUMN IF NOT EXISTS isoman INTEGER DEFAULT 0;

-- Expected: "ALTER TABLE"


-- ============================================
-- STEP 2: VERIFY COLUMN ADDED
-- ============================================

-- Cek struktur table (isoman harus ada)
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'absensi'
ORDER BY ordinal_position;

-- Expected: Kolom 'isoman' muncul di list


-- ============================================
-- STEP 3: UPDATE EXISTING DATA (OPTIONAL)
-- ============================================

-- Set isoman = 0 untuk semua data existing (jika belum ada)
UPDATE absensi SET isoman = 0 WHERE isoman IS NULL;

-- Expected: "UPDATE X" (X = jumlah rows yang diupdate)


-- ============================================
-- SELESAI!
-- ============================================
-- Kolom isoman sudah ditambahkan
-- Sekarang parser bisa membaca dan menyimpan data ISOMAN
