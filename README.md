# 💳 E-Wallet App

Aplikasi E-Wallet sederhana berbasis Flutter yang memungkinkan pengguna untuk login, melihat transaksi, dan mengelola pengaturan akun. integrasi UI/UX, autentikasi, dan manajemen state menggunakan GetX.

✨ Fitur Aplikasi
✅ Autentikasi Login dan Logout
✅ Halaman Home & Ringkasan Saldo
✅ Riwayat Transaksi
✅ Pengaturan Akun (Settings)
✅ Bottom Navigation
✅ Responsive UI

Struktur proyek Flutter ini terdiri dari beberapa folder utama yang memisahkan logika aplikasi berdasarkan tanggung jawabnya. Folder bindings digunakan untuk mengatur dependency injection, sementara controllers berisi logika aplikasi seperti auth_controller.dart untuk autentikasi dan transactionController.dart untuk mengelola transaksi. Model data disimpan di models, mencakup entitas seperti transaksi dan user. UI aplikasi dipisahkan dalam folder pages, masing-masing untuk halaman seperti login, homepage, dan tambah transaksi. Folder services menangani layanan eksternal seperti auth_service.dart untuk autentikasi, sedangkan widgets menyimpan komponen UI yang dapat digunakan ulang. File firebase_options.dart adalah konfigurasi Firebase, main.dart sebagai entry point aplikasi, dan routes.dart mengatur navigasi antar halaman. Struktur ini membantu menjaga kode tetap modular, terorganisir, dan mudah dikembangkan.
