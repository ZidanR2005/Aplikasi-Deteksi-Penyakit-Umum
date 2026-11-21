import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/penyakit_model.dart';
import '../services/knowledge_base.dart';

class DetailPenyakitPage extends StatelessWidget {
  final Penyakit penyakit;

  const DetailPenyakitPage({
    super.key,
    required this.penyakit,
  });

  Color get _primaryColor {
    switch (penyakit.kode) {
      case 'P001':
        return const Color(0xFF1565C0);
      case 'P002':
        return const Color(0xFF880E4F);
      case 'P003':
        return const Color(0xFFC62828);
      case 'P004':
        return const Color(0xFF6A1B9A);
      case 'P005':
        return const Color(0xFF1B5E20);
      case 'P006':
        return const Color(0xFFBF360C);
      case 'P007':
        return const Color(0xFF006064);
      case 'P008':
        return const Color(0xFF00695C);
      case 'P009':
        return const Color(0xFF4A148C);
      case 'P010':
        return const Color(0xFF01579B);
      default:
        return const Color(0xFF1565C0);
    }
  }

  List<String> get _gejalaPenyakit {
    return KnowledgeBase.daftarGejala
        .where((g) => g.massFunctions.containsKey(penyakit.kode))
        .map((g) => g.nama)
        .toList();
  }

  TextStyle get _headingStyle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF263449),
      );

  @override
  Widget build(BuildContext context) {
    final color = _primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // HEADER
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            backgroundColor: color,
            foregroundColor: Colors.white,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 60,
                bottom: 16,
                right: 16,
              ),
              title: Text(
                penyakit.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(0.85),
                      color.withOpacity(0.65),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -35,
                      top: -45,
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -55,
                      bottom: -85,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25),
                            Container(
                              width: 95,
                              height: 95,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  penyakit.iconEmoji,
                                  style: const TextStyle(fontSize: 53),
                                ),
                              ),
                            )
                                .animate()
                                .scale(
                                  duration: 500.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .fadeIn(),
                            const SizedBox(height: 14),
                            Text(
                              'INFORMASI PENYAKIT',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                penyakit.kode,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CONTENT
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // KATEGORI
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: color.withOpacity(0.18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.category_rounded,
                            color: color,
                            size: 15,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            penyakit.kategori,
                            style: GoogleFonts.poppins(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideX(begin: -0.1),

                const SizedBox(height: 16),

                // NAMA ILMIAH
                _buildSection(
                  icon: Icons.biotech_rounded,
                  title: 'Nama Ilmiah',
                  content: penyakit.namaLatin,
                  isItalic: true,
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.12),

                const SizedBox(height: 14),

                // DESKRIPSI
                _buildSection(
                  icon: Icons.menu_book_rounded,
                  title: 'Deskripsi Penyakit',
                  content: penyakit.deskripsi,
                ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.12),

                const SizedBox(height: 14),

                // GEJALA
                _buildGejalaSection()
                    .animate(delay: 200.ms)
                    .fadeIn()
                    .slideY(begin: 0.12),

                const SizedBox(height: 14),

                // PENGOBATAN
                _buildSection(
                  icon: Icons.medication_rounded,
                  title: 'Pengobatan',
                  content: penyakit.pengobatan,
                ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.12),

                const SizedBox(height: 14),

                // PENCEGAHAN
                _buildSection(
                  icon: Icons.health_and_safety_rounded,
                  title: 'Pencegahan',
                  content: penyakit.pencegahan,
                ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.12),

                const SizedBox(height: 18),

                // PERINGATAN
                _buildWarning()
                    .animate(delay: 350.ms)
                    .fadeIn()
                    .slideY(begin: 0.12),

                const SizedBox(height: 15),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // CARD INFORMASI
  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    bool isItalic = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEDF0F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: _headingStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: const Color(0xFFF0F1F5),
          ),
          const SizedBox(height: 13),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: const Color(0xFF566174),
              height: 1.8,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  // CARD GEJALA
  Widget _buildGejalaSection() {
    final gejala = _gejalaPenyakit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEDF0F5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.healing_rounded,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Gejala-Gejala',
                  style: _headingStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${gejala.length} Gejala',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 1,
            color: const Color(0xFFF0F1F5),
          ),
          const SizedBox(height: 15),
          if (gejala.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Belum ada data gejala.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: gejala.map((g) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _primaryColor.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: _primaryColor,
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          g,
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            color: const Color(0xFF43516A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // PERINGATAN MEDIS
  Widget _buildWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFDDA5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8BD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFE58B13),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perhatian Medis',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFAD690A),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Informasi ini hanya sebagai referensi. '
                  'Segera konsultasikan ke dokter untuk diagnosis '
                  'dan pengobatan yang tepat.',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF8C6A37),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
