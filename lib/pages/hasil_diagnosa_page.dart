// lib/pages/hasil_diagnosa_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../services/dempster_shafer.dart';
import '../services/knowledge_base.dart';
import 'detail_penyakit_page.dart';
import 'diagnosa_page.dart';

class HasilDiagnosaPage extends StatelessWidget {
  final HasilDiagnosa? hasil;
  final List<String> gejalaTerpilih;

  const HasilDiagnosaPage({
    super.key,
    required this.hasil,
    required this.gejalaTerpilih,
  });

  @override
  Widget build(BuildContext context) {
    if (hasil == null) {
      return _buildTidakDitemukan(context);
    }

    final penyakit = hasil!.penyakit;
    final keyakinan = hasil!.nilaiKeyakinan;
    final percent = keyakinan.clamp(0.0, 1.0);

    final namaGejala = gejalaTerpilih.map((kode) {
      try {
        return KnowledgeBase.daftarGejala
            .firstWhere((g) => g.kode == kode)
            .nama;
      } catch (_) {
        return kode;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Hasil Diagnosa',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card utama hasil
            _buildHasilCard(penyakit, percent, keyakinan)
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.9, 0.9)),

            const SizedBox(height: 16),

            // Tingkat keyakinan info
            _buildKeyakinanInfo(percent)
                .animate(delay: 200.ms)
                .fadeIn()
                .slideY(begin: 0.2),

            const SizedBox(height: 16),

            // Gejala yang dipilih
            _buildGejalaCard(namaGejala)
                .animate(delay: 300.ms)
                .fadeIn()
                .slideY(begin: 0.2),

            const SizedBox(height: 16),

            // Info singkat penyakit
            _buildInfoSingkat(penyakit)
                .animate(delay: 400.ms)
                .fadeIn()
                .slideY(begin: 0.2),

            const SizedBox(height: 16),

            // Peringatan dokter
            _buildWarningCard().animate(delay: 500.ms).fadeIn(),

            const SizedBox(height: 20),

            // Tombol aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const DiagnosaPage()),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Diagnosa Ulang',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1565C0),
                      side:
                          const BorderSide(color: Color(0xFF1565C0), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ).animate(delay: 600.ms).fadeIn(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailPenyakitPage(penyakit: penyakit),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    label: Text(
                      'Lihat Detail',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                    ),
                  ).animate(delay: 650.ms).fadeIn(),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHasilCard(penyakit, double percent, double keyakinan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Hasil Diagnosa',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 70,
                lineWidth: 10,
                percent: percent,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(keyakinan * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Keyakinan',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                progressColor: Colors.greenAccent,
                backgroundColor: Colors.white.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1200,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            penyakit.iconEmoji,
            style: const TextStyle(fontSize: 44),
          ),
          const SizedBox(height: 8),
          Text(
            penyakit.nama,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            penyakit.namaLatin,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Colors.white.withOpacity(0.75),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              penyakit.kategori,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyakinanInfo(double percent) {
    String level;
    Color levelColor;
    String desc;

    if (percent >= 0.8) {
      level = 'Tinggi';
      levelColor = const Color(0xFF2E7D32);
      desc = 'Gejala yang dipilih sangat sesuai dengan penyakit ini.';
    } else if (percent >= 0.5) {
      level = 'Sedang';
      levelColor = const Color(0xFFE65100);
      desc = 'Gejala cukup sesuai. Pertimbangkan konsultasi ke dokter.';
    } else {
      level = 'Rendah';
      levelColor = const Color(0xFFB71C1C);
      desc = 'Keyakinan rendah. Sangat disarankan untuk periksa ke dokter.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bar_chart, color: levelColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tingkat Keyakinan: ',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.black87),
                    ),
                    Text(
                      level,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: levelColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                      fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGejalaCard(List<String> namaGejala) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Gejala yang Dipilih (${namaGejala.length})',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          ...namaGejala.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                          fontSize: 12.5, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoSingkat(penyakit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💊', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                'Saran Pengobatan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Text(
            penyakit.pengobatan,
            style: GoogleFonts.poppins(
                fontSize: 12.5, color: Colors.black87, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Text('🏥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hasil diagnosa ini bersifat informatif dan tidak menggantikan pemeriksaan dokter. Segera konsultasikan ke tenaga medis profesional.',
              style: GoogleFonts.poppins(
                  fontSize: 11.5, color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTidakDitemukan(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text('Hasil Diagnosa',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🤔', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text(
                'Diagnosa Tidak Ditemukan',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A237E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Gejala yang dipilih tidak dapat didiagnosa secara akurat. Coba pilih gejala yang lebih spesifik atau konsultasikan langsung ke dokter.',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: Text('Kembali',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
