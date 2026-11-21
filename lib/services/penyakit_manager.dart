// lib/services/penyakit_manager.dart
// Manager untuk CRUD data penyakit tambahan dari admin (in-memory)
import '../models/penyakit_model.dart';
import 'knowledge_base.dart';

class PenyakitManager {
  // Daftar penyakit tambahan dari admin (runtime)
  static final List<Penyakit> _penyakitAdmin = [];

  // Ambil semua penyakit (default + admin)
  static List<Penyakit> getAllPenyakit() {
    return [...KnowledgeBase.daftarPenyakit, ..._penyakitAdmin];
  }

  // Ambil hanya penyakit dari admin
  static List<Penyakit> getPenyakitAdmin() => List.unmodifiable(_penyakitAdmin);

  // Tambah penyakit baru
  static void tambahPenyakit(Penyakit penyakit) {
    _penyakitAdmin.add(penyakit);
  }

  // Edit penyakit (berdasarkan kode)
  static void editPenyakit(String kode, Penyakit penyakitBaru) {
    final idx = _penyakitAdmin.indexWhere((p) => p.kode == kode);
    if (idx != -1) {
      _penyakitAdmin[idx] = penyakitBaru;
    }
  }

  // Hapus penyakit admin
  static void hapusPenyakit(String kode) {
    _penyakitAdmin.removeWhere((p) => p.kode == kode);
  }

  // Cek apakah kode sudah ada
  static bool kodeExists(String kode) {
    return getAllPenyakit().any((p) => p.kode == kode);
  }

  // Generate kode otomatis berikutnya
  static String generateKode() {
    final allKodes = getAllPenyakit().map((p) => p.kode).toList();
    int max = 10;
    for (final k in allKodes) {
      final num = int.tryParse(k.replaceAll(RegExp(r'[^0-9]'), ''));
      if (num != null && num > max) max = num;
    }
    final next = max + 1;
    return 'P${next.toString().padLeft(3, '0')}';
  }

  // Daftar emoji pilihan
  static const List<String> daftarEmoji = [
    '🦠',
    '🤒',
    '🤕',
    '🩺',
    '💊',
    '🏥',
    '🩻',
    '🩹',
    '❤️',
    '🫀',
    '🫁',
    '🧠',
    '👁️',
    '👂',
    '🦷',
    '🦴',
    '💉',
    '🔬',
    '🧬',
    '⚕️',
    '🌡️',
    '😷',
    '🤧',
    '🤢',
  ];

  // Daftar kategori pilihan
  static const List<String> daftarKategori = [
    'Infeksi Bakteri',
    'Infeksi Virus',
    'Saraf & Keseimbangan',
    'Saraf & Kepala',
    'Darah & Nutrisi',
    'Urologi',
    'Pernapasan',
    'Pencernaan',
    'Mata',
    'THT',
    'Kulit & Alergi',
    'Jantung & Pembuluh Darah',
    'Tulang & Sendi',
    'Endokrin & Metabolisme',
    'Lainnya',
  ];
}
