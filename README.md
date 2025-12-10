# ArenaKita - Owner App (Flutter)

[![ArenaKita Owner CI](https://img.shields.io/badge/build-passing-brightgreen)](https://github.com/arenakita/mobile-arena-kita) 
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev) 
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)](https://dart.dev)

Ini adalah repositori resmi untuk aplikasi mobile **ArenaKita (Khusus Mitra/Owner)**. Aplikasi ini dibangun menggunakan **Flutter** dan berfungsi sebagai alat bantu bagi pemilik lapangan untuk mengelola bisnis venue olahraga mereka secara digital.

Aplikasi ini dikhususkan untuk **Role Owner** dengan fitur utama:
1.  **Manajemen Venue:** Menambah, mengubah, dan menghapus data lapangan.
2.  **Dashboard Bisnis:** Melihat statistik pendapatan dan jumlah pesanan.
3.  **Approval Pesanan:** Menerima atau menolak booking dari penyewa.

## Visi Proyek

Memberdayakan pemilik venue olahraga dengan platform manajemen yang efisien, transparan, dan *real-time* untuk meningkatkan produktivitas bisnis mereka.

## Daftar Isi

* [🚩 Prasyarat (Wajib Terinstal)](#-prasyarat-wajib-terinstal)
* [🚀 Panduan Instalasi Lokal](#-panduan-instalasi-lokal)
  * [1. Clone Repositori](#1-clone-repositori)
  * [2. Instal Dependensi](#2-instal-dependensi)
  * [3. Konfigurasi Koneksi API](#3-konfigurasi-koneksi-api)
  * [4. Jalankan Aplikasi](#4-jalankan-aplikasi)
* [📂 Struktur Folder](#-struktur-folder)
* [💎 Standar Kualitas Kode](#-standar-kualitas-kode)
* [📦 Alur Kerja Git & Kontribusi](#-alur-kerja-git--kontribusi)
  * [1. Branch Utama](#1-branch-utama)
  * [2. Membuat Fitur Baru](#2-membuat-fitur-baru)
  * [3. Pull update terbaru](#3-pull-update-terbaru)
  * [4. Selesai Mengerjakan Fitur](#4-selesai-mengerjakan-fitur)
* [🔌 Format Nama Branch](#-format-nama-branch)
* [📝 Format Pesan Commit](#-format-pesan-commit-conventional-commits)
* [🧲 Format Template Pull Request](#-format-template-pull-request-pr)

## 🚩 Prasyarat (Wajib Terinstal)

Pastikan perangkat Anda memiliki *software* berikut:

* **Flutter SDK:** `^3.19.0` (Stable Channel)
* **Dart SDK:** `^3.3.0`
* **Android Studio / VS Code:** (dengan Extension Flutter & Dart)
* **Java JDK:** `^17` (untuk Gradle build)
* **Android Emulator** atau **Device Fisik** (Developer Mode ON)

## 🚀 Panduan Instalasi Lokal

Langkah-langkah untuk menjalankan proyek ini di komputer lokal Anda.

### 1. Clone Repositori

```bash
git clone https://github.com/arenakita/mobile-arena-kita.git
cd mobile-arena-kita
````

### 2\. Instal Dependensi

Pastikan koneksi internet lancar untuk mengunduh package dari `pub.dev`.

```bash
flutter pub get
```

### 3\. Konfigurasi Koneksi API

Aplikasi mobile perlu tahu alamat IP dari Backend Laravel lokal Anda.

1.  Pastikan Backend Laravel berjalan: `php artisan serve --host=0.0.0.0`
2.  Cek IP Laptop Anda (CMD: `ipconfig` / Terminal: `ifconfig`).
3.  Buka file: `lib/core/constants/api_constants.dart`
4.  Sesuaikan `baseUrl`:

```dart
class ApiConstants {
  // GANTI IP INI:
  // - Gunakan '10.0.2.2' jika menggunakan Emulator Android bawaan.
  // - Gunakan IP LAN (misal '192.168.1.10') jika menggunakan HP Fisik.
  static const String baseUrl = "[http://10.0.2.2:8000/api/v1](http://10.0.2.2:8000/api/v1)"; 
  
  // Endpoint Auth Owner
  static const String login = "$baseUrl/auth/owner/login";
}
```

### 4\. Jalankan Aplikasi

Hubungkan HP atau nyalakan Emulator, lalu jalankan:

```bash
# Mode Debug (dengan Hot Reload)
flutter run

# Mode Profile (untuk cek performa)
flutter run --profile
```

## 📂 Struktur Folder

Proyek ini menggunakan struktur modular. Folder `screens/` difokuskan untuk modul Owner.

```text
lib/
├── core/                # Konfigurasi global
│   ├── constants/       # URL API, Asset Strings
│   └── theme/           # Warna, Font, Style Text
├── models/              # Class Data (Venue, Field, Schedule)
├── services/            # Logika Request API (AuthService, VenueService)
├── screens/             # Tampilan UI (Halaman)
│   ├── auth/            # Login Owner
│   ├── dashboard/       # Statistik & Overview
│   └── venues/          # CRUD Venue & Lapangan
├── widgets/             # Komponen UI Reusable (Card, Button)
└── main.dart            # Entry Point
```

## 💎 Standar Kualitas Kode

Repositori ini menggunakan **flutter\_lints** untuk menjaga konsistensi kode.

Sebelum melakukan commit, sangat disarankan untuk mengecek apakah ada error atau warning:

```bash
flutter analyze
```

Jika ada warning (garis biru/kuning di editor), harap diperbaiki agar kode tetap bersih.

## 📦 Alur Kerja Git & Kontribusi

Kami mengadopsi standar yang sama dengan tim Backend.

#### 1\. Branch Utama:

  * `main`: Hanya untuk kode produksi (rilis stabil/APK siap demo). **DILARANG PUSH LANGSUNG.**
  * `develop`: Branch integrasi. Semua fitur di-merge ke sini terlebih dahulu.

#### 2\. Membuat Fitur Baru:

Selalu buat branch baru dari `develop`.
Gunakan format nama: `feature/[NAMA_FITUR]`

#### 3\. Pull update terbaru:

Sebelum mulai koding, ambil update temanmu:

```bash
git checkout develop
git pull origin develop
```

#### 4\. Selesai Mengerjakan Fitur:

  * Commit pekerjaan dengan pesan yang jelas.
  * Push branch ke GitHub.
  * Buat **Pull Request (PR)** ke `develop`.
  * Tunggu review teman sekelompok.

## 🔌 Format Nama Branch

Gunakan prefix berikut agar rapi:

  - `feat/`: Fitur baru (misal: `feat/owner-dashboard-ui`)
  - `fix/`: Perbaikan bug (misal: `fix/login-validation`)
  - `docs/`: Dokumentasi (misal: `docs/update-readme`)
  - `refactor/`: Merapikan kode tanpa ubah fitur
  - `chore/`: Tugas maintenance (misal: `chore/add-google-fonts`)

## 📝 Format Pesan Commit (Conventional Commits)

Gunakan standar ini agar history Git enak dibaca.

**Format:** `<type>(<scope>): <subject>`

  * `feat`: Fitur baru.
  * `fix`: Perbaikan bug.
  * `chore`: Setup/Maintenance.
  * `docs`: Dokumentasi.

**Contoh Benar:**

  * ✅ `feat(auth): add owner login logic`
  * ✅ `fix(venue): resolve image upload error`
  * ✅ `docs(readme): update installation guide`

**Contoh Salah:**

  * ❌ `nambah login`
  * ❌ `fix error`

## 🧲 Format Template Pull Request (PR)

Saat membuat PR di GitHub, sertakan informasi berikut (sesuai template di `.github/pull_request_template.md`):

1.  **Deskripsi Perubahan**: Apa yang kamu buat?
2.  **Cara Pengujian**: Bagaimana cara tester mencoba fitur ini?
3.  **Bukti (Screenshot)**: **WAJIB** lampirkan screenshot UI sebelum & sesudah.