-- ============================================
-- ALTER TABLE: Tambah Kolom Persentase
-- ============================================
-- Menambahkan kolom persentase untuk setiap jenis kehadiran
-- Persentase akan dibaca langsung dari Excel (jika ada)
-- Format: DECIMAL(5,2) untuk menyimpan nilai seperti 84.40

ALTER TABLE rekapitulasi
ADD COLUMN IF NOT EXISTS wfo_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS dinas_luar_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS undangan_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS sakit_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS ijin_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS cuti_pct DECIMAL(5,2),
ADD COLUMN IF NOT EXISTS tidak_absen_pct DECIMAL(5,2);

-- Verifikasi struktur tabel
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'rekapitulasi'
ORDER BY ordinal_position;
