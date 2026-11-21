// lib/models/gejala_model.dart
class Gejala {
  final String kode;
  final String nama;
  final Map<String, double> massFunctions; // kode penyakit -> nilai belief

  Gejala({
    required this.kode,
    required this.nama,
    required this.massFunctions,
  });
}
