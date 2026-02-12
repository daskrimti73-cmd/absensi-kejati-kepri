# Setup Supabase Storage untuk File Excel

## Langkah-langkah Setup:

### 1. Buka Supabase Dashboard
- Login ke https://supabase.com
- Pilih project Anda

### 2. Buat Storage Bucket
1. Klik menu **Storage** di sidebar kiri
2. Klik tombol **New bucket**
3. Isi form:
   - **Name**: `excel-files`
   - **Public bucket**: ✅ CENTANG (agar file bisa diakses)
   - **File size limit**: 50 MB
   - **Allowed MIME types**: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel`
4. Klik **Create bucket**

### 3. Setup Policies (Agar File Bisa Diakses)

Setelah bucket dibuat, klik bucket `excel-files`, lalu:

1. Klik tab **Policies**
2. Klik **New Policy**
3. Pilih **For full customization**
4. Buat 3 policies:

#### Policy 1: Allow Public Read
```
Policy name: Public Read Access
Allowed operation: SELECT
Target roles: public
USING expression: true
```

#### Policy 2: Allow Authenticated Upload
```
Policy name: Authenticated Upload
Allowed operation: INSERT
Target roles: authenticated
WITH CHECK expression: true
```

#### Policy 3: Allow Authenticated Delete
```
Policy name: Authenticated Delete
Allowed operation: DELETE
Target roles: authenticated
USING expression: true
```

### 4. Dapatkan Storage URL

Storage URL Anda akan berbentuk:
```
https://[PROJECT_ID].supabase.co/storage/v1/object/public/excel-files/
```

Ganti `[PROJECT_ID]` dengan project ID Anda.

### 5. Test Upload (Opsional)

Coba upload file test:
1. Klik bucket `excel-files`
2. Klik **Upload file**
3. Upload file Excel test
4. Jika berhasil, file akan muncul di list

## Selesai!

Setelah setup selesai, sistem akan otomatis menyimpan file Excel asli ke storage ini saat upload.

## Troubleshooting

**Jika upload gagal:**
- Pastikan bucket sudah public
- Pastikan policies sudah dibuat dengan benar
- Cek console browser (F12) untuk error message

**Jika file tidak bisa diakses:**
- Pastikan bucket public
- Pastikan policy "Public Read Access" sudah aktif
