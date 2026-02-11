# 🔐 Informasi Login Admin Panel

## Kredensial Login

**Username:** `4BS3NSI66`  
**Password:** `K3J4T12020`

## URL Akses

- **Login Page:** `https://[your-github-pages-url]/login.html`
- **Admin Panel:** `https://[your-github-pages-url]/admin.html` (otomatis redirect ke login jika belum login)
- **Dashboard Publik:** `https://[your-github-pages-url]/index.html`

## Fitur Keamanan

### ✅ Session Management
- Session berlaku selama **8 jam** setelah login
- Setelah 8 jam, otomatis logout dan harus login ulang
- Session disimpan di browser (sessionStorage)

### ✅ Auto-Redirect
- Jika belum login, otomatis redirect ke halaman login
- Jika sudah login dan buka login.html, otomatis redirect ke admin panel
- Jika session expired, otomatis logout dan redirect ke login

### ✅ Logout Button
- Tombol logout tersedia di pojok kanan atas admin panel
- Konfirmasi sebelum logout
- Setelah logout, redirect ke halaman login

## Cara Menggunakan

### 1. Login Pertama Kali
1. Buka `login.html`
2. Masukkan username: `4BS3NSI66`
3. Masukkan password: `K3J4T12020`
4. Klik "Masuk ke Admin Panel"
5. Otomatis redirect ke `admin.html`

### 2. Upload Data
1. Setelah login, Anda akan berada di admin panel
2. Pilih bulan dan tahun
3. Upload file Excel
4. Klik "Upload ke Database"

### 3. Logout
1. Klik tombol "🚪 Logout" di pojok kanan atas
2. Konfirmasi logout
3. Otomatis redirect ke halaman login

## Keamanan

⚠️ **PENTING:**
- Kredensial disimpan di client-side (browser)
- Untuk keamanan maksimal, sebaiknya gunakan backend authentication
- Jangan share kredensial ke orang yang tidak berwenang
- Ganti password secara berkala

## Troubleshooting

### Tidak bisa login?
- Pastikan username dan password benar (case-sensitive)
- Cek apakah JavaScript enabled di browser
- Clear browser cache dan coba lagi

### Session expired terus?
- Session berlaku 8 jam
- Jika tidak aktif, browser mungkin clear sessionStorage
- Login ulang untuk membuat session baru

### Tombol logout tidak muncul?
- Hard refresh browser (Ctrl+Shift+R)
- Clear cache
- Pastikan sudah login dengan benar

## Update Kredensial

Jika ingin mengganti username/password, edit file `login.html`:

```javascript
// Baris 234-235
const VALID_USERNAME = '4BS3NSI66';  // Ganti username di sini
const VALID_PASSWORD = 'K3J4T12020'; // Ganti password di sini
```

---

© 2025 Kejaksaan Tinggi Kepulauan Riau
