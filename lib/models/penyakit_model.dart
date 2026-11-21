// lib/models/penyakit_model.dart
class Penyakit {
  final String kode;
  final String nama;
  final String namaLatin;
  final String deskripsi;
  final String gejalaUtama;
  final String pengobatan;
  final String pencegahan;
  final String iconEmoji;
  final String kategori;

  Penyakit({
    required this.kode,
    required this.nama,
    required this.namaLatin,
    required this.deskripsi,
    required this.gejalaUtama,
    required this.pengobatan,
    required this.pencegahan,
    required this.iconEmoji,
    required this.kategori,
  });
}
