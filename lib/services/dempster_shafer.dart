// lib/services/dempster_shafer.dart
import '../models/gejala_model.dart';
import '../models/penyakit_model.dart';
import 'gejala_manager.dart';
import 'penyakit_manager.dart';

class HasilDiagnosa {
  final Penyakit penyakit;
  final double nilaiKeyakinan;
  final List<String> gejalaTerpilih;

  HasilDiagnosa({
    required this.penyakit,
    required this.nilaiKeyakinan,
    required this.gejalaTerpilih,
  });
}

class DempsterShafer {
  static HasilDiagnosa? diagnosa(List<String> kodeGejalaTerpilih) {
    if (kodeGejalaTerpilih.isEmpty) return null;

    // ✅ Baca dari GejalaManager → gabungan default + admin
    final gejalaList = GejalaManager.getAllGejala()
        .where((g) => kodeGejalaTerpilih.contains(g.kode))
        .toList();

    if (gejalaList.isEmpty) return null;

    // Ambil semua kode penyakit yang terlibat
    Set<String> allPenyakitCodes = {};
    for (var g in gejalaList) {
      allPenyakitCodes.addAll(g.massFunctions.keys);
    }

    // Hitung plausibility untuk setiap gejala
    Map<String, double> kombinasi = {};

    // Inisialisasi dengan gejala pertama
    Gejala pertama = gejalaList[0];
    for (var entry in pertama.massFunctions.entries) {
      kombinasi[entry.key] = entry.value;
    }
    double totalBelief = kombinasi.values.fold(0.0, (a, b) => a + b);
    kombinasi['THETA'] = 1.0 - totalBelief;

    // Iterasi kombinasi Dempster-Shafer untuk gejala berikutnya
    for (int i = 1; i < gejalaList.length; i++) {
      Gejala gejala = gejalaList[i];

      Map<String, double> m2 = {};
      for (var entry in gejala.massFunctions.entries) {
        m2[entry.key] = entry.value;
      }
      double totalM2 = m2.values.fold(0.0, (a, b) => a + b);
      m2['THETA'] = 1.0 - totalM2;

      Map<String, double> hasilKombinasi = {};
      double K = 0.0;

      kombinasi.forEach((kode1, val1) {
        m2.forEach((kode2, val2) {
          if (kode1 == 'THETA') {
            if (kode2 != 'THETA') {
              hasilKombinasi[kode2] =
                  (hasilKombinasi[kode2] ?? 0.0) + val1 * val2;
            } else {
              hasilKombinasi['THETA'] =
                  (hasilKombinasi['THETA'] ?? 0.0) + val1 * val2;
            }
          } else if (kode2 == 'THETA') {
            hasilKombinasi[kode1] =
                (hasilKombinasi[kode1] ?? 0.0) + val1 * val2;
          } else if (kode1 == kode2) {
            hasilKombinasi[kode1] =
                (hasilKombinasi[kode1] ?? 0.0) + val1 * val2;
          } else {
            K += val1 * val2;
          }
        });
      });

      if (K < 1.0) {
        double normFactor = 1.0 / (1.0 - K);
        kombinasi = {};
        hasilKombinasi.forEach((kode, val) {
          if (kode != 'THETA') {
            kombinasi[kode] = val * normFactor;
          }
        });
        double totalFinal = kombinasi.values.fold(0.0, (a, b) => a + b);
        kombinasi['THETA'] = (1.0 - totalFinal).clamp(0.0, 1.0);
      } else {
        kombinasi = hasilKombinasi;
      }
    }

    // Ambil nilai terbesar (max)
    String? kodeHasil;
    double nilaiMax = 0.0;
    kombinasi.forEach((kode, val) {
      if (kode != 'THETA' && val > nilaiMax) {
        nilaiMax = val;
        kodeHasil = kode;
      }
    });

    if (kodeHasil == null) return null;

    // ✅ Cari penyakit dari PenyakitManager → gabungan default + admin
    Penyakit? penyakitHasil;
    try {
      penyakitHasil = PenyakitManager.getAllPenyakit()
          .firstWhere((p) => p.kode == kodeHasil);
    } catch (_) {
      return null;
    }

    List<String> namaGejala = gejalaList.map((g) => g.nama).toList();

    return HasilDiagnosa(
      penyakit: penyakitHasil,
      nilaiKeyakinan: nilaiMax,
      gejalaTerpilih: namaGejala,
    );
  }
}
