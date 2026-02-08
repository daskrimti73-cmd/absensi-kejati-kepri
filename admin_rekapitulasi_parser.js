// ============================================
// REKAPITULASI PARSER v1.0.0
// ============================================
// Parser untuk membaca sheet REKAPITULASI dari Excel

/**
 * Parse sheet REKAPITULASI dan ekstrak data kehadiran keseluruhan
 * ROBUST PARSER - Menangani berbagai variasi format dan posisi data
 * @param {Object} workbook - XLSX workbook object
 * @param {string} bulan - Nama bulan (e.g., "Desember")
 * @param {number} tahun - Tahun (e.g., 2025)
 * @returns {Object|null} Data rekapitulasi atau null jika tidak ditemukan
 */
function parseRekapitulasi(workbook, bulan, tahun) {
    console.log('📊 Parsing REKAPITULASI sheet...');
    
    // Cari sheet REKAPITULASI (case-insensitive, flexible matching)
    const sheetNames = workbook.SheetNames;
    const rekapSheet = sheetNames.find(name => {
        const nameUpper = name.toUpperCase().trim();
        return nameUpper.includes('REKAPITULASI') || 
               nameUpper.includes('REKAP') ||
               nameUpper === 'REKAPITULASI' ||
               nameUpper === 'REKAP';
    });
    
    if (!rekapSheet) {
        console.log('⚠️ Sheet REKAPITULASI tidak ditemukan');
        console.log('   Available sheets:', sheetNames.join(', '));
        return null;
    }
    
    console.log(`✅ Found sheet: "${rekapSheet}"`);
    
    // Convert sheet to JSON
    const sheet = workbook.Sheets[rekapSheet];
    const data = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '' });
    
    console.log(`📄 Sheet has ${data.length} rows`);
    
    // Cari section "KEHADIRAN KESELURUHAN" di SELURUH sheet (scan all cells)
    let startRow = -1;
    let startCol = -1;
    
    for (let i = 0; i < data.length; i++) {
        const row = data[i];
        for (let j = 0; j < row.length; j++) {
            const cell = String(row[j] || '').toUpperCase().trim();
            // Flexible matching: bisa "KEHADIRAN KESELURUHAN" atau hanya "KEHADIRAN"
            if ((cell.includes('KEHADIRAN') && cell.includes('KESELURUHAN')) || 
                cell === 'KEHADIRAN KESELURUHAN') {
                startRow = i;
                startCol = j;
                console.log(`✅ Found "KEHADIRAN KESELURUHAN" at row ${i}, col ${j}`);
                break;
            }
        }
        if (startRow !== -1) break;
    }
    
    // Jika tidak ditemukan "KEHADIRAN KESELURUHAN", coba cari langsung data WFO
    if (startRow === -1) {
        console.log('⚠️ Section "KEHADIRAN KESELURUHAN" tidak ditemukan, mencari data WFO langsung...');
        
        // Scan seluruh sheet untuk mencari baris dengan label WFO, DINAS LUAR, dll
        for (let i = 0; i < data.length; i++) {
            const row = data[i];
            for (let j = 0; j < row.length; j++) {
                const cell = String(row[j] || '').toUpperCase().trim();
                if (cell === 'WFO' || cell === 'JENIS KEHADIRAN') {
                    startRow = i;
                    startCol = j;
                    console.log(`✅ Found data starting at row ${i}, col ${j}`);
                    break;
                }
            }
            if (startRow !== -1) break;
        }
    }
    
    if (startRow === -1) {
        console.log('❌ Tidak dapat menemukan data kehadiran di sheet REKAPITULASI');
        return null;
    }
    
    // Parse data dari baris berikutnya
    const rekapData = {
        bulan: bulan,
        tahun: tahun,
        wfo: 0,
        dinas_luar: 0,
        undangan: 0,
        sakit: 0,
        ijin: 0,
        cuti: 0,
        tidak_absen: 0,
        total: 0
    };
    
    // Mapping label ke key (dengan berbagai variasi)
    const labelMap = [
        { patterns: ['WFO'], key: 'wfo' },
        { patterns: ['DINAS LUAR', 'DINAS', 'LUAR'], key: 'dinas_luar' },
        { patterns: ['UNDANGAN'], key: 'undangan' },
        { patterns: ['SAKIT'], key: 'sakit' },
        { patterns: ['IJIN', 'IZIN'], key: 'ijin' },
        { patterns: ['CUTI'], key: 'cuti' },
        { patterns: ['TIDAK ABSEN', 'ALPHA', 'ALPA', 'TANPA KETERANGAN'], key: 'tidak_absen' },
        { patterns: ['TOTAL'], key: 'total' }
    ];
    
    // Scan hingga 50 baris setelah header untuk mencari data
    // (lebih banyak untuk menangani posisi data yang berbeda-beda)
    for (let i = startRow + 1; i < Math.min(startRow + 50, data.length); i++) {
        const row = data[i];
        if (!row || row.length === 0) continue;
        
        // Scan semua kolom di baris ini untuk mencari label
        for (let colIdx = 0; colIdx < row.length; colIdx++) {
            const label = String(row[colIdx] || '').toUpperCase().trim();
            if (!label) continue;
            
            // Cek apakah label cocok dengan salah satu pattern
            for (const { patterns, key } of labelMap) {
                let matched = false;
                
                for (const pattern of patterns) {
                    if (label === pattern || label.includes(pattern)) {
                        matched = true;
                        break;
                    }
                }
                
                if (matched) {
                    // Cari nilai di kolom sebelah kanan
                    let value = 0;
                    for (let valueCol = colIdx + 1; valueCol < row.length; valueCol++) {
                        const cellValue = row[valueCol];
                        const numValue = parseInt(cellValue);
                        if (!isNaN(numValue) && numValue > 0) {
                            value = numValue;
                            break;
                        }
                    }
                    
                    if (value > 0 || key === 'ijin') { // ijin bisa 0
                        rekapData[key] = value;
                        console.log(`  ✅ ${patterns[0]}: ${value} (found at row ${i}, col ${colIdx})`);
                    }
                    break;
                }
            }
        }
    }
    
    // Validasi: pastikan minimal ada data WFO
    if (rekapData.wfo === 0 && rekapData.total === 0) {
        console.log('⚠️ Data rekapitulasi tidak valid (WFO dan TOTAL = 0)');
        return null;
    }
    
    console.log('📊 Rekapitulasi data parsed successfully:', rekapData);
    return rekapData;
}

