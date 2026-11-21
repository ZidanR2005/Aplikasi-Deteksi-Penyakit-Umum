// lib/pages/about_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Tentang Aplikasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🩺', style: TextStyle(fontSize: 44)),
                    ),
                  ).animate().scale().fadeIn(),
                  const SizedBox(height: 16),
                  Text(
                    'Sistem Pakar',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ).animate(delay: 100.ms).fadeIn(),
                  Text(
                    'Deteksi Penyakit Umum',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ).animate(delay: 150.ms).fadeIn(),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Versi 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Deskripsi aplikasi
                  _buildSection(
                    icon: '📱',
                    title: 'Tentang Aplikasi',
                    content:
                        'Aplikasi Sistem Pakar Deteksi Penyakit Umum adalah aplikasi berbasis mobile yang dirancang untuk membantu masyarakat umum dalam mendeteksi kemungkinan penyakit berdasarkan gejala-gejala yang dialami.\n\nAplikasi ini dibangun menggunakan framework Flutter dengan metode kecerdasan buatan Dempster-Shafer untuk melakukan kalkulasi probabilitas diagnosis.',
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  // Metode
                  _buildSection(
                    icon: '📊',
                    title: 'Metode Dempster-Shafer',
                    content:
                        'Dempster-Shafer adalah teori matematika yang menggabungkan berbagai potongan informasi dengan bukti untuk menentukan probabilitas suatu peristiwa. Metode ini didasarkan pada fungsi kepercayaan (Belief) dan plausibility.\n\nMetode ini dipilih karena kemampuannya menangani ketidakpastian dalam diagnosis medis dengan mengkombinasikan berbagai gejala secara matematis.',
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  // Data
                  _buildInfoGrid().animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 12),

                  // Penyakit yang didukung
                  _buildPenyakitSupported()
                      .animate(delay: 400.ms)
                      .fadeIn()
                      .slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  // Developer
                  _buildDevSection()
                      .animate(delay: 500.ms)
                      .fadeIn()
                      .slideY(begin: 0.2),

                  const SizedBox(height: 12),

                  // Disclaimer
                  _buildDisclaimer().animate(delay: 600.ms).fadeIn(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
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
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.poppins(
                fontSize: 13, color: Colors.black87, height: 1.7),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        _InfoGridItem(label: 'Penyakit', value: '10', emoji: '🦠'),
        const SizedBox(width: 10),
        _InfoGridItem(label: 'Gejala', value: '51', emoji: '📝'),
        const SizedBox(width: 10),
        _InfoGridItem(label: 'Akurasi', value: '100%', emoji: '✅'),
        const SizedBox(width: 10),
        _InfoGridItem(label: 'Skenario', value: '25', emoji: '🔬'),
      ],
    );
  }

  Widget _buildPenyakitSupported() {
    final list = [
      ('P001', 'Vertigo'),
      ('P002', 'Nyeri Kepala'),
      ('P003', 'Anemia'),
      ('P004', 'ISK'),
      ('P005', 'Pneumonia'),
      ('P006', 'Tipes'),
      ('P007', 'Dispepsia'),
      ('P008', 'Konjungtivitis'),
      ('P009', 'Amandel'),
      ('P010', 'Biduran'),
    ];

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
              const Text('🏥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Penyakit yang Didukung',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          ...list.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.$1,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.$2,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDevSection() {
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
              const Text('👩‍💻', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Tim Pengembang',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          _DevItem(name: 'Zidan Permata Ramadan (Just ZidanR)', role: 'Ketua'),
          _DevItem(name: 'Muhammad (Mahmud)', role: 'Anggota'),
          _DevItem(name: 'Muhammad Akhabbani (Babeh)', role: 'Anggota'),
          _DevItem(name: 'Fadillah Hermawan (Fadill)', role: 'Anggota'),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),
          Text(
            '🏛️  Universitas Bina Sarana Informatika ',
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic),
          ),
          Text(
            '📅  November 2026',
            style:
                GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
          ),
          Text(
            '📰  JATI - Jurnal Mahasiswa Teknik Informatika',
            style:
                GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Perhatian / Disclaimer',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Aplikasi ini hanya bersifat informatif sebagai referensi awal dan TIDAK menggantikan diagnosis atau pemeriksaan dari dokter atau tenaga medis profesional. Selalu konsultasikan kondisi kesehatan Anda kepada dokter yang berkompeten untuk mendapatkan penanganan yang tepat.',
            style: GoogleFonts.poppins(
                fontSize: 12.5, color: Colors.orange.shade900, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _InfoGridItem extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _InfoGridItem(
      {required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1565C0),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DevItem extends StatelessWidget {
  final String name;
  final String role;

  const _DevItem({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Center(child: Text('👤', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                role,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
