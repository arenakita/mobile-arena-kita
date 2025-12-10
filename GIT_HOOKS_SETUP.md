# 🛡️ Panduan Setup Git Hooks (Wajib untuk Developer)

Dokumen ini menjelaskan cara memasang **Local Git Hook** untuk menjaga kualitas kode tim ArenaKita.

## 🎯 Mengapa ini diperlukan?
Untuk mencegah kode yang error atau berantakan masuk ke repositori (`develop`/`main`). 

Dengan script ini, setiap kali Anda melakukan `git push`, sistem akan otomatis menjalankan `flutter analyze`. 
* **Jika Aman:** Push akan dilanjutkan.
* **Jika Error:** Push akan dibatalkan otomatis.

---

## ⚙️ Cara Pemasangan (Sekali Saja)

Ikuti langkah di bawah ini sesuai sistem operasi Anda.

### 🍎 Untuk Pengguna Mac / 🐧 Linux

1.  Buka Terminal di folder project ini.
2.  Jalankan perintah berikut untuk membuat file hook:
    ```bash
    touch .git/hooks/pre-push
    ```
3.  Buka file tersebut dengan text editor (Nano/Vim/VS Code), lalu tempelkan **Script Hook** yang ada di bawah halaman ini.
4.  Simpan file.
5.  Berikan izin eksekusi dengan perintah:
    ```bash
    chmod +x .git/hooks/pre-push
    ```

### 🪟 Untuk Pengguna Windows

1.  Pastikan Anda menggunakan **Git Bash** atau terminal yang mendukung perintah Unix.
2.  Masuk ke folder `.git/hooks` di dalam project (Folder `.git` biasanya tersembunyi/hidden).
3.  Buat file baru bernama `pre-push` (Tanpa ekstensi .txt atau apapun).
4.  Buka file tersebut dengan Notepad/VS Code.
5.  Tempelkan **Script Hook** di bawah ini.
6.  Simpan file.

> **PENTING (User Windows):** > Pastikan format baris file adalah **LF**, bukan CRLF.
> Lihat bagian Troubleshooting di bawah jika mengalami error.

---

## 📜 Script Hook (Copy-Paste Ini)

Salin kode di bawah ini ke dalam file `.git/hooks/pre-push` yang baru saja Anda buat.

```bash
#!/bin/sh

echo "-----------------------------------------------------------"
echo "🔍  AUTO-CHECK: Running Flutter Analyze before pushing..."
echo "-----------------------------------------------------------"

# Jalankan analisis flutter
flutter analyze

# Cek hasil exit code dari flutter analyze
# 0 = Sukses (Tidak ada error)
# Bukan 0 = Ada Error
if [ $? -ne 0 ]; then
  echo " "
  echo "❌  PUSH DIBATALKAN!"
  echo "⚠️   Ditemukan error pada kode Anda (Lihat log di atas)."
  echo "🛠️   Silakan perbaiki error tersebut, lalu lakukan commit & push ulang."
  echo "-----------------------------------------------------------"
  exit 1
fi

echo " "
echo "✅  KODE AMAN. Melanjutkan proses Push..."
echo "-----------------------------------------------------------"
exit 0