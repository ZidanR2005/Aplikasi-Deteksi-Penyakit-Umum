// lib/services/gejala_manager.dart
// Manager untuk menyimpan gejala tambahan dari admin (in-memory)
import '../models/gejala_model.dart';
import 'knowledge_base.dart';

class GejalaManager {
  // Daftar gejala tambahan dari admin (runtime)
  static final List<Gejala> _gejalaAdmin = [];

  // Ambil semua gejala (default + admin)
  static List<Gejala> getAllGejala() {
    return [...KnowledgeBase.daftarGejala, ..._gejalaAdmin];
  }

  // Ambil hanya gejala dari admin
  static List<Gejala> getGejalaAdmin() => List.unmodifiable(_gejalaAdmin);

  // Tambah gejala baru
  static void tambahGejala(Gejala gejala) {
    _gejalaAdmin.add(gejala);
  }

  // Edit gejala (berdasarkan kode)
  static void editGejala(String kode, Gejala gejalaBar) {
    final idx = _gejalaAdmin.indexWhere((g) => g.kode == kode);
    if (idx != -1) {
      _gejalaAdmin[idx] = gejalaBar;
    }
  }

  // Hapus gejala admin
  static void hapusGejala(String kode) {
    _gejalaAdmin.removeWhere((g) => g.kode == kode);
  }

  // Cek apakah kode sudah ada
  static bool kodeExists(String kode) {
    return getAllGejala().any((g) => g.kode == kode);
  }

  // Generate kode otomatis berikutnya
  static String generateKode() {
    final allKodes = getAllGejala().map((g) => g.kode).toList();
    int max = 51;
    for (final k in allKodes) {
      final num = int.tryParse(k.replaceAll('G', ''));
      if (num != null && num > max) max = num;
    }
    return 'G${max + 1}';
  }
}