/**
 * Upload data rekapitulasi ke Supabase
 * @param {Object} supabaseClient - Supabase client instance
 * @param {Object} rekapData - Data rekapitulasi
 * @returns {Promise<boolean>} Success status
 */
async function uploadRekapitulasi(supabaseClient, rekapData) {
    console.log('📤 Uploading rekapitulasi to Supabase...');
    
    try {
        // Check if data already exists
        const { data: existing, error: checkError } = await supabaseClient
            .from('rekapitulasi')
            .select('*')
            .eq('tahun', rekapData.tahun)
            .eq('bulan', rekapData.bulan);
        
        if (checkError) {
            console.error('❌ Error checking existing data:', checkError);
            return false;
        }
        
        if (existing && existing.length > 0) {
            // Update existing record
            console.log('🔄 Updating existing rekapitulasi...');
            const { error: updateError } = await supabaseClient
                .from('rekapitulasi')
                .update(rekapData)
                .eq('tahun', rekapData.tahun)
                .eq('bulan', rekapData.bulan);
            
            if (updateError) {
                console.error('❌ Error updating rekapitulasi:', updateError);
                return false;
            }
            
            console.log('✅ Rekapitulasi updated successfully');
        } else {
            // Insert new record
            console.log('➕ Inserting new rekapitulasi...');
            const { error: insertError } = await supabaseClient
                .from('rekapitulasi')
                .insert([rekapData]);
            
            if (insertError) {
                console.error('❌ Error inserting rekapitulasi:', insertError);
                return false;
            }
            
            console.log('✅ Rekapitulasi inserted successfully');
        }
        
        return true;
    } catch (error) {
        console.error('❌ Error uploading rekapitulasi:', error);
        return false;
    }
}
