// lib/pages/daftar_penyakit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/penyakit_manager.dart';
import '../models/penyakit_model.dart';
import 'detail_penyakit_page.dart';

class DaftarPenyakitPage extends StatefulWidget {
  const DaftarPenyakitPage({super.key});

  @override
  State<DaftarPenyakitPage> createState() => _DaftarPenyakitPageState();
}

class _DaftarPenyakitPageState extends State<DaftarPenyakitPage> {
  String _searchQuery = '';
  String _selectedKategori = 'Semua';

  List<String> get _kategoris {
    final set = {'Semua'};
    for (var p in PenyakitManager.getAllPenyakit()) {
      set.add(p.kategori);
    }
    return set.toList();
  }

  List<Penyakit> get _filteredPenyakit {
    return PenyakitManager.getAllPenyakit().where((p) {
      final matchSearch = _searchQuery.isEmpty ||
          p.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.namaLatin.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchKategori =
          _selectedKategori == 'Semua' || p.kategori == _selectedKategori;
      return matchSearch && matchKategori;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Daftar Penyakit',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Cari penyakit...',
                      hintStyle: GoogleFonts.poppins(fontSize: 13),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF1565C0)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Kategori filter chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _kategoris.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) {
                      final k = _kategoris[i];
                      final selected = _selectedKategori == k;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedKategori = k),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            k,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? const Color(0xFF1565C0)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Info count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${_filteredPenyakit.length} penyakit ditemukan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // List penyakit
          Expanded(
            child: _filteredPenyakit.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 10),
                        Text('Tidak ada penyakit ditemukan',
                            style: GoogleFonts.poppins(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPenyakit.length,
                    itemBuilder: (ctx, i) {
                      final penyakit = _filteredPenyakit[i];
                      return _PenyakitCard(penyakit: penyakit, index: i)
                          .animate(delay: Duration(milliseconds: i * 80))
                          .fadeIn()
                          .slideX(begin: 0.1, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PenyakitCard extends StatelessWidget {
  final Penyakit penyakit;
  final int index;

  const _PenyakitCard({required this.penyakit, required this.index});

  Color get _cardColor {
    final colors = [
      const Color(0xFF1565C0),
      const Color(0xFF00695C),
      const Color(0xFF6A1B9A),
      const Color(0xFFBF360C),
      const Color(0xFF1B5E20),
      const Color(0xFF4A148C),
      const Color(0xFF006064),
      const Color(0xFF880E4F),
      const Color(0xFF33691E),
      const Color(0xFF01579B),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPenyakitPage(penyakit: penyakit),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            // Kode & emoji
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(penyakit.iconEmoji,
                      style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    penyakit.kode,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      penyakit.nama,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    Text(
                      penyakit.namaLatin,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        penyakit.kategori,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _cardColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
