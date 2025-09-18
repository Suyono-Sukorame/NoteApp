# NoteApp - Enhanced iOS/macOS Note Taking Application

Aplikasi catatan yang telah dikembangkan dengan fitur-fitur lengkap untuk iOS dan macOS menggunakan SwiftUI.

## ✨ Fitur Baru dan Peningkatan

### 🎯 Model Data yang Diperkuat
- **Konten Lengkap**: Setiap catatan sekarang memiliki judul dan konten body
- **Timestamps**: Tanggal pembuatan dan modifikasi otomatis
- **Tags System**: Sistem tag untuk kategorisasi lebih fleksibel
- **Favorit**: Markah favorit untuk catatan penting
- **Kategori Diperluas**: 8 kategori dengan ikon dan warna unik
  - Personal (hijau) - ikon: person.fill
  - Work (biru) - ikon: briefcase.fill
  - Study (oranye) - ikon: book.fill
  - Ideas (ungu) - ikon: lightbulb.fill
  - Travel (cyan) - ikon: airplane
  - Health (merah) - ikon: heart.fill
  - Finance (kuning) - ikon: dollarsign.circle.fill
  - Other (abu-abu) - ikon: folder.fill

### 🔍 Pencarian dan Filter Canggih
- **Pencarian Real-time**: Cari dalam judul, konten, dan tags
- **Filter Kategori**: Filter berdasarkan kategori specific
- **Filter Favorit**: Tampilkan hanya catatan favorit
- **Sorting Options**: Urutkan berdasarkan:
  - Tanggal dibuat
  - Tanggal dimodifikasi
  - Judul (A-Z)
  - Kategori

### 📱 Interface Pengguna yang Ditingkatkan
- **Search Bar**: Bar pencarian dengan clear button
- **Filter Panel**: Panel filter dengan statistik
- **Empty State**: Tampilan kosong yang informatif
- **Detail View**: Tampilan detail catatan dengan editing in-place
- **Add Note View**: Form tambah catatan yang komprehensif

### ⚙️ Settings dan Konfigurasi
- **Default Settings**: Atur kategori dan sorting default
- **Display Options**: Opsi tampilan preview
- **Export Functionality**: Export ke Text atau JSON
- **Statistics**: Lihat statistik catatan per kategori
- **Data Management**: Hapus semua catatan dengan konfirmasi

### 🔧 Kompatibilitas Cross-Platform
- **iOS/macOS Support**: Menggunakan conditional compilation
- **Navigation Differences**: Toolbar placement yang sesuai platform
- **Share Functionality**: iOS menggunakan UIActivityViewController, macOS menggunakan pasteboard

## 📂 Struktur File

```
NoteApp/
├── NoteApp/
│   ├── NoteAppApp.swift           # Main app entry point
│   ├── Note.swift                 # Enhanced data model
│   ├── NoteViewModel.swift        # Business logic dengan search/filter
│   ├── ContentView.swift          # Main interface dengan search
│   └── Views/
│       ├── AddNoteView.swift      # Form tambah catatan
│       ├── DetailNoteView.swift   # Detail dan edit catatan
│       └── SettingsView.swift     # Settings dan konfigurasi
└── Assets.xcassets/              # Asset gambar dan warna
```

## 🚀 Cara Menggunakan

### Menambah Catatan Baru
1. Tap tombol "+" di kanan atas
2. Isi judul dan konten catatan
3. Pilih kategori yang sesuai
4. Tambahkan tags (dipisah koma)
5. Tap "Save"

### Mencari dan Filter Catatan
1. Gunakan search bar untuk pencarian real-time
2. Tap "Filters" untuk membuka panel filter
3. Pilih kategori atau aktifkan "Show Favorites Only"
4. Gunakan menu sort untuk mengubah urutan

### Mengedit Catatan
1. Tap catatan yang ingin diedit
2. Di detail view, tap "Edit"
3. Ubah judul, konten, kategori, atau tags
4. Tap "Save" untuk menyimpan

### Mengelola Favorit
- Tap ikon hati di detail view atau list view
- Gunakan filter favorit untuk melihat catatan favorit saja

### Settings dan Export
1. Tap ikon gear di kiri atas
2. Atur preferensi default
3. Lihat statistik penggunaan
4. Export data ke Text atau JSON

## 🛠 Teknologi yang Digunakan

- **SwiftUI**: Modern UI framework
- **Combine**: Reactive programming untuk search
- **UserDefaults**: Persistent storage
- **Foundation**: Core functionality
- **Conditional Compilation**: iOS/macOS compatibility

## 📋 Fitur yang Akan Datang (TODO)

1. **Core Data Integration**: Database yang lebih robust
2. **iCloud Sync**: Sinkronisasi antar device
3. **Rich Text**: Format teks dengan bold, italic, dll
4. **Attachments**: Tambah gambar dan file
5. **Reminder**: Pengingat berbasis waktu
6. **Widget**: Widget untuk quick access
7. **Dark Mode**: Tema gelap yang komprehensif

## 🎨 Design System

### Color Scheme
- Primary: Blue (sistem)
- Categories: Setiap kategori memiliki warna unik
- Text: Mengikuti sistem (light/dark mode)

### Typography
- Title: .title2 bold
- Body: .body regular
- Caption: .caption untuk metadata

### Icons
- SF Symbols untuk konsistensi
- Category-specific icons
- System icons untuk actions

## 📱 Platform Support

- **iOS 15.0+**: Fitur lengkap dengan navigation bar
- **macOS 12.0+**: Toolbar adaptation untuk macOS

## 🔧 Build Requirements

- Xcode 14.0+
- iOS 15.0+ SDK
- macOS 12.0+ SDK
- Swift 5.7+

---

**Developer**: H. Ahmad Ketua (ketua@koperasi-arrahmah.com)  
**Version**: 1.0.0  
**Last Updated**: September 2025