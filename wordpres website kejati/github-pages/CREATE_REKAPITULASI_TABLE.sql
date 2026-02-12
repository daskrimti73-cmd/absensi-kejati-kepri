-- ============================================
-- CREATE REKAPITULASI TABLE
-- ============================================
-- Tabel untuk menyimpan data rekapitulasi kehadiran keseluruhan per bulan

CREATE TABLE IF NOT EXISTS rekapitulasi (
    id BIGSERIAL PRIMARY KEY,
    bulan TEXT NOT NULL,
    tahun INTEGER NOT NULL,
    wfo INTEGER DEFAULT 0,
    dinas_luar INTEGER DEFAULT 0,
    undangan INTEGER DEFAULT 0,
    sakit INTEGER DEFAULT 0,
    ijin INTEGER DEFAULT 0,
    cuti INTEGER DEFAULT 0,
    tidak_absen INTEGER DEFAULT 0,
    total INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(bulan, tahun)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_rekapitulasi_bulan_tahun ON rekapitulasi(bulan, tahun);

-- Enable Row Level Security (RLS)
ALTER TABLE rekapitulasi ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access" ON rekapitulasi
    FOR SELECT
    USING (true);

-- Create policy to allow authenticated insert/update
CREATE POLICY "Allow authenticated insert" ON rekapitulasi
    FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Allow authenticated update" ON rekapitulasi
    FOR UPDATE
    USING (true);

-- Add comment
COMMENT ON TABLE rekapitulasi IS 'Tabel rekapitulasi kehadiran keseluruhan per bulan dari sheet REKAPITULASI Excel';
