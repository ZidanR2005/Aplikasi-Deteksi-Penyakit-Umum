// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'daftar_penyakit_page.dart';
import 'diagnosa_page.dart';
import 'about_page.dart';
import 'admin_login_page.dart';
import 'ai_chat_page.dart';
import '../services/penyakit_manager.dart';
import '../services/gejala_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // Header / AppBar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
            actions: [
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined,
                    color: Colors.white),
                tooltip: 'Admin Panel',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminLoginPage()),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF1565C0),
                      Color(0xFF1976D2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Text('🩺',
                                  style: TextStyle(fontSize: 28)),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SISTEM PAKAR',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  'Deteksi Penyakit Umum',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideX(begin: -0.2, end: 0),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '👋  Halo! Selamat datang di aplikasi diagnosa penyakit berbasis AI pakar.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        )
                            .animate(delay: 200.ms)
                            .fadeIn()
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Info card
                _buildInfoCard()
                    .animate(delay: 100.ms)
                    .fadeIn()
                    .slideY(begin: 0.2),
                const SizedBox(height: 24),

                Text(
                  'Menu Utama',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A237E),
                  ),
                ).animate(delay: 200.ms).fadeIn(),
                const SizedBox(height: 14),

                // Grid menu utama
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    _MenuCard(
                      emoji: '🔍',
                      title: 'Diagnosa\nGejala',
                      subtitle: 'Periksa gejala Anda',
                      gradientColors: const [
                        Color(0xFF1565C0),
                        Color(0xFF42A5F5)
                      ],
                      delay: 300,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DiagnosaPage()),
                      ),
                    ),
                    _MenuCard(
                      emoji: '📋',
                      title: 'Daftar\nPenyakit',
                      subtitle: '10 penyakit umum',
                      gradientColors: const [
                        Color(0xFF00695C),
                        Color(0xFF26A69A)
                      ],
                      delay: 400,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DaftarPenyakitPage()),
                      ),
                    ),
                    _MenuCard(
                      emoji: 'ℹ️',
                      title: 'Tentang\nAplikasi',
                      subtitle: 'Info & panduan',
                      gradientColors: const [
                        Color(0xFF6A1B9A),
                        Color(0xFFAB47BC)
                      ],
                      delay: 500,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      ),
                    ),
                    _MenuCard(
                      emoji: '📊',
                      title: 'Metode\nDS',
                      subtitle: 'Dempster-Shafer',
                      gradientColors: const [
                        Color(0xFFBF360C),
                        Color(0xFFEF6C00)
                      ],
                      delay: 600,
                      onTap: () => _showMetodeDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Banner diagnosa cepat
                _buildDiagnosaBanner(context)
                    .animate(delay: 700.ms)
                    .fadeIn()
                    .slideY(begin: 0.2),

                const SizedBox(height: 14),

                // Banner Admin Panel
                _buildAdminBanner(context)
                    .animate(delay: 750.ms)
                    .fadeIn()
                    .slideY(begin: 0.2),

                const SizedBox(height: 14),

                // Banner AI Chat
                _buildAiChatBanner(context)
                    .animate(delay: 780.ms)
                    .fadeIn()
                    .slideY(begin: 0.2),

                const SizedBox(height: 24),

                // Statistik aplikasi
                Text(
                  'Statistik Aplikasi',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A237E),
                  ),
                ).animate(delay: 800.ms).fadeIn(),
                const SizedBox(height: 14),
                _buildStatsRow().animate(delay: 900.ms).fadeIn(),

                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF90CAF9), width: 1),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disclaimer',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1565C0),
                  ),
                ),
                Text(
                  'Aplikasi ini bukan pengganti dokter. Gunakan sebagai referensi awal dan konsultasikan ke tenaga medis.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    color: const Color(0xFF1565C0).withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosaBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DiagnosaPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mulai Diagnosa Sekarang!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih gejala yang Anda rasakan dan dapatkan hasil diagnosa penyakit.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Diagnosa Sekarang →',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Text('🏥', style: TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    // ✅ Dinamis: ikut data terbaru dari manager
    final totalPenyakit = PenyakitManager.getAllPenyakit().length;
    final totalGejala = GejalaManager.getAllGejala().length;
    return Row(
      children: [
        _StatCard(label: 'Penyakit', value: '$totalPenyakit', emoji: '🦠'),
        const SizedBox(width: 10),
        _StatCard(label: 'Gejala', value: '$totalGejala', emoji: '📝'),
        const SizedBox(width: 10),
        _StatCard(label: 'Akurasi', value: '100%', emoji: '✅'),
      ],
    );
  }

  Widget _buildAdminBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminLoginPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1565C0).withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🔐', style: TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Panel',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  Text(
                    'Kelola data gejala dan penyakit',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Masuk →',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiChatBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AiChatPage()),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF7B1FA2),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tanya Asisten AI',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Powered by Gemini • Tanya tentang penyakit & gejala',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Chat →',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7B1FA2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMetodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('📊'),
            const SizedBox(width: 8),
            Text(
              'Metode Dempster-Shafer',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dempster-Shafer adalah teori matematika yang menggabungkan potongan-potongan informasi berbeda dengan bukti untuk menentukan probabilitas suatu peristiwa.',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              const SizedBox(height: 12),
              _FormulaBox(
                  label: 'Plausibility', formula: 'Pl(X) = 1 - Bel(¬X)'),
              const SizedBox(height: 8),
              _FormulaBox(
                  label: 'Kombinasi',
                  formula: 'm1⊕m2(A) = ΣB∩C=A m1(B)·m2(C) / 1-K'),
              const SizedBox(height: 8),
              _FormulaBox(label: 'Conflict', formula: 'K = ΣB∩C=∅ m1(B)·m2(C)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Tutup',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final int delay;
  final VoidCallback onTap;

  const _MenuCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatCard(
      {required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1565C0),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormulaBox extends StatelessWidget {
  final String label;
  final String formula;

  const _FormulaBox({required this.label, required this.formula});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0))),
          Text(formula,
              style: GoogleFonts.sourceCodePro(
                  fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
