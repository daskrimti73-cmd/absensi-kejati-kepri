-- ============================================
-- PREVENT DUPLICATES - Database Level Protection
-- Version: 3.1.2
-- Date: 7 Februari 2026
-- ============================================

-- ============================================
-- STEP 1: CHECK FOR EXISTING DUPLICATES
-- ============================================

-- Check if there are any duplicates in current data
SELECT 
    tahun,
    bulan,
    tanggal,
    bidang,
    COUNT(*) as duplicate_count
FROM absensi
GROUP BY tahun, bulan, tanggal, bidang
HAVING COUNT(*) > 1
ORDER BY tahun, bulan, tanggal, bidang;

-- Expected: No rows (if no duplicates exist)
-- If rows returned: You have duplicates that need to be cleaned first


-- ============================================
-- STEP 2: CLEAN EXISTING DUPLICATES (if any)
-- ============================================

-- Option A: Keep first occurrence, delete rest
DELETE FROM absensi a
USING absensi b
WHERE a.id > b.id
  AND a.tahun = b.tahun
  AND a.bulan = b.bulan
  AND a.tanggal = b.tanggal
  AND a.bidang = b.bidang;

-- Expected: Deleted X rows (where X = number of duplicate rows)


-- Option B: Delete all duplicates, then re-upload
-- (Use this if you want to start fresh)
/*
DELETE FROM absensi
WHERE (tahun, bulan, tanggal, bidang) IN (
    SELECT tahun, bulan, tanggal, bidang
    FROM absensi
    GROUP BY tahun, bulan, tanggal, bidang
    HAVING COUNT(*) > 1
);
-- Then re-upload the data using admin.html
*/


-- ============================================
-- STEP 3: ADD UNIQUE CONSTRAINT
-- ============================================

-- Add unique constraint to prevent future duplicates
-- This ensures (tahun, bulan, tanggal, bidang) combination is unique

ALTER TABLE absensi
ADD CONSTRAINT unique_absensi_record
UNIQUE (tahun, bulan, tanggal, bidang);

-- Expected: ALTER TABLE (success)
-- If error: Check if duplicates still exist (run STEP 1 again)


-- ============================================
-- STEP 4: VERIFY CONSTRAINT
-- ============================================

-- Check if constraint was added successfully
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    pg_get_constraintdef(oid) as constraint_definition
FROM pg_constraint
WHERE conrelid = 'absensi'::regclass
  AND conname = 'unique_absensi_record';

-- Expected: 1 row showing the unique constraint


-- ============================================
-- STEP 5: TEST DUPLICATE PREVENTION
-- ============================================

-- Try to insert duplicate (should fail)
/*
INSERT INTO absensi (tahun, bulan, tanggal, bidang, wfo, dinas_luar, undangan, sakit, ijin, cuti, tidak_absen)
VALUES (2025, 'November', 1, 'GABUNGAN', 50, 10, 5, 0, 0, 0, 0);

-- First insert: SUCCESS
-- Second insert (same data): ERROR - duplicate key value violates unique constraint
*/


-- ============================================
-- MONITORING QUERIES
-- ============================================

-- M1. Check total rows per month (should not increase unexpectedly)
SELECT 
    tahun,
    bulan,
    COUNT(*) as total_rows,
    COUNT(DISTINCT bidang) as total_bidang,
    COUNT(DISTINCT tanggal) as total_dates
FROM absensi
GROUP BY tahun, bulan
ORDER BY tahun, 
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


-- M2. Check for any anomalies (rows with same key but different values)
-- This shouldn't happen with unique constraint, but good to monitor
SELECT 
    tahun,
    bulan,
    tanggal,
    bidang,
    COUNT(DISTINCT wfo) as distinct_wfo_values,
    COUNT(DISTINCT dinas_luar) as distinct_dl_values
FROM absensi
GROUP BY tahun, bulan, tanggal, bidang
HAVING COUNT(DISTINCT wfo) > 1 OR COUNT(DISTINCT dinas_luar) > 1;

-- Expected: No rows (all values should be consistent)


-- M3. Check database size (monitor growth)
SELECT 
    pg_size_pretty(pg_total_relation_size('absensi')) as total_size,
    pg_size_pretty(pg_relation_size('absensi')) as table_size,
    pg_size_pretty(pg_indexes_size('absensi')) as indexes_size,
    (SELECT COUNT(*) FROM absensi) as total_rows;


-- ============================================
-- ROLLBACK (if needed)
-- ============================================

-- Remove unique constraint (if you need to rollback)
/*
ALTER TABLE absensi
DROP CONSTRAINT IF EXISTS unique_absensi_record;
*/


-- ============================================
-- NOTES
-- ============================================

/*
1. UNIQUE CONSTRAINT BENEFITS:
   - Prevents duplicates at database level (strongest protection)
   - Automatic error if duplicate insert attempted
   - No need to check manually before insert
   - Works even if application logic fails

2. WHAT HAPPENS WITH CONSTRAINT:
   - Replace mode: Works normally (delete old, insert new)
   - Append mode: 
     * If data exists → INSERT fails with error
     * If data doesn't exist → INSERT succeeds
   - This is GOOD - prevents accidental duplicates

3. HANDLING INSERT ERRORS:
   - Application should catch duplicate key errors
   - Show user-friendly message
   - Suggest using Replace mode instead

4. PERFORMANCE IMPACT:
   - Minimal - unique constraint uses index
   - Actually improves query performance
   - Slight overhead on INSERT (negligible)

5. MAINTENANCE:
   - Run M1 query monthly to monitor data growth
   - Run M2 query if you suspect data issues
   - Keep constraint in place (don't remove)

6. BEST PRACTICES:
   - Always use REPLACE mode for re-uploads
   - Use APPEND mode only for new dates
   - Check Console warnings before confirming
   - Monitor database regularly
*/


-- ============================================
-- TROUBLESHOOTING
-- ============================================

-- T1. Error: "duplicate key value violates unique constraint"
-- Solution: Data already exists. Use REPLACE mode or delete old data first.

-- T2. Error: "could not create unique index"
-- Solution: Duplicates exist. Run STEP 2 to clean them first.

-- T3. Want to allow duplicates temporarily
-- Solution: Drop constraint (see ROLLBACK section), but NOT recommended.

-- T4. Check specific month for duplicates
SELECT 
    tanggal,
    bidang,
    COUNT(*) as count
FROM absensi
WHERE tahun = 2025 AND bulan = 'November'
GROUP BY tanggal, bidang
HAVING COUNT(*) > 1;


-- ============================================
-- SUMMARY
-- ============================================

/*
PROTECTION LAYERS:

Layer 1: Application Level (admin.html)
- Check existing data before append
- Show warning to user
- Ask confirmation
- Status: ✅ IMPLEMENTED (v3.1.2)

Layer 2: Database Level (this script)
- Unique constraint on (tahun, bulan, tanggal, bidang)
- Automatic duplicate prevention
- Status: ⚠️ NEEDS TO BE APPLIED (run this script)

RECOMMENDATION:
Apply both layers for maximum protection:
1. Run this SQL script to add unique constraint
2. Use updated admin.html (v3.1.2) with duplicate check
3. Always prefer REPLACE mode over APPEND mode
4. Monitor database regularly

With both layers, duplicates are IMPOSSIBLE! ✅
*/
