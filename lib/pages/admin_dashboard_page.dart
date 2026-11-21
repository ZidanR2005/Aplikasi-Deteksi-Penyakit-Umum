// lib/pages/admin_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/knowledge_base.dart';
import '../services/gejala_manager.dart';
import '../services/penyakit_manager.dart';
import 'admin_daftar_gejala_page.dart';
import 'admin_daftar_penyakit_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🚪'),
            const SizedBox(width: 8),
            Text('Konfirmasi Logout',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
        content: Text('Apakah Anda yakin ingin keluar dari Admin Panel?',
            style: GoogleFonts.poppins(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Logout',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jumlahGejalaAdmin = GejalaManager.getGejalaAdmin().length;
    final totalGejala = GejalaManager.getAllGejala().length;
    final jumlahPenyakitAdmin = PenyakitManager.getPenyakitAdmin().length;
    final totalPenyakit = PenyakitManager.getAllPenyakit().length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                            const Text('👨‍💼', style: TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang, Admin!',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Kelola data sistem pakar di sini',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 16),
                  // Statistik row
                  Row(
                    children: [
                      _StatBadge(
                          label: 'Total Penyakit', value: '$totalPenyakit'),
                      const SizedBox(width: 10),
                      _StatBadge(label: 'Total Gejala', value: '$totalGejala'),
                      const SizedBox(width: 10),
                      _StatBadge(
                          label: 'Tambahan',
                          value: '${jumlahPenyakitAdmin + jumlahGejalaAdmin}'),
                    ],
                  ).animate(delay: 100.ms).fadeIn(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Pengelolaan',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ).animate(delay: 100.ms).fadeIn(),
                  const SizedBox(height: 14),

                  // Menu Kelola Gejala
                  _AdminMenuCard(
                    emoji: '📝',
                    title: 'Kelola Data Gejala',
                    subtitle:
                        'Lihat, tambah, edit, dan hapus data gejala penyakit',
                    badge: '$totalGejala Gejala',
                    badgeColor: const Color(0xFF1565C0),
                    gradientColors: const [
                      Color(0xFF1565C0),
                      Color(0xFF42A5F5)
                    ],
                    delay: 200,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminDaftarGejalaPage(),
                        ),
                      );
                      setState(() {}); // refresh counter
                    },
                  ),

                  const SizedBox(height: 12),

                  // Menu Kelola Penyakit
                  _AdminMenuCard(
                    emoji: '🦠',
                    title: 'Kelola Data Penyakit',
                    subtitle: 'Tambah, edit, dan hapus data penyakit',
                    badge: '$totalPenyakit Penyakit',
                    badgeColor: const Color(0xFF00695C),
                    gradientColors: const [
                      Color(0xFF00695C),
                      Color(0xFF26A69A)
                    ],
                    delay: 300,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminDaftarPenyakitPage(),
                        ),
                      );
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 20),

                  // Info box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFFFB300).withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'Panduan Admin',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _GuideItem(
                            no: '1',
                            text:
                                'Buka "Kelola Data Gejala" untuk tambah/edit/hapus gejala'),
                        _GuideItem(
                            no: '2',
                            text:
                                'Buka "Kelola Data Penyakit" untuk tambah/edit/hapus penyakit'),
                        _GuideItem(
                            no: '3',
                            text: 'Tekan tombol ➕ untuk menambah data baru'),
                        _GuideItem(
                            no: '4',
                            text:
                                'Tekan ✏️ untuk edit, 🗑️ untuk hapus data tambahan'),
                        _GuideItem(
                            no: '5',
                            text:
                                'Data default sistem tidak dapat dihapus (terkunci 🔒)'),
                      ],
                    ),
                  ).animate(delay: 400.ms).fadeIn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final List<Color> gradientColors;
  final int delay;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideX(begin: 0.1);
  }
}

class _GuideItem extends StatelessWidget {
  final String no;
  final String text;
  const _GuideItem({required this.no, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                no,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.amber.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
