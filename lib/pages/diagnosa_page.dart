// lib/pages/diagnosa_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/gejala_manager.dart';
import '../services/dempster_shafer.dart';
import '../models/gejala_model.dart';
import 'hasil_diagnosa_page.dart';

class DiagnosaPage extends StatefulWidget {
  const DiagnosaPage({super.key});

  @override
  State<DiagnosaPage> createState() => _DiagnosaPageState();
}

class _DiagnosaPageState extends State<DiagnosaPage> {
  final Set<String> _selectedGejala = {};
  String _searchGejala = '';

  List<Gejala> get _filteredGejala {
    // ✅ Pakai GejalaManager.getAllGejala() → gabungan default + admin
    return GejalaManager.getAllGejala().where((g) {
      return _searchGejala.isEmpty ||
          g.nama.toLowerCase().contains(_searchGejala.toLowerCase()) ||
          g.kode.toLowerCase().contains(_searchGejala.toLowerCase());
    }).toList();
  }

  void _diagnosa() {
    if (_selectedGejala.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD32F2F),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Text('⚠️'),
              const SizedBox(width: 8),
              Text(
                'Pilih minimal 1 gejala terlebih dahulu!',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final hasil = DempsterShafer.diagnosa(_selectedGejala.toList());

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => HasilDiagnosaPage(
          hasil: hasil,
          gejalaTerpilih: _selectedGejala.toList(),
        ),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _resetGejala() {
    setState(() => _selectedGejala.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Diagnosa Gejala',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_selectedGejala.isNotEmpty)
            TextButton.icon(
              onPressed: _resetGejala,
              icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
              label: Text(
                'Reset',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header info
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Counter gejala terpilih
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedGejala.isEmpty
                        ? Colors.white.withOpacity(0.15)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedGejala.isEmpty ? '📋' : '✅',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedGejala.isEmpty
                              ? 'Belum ada gejala dipilih. Pilih minimal 1 gejala.'
                              : '${_selectedGejala.length} gejala dipilih. Siap untuk diagnosa!',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedGejala.isEmpty
                                ? Colors.white
                                : const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Search
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: (val) => setState(() => _searchGejala = val),
                    decoration: InputDecoration(
                      hintText: 'Cari gejala...',
                      hintStyle: GoogleFonts.poppins(fontSize: 13),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF1565C0)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Panduan
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 14, color: Color(0xFF1565C0)),
                const SizedBox(width: 6),
                Text(
                  'Centang semua gejala yang Anda rasakan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),

          // List gejala
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              itemCount: _filteredGejala.length,
              itemBuilder: (ctx, i) {
                final gejala = _filteredGejala[i];
                final selected = _selectedGejala.contains(gejala.kode);
                return _GejalaItem(
                  gejala: gejala,
                  selected: selected,
                  index: i,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedGejala.add(gejala.kode);
                      } else {
                        _selectedGejala.remove(gejala.kode);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Tombol Diagnosa floating
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _selectedGejala.isNotEmpty ? 1.0 : 0.8,
        child: FloatingActionButton.extended(
          onPressed: _diagnosa,
          backgroundColor:
              _selectedGejala.isEmpty ? Colors.grey : const Color(0xFF1565C0),
          icon: const Icon(Icons.search, color: Colors.white),
          label: Text(
            _selectedGejala.isEmpty
                ? 'Pilih Gejala Dulu'
                : 'Diagnosa (${_selectedGejala.length} gejala)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 8,
        ),
      ),
    );
  }
}

class _GejalaItem extends StatelessWidget {
  final Gejala gejala;
  final bool selected;
  final int index;
  final ValueChanged<bool?> onChanged;

  const _GejalaItem({
    required this.gejala,
    required this.selected,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF1565C0) : Colors.grey.shade200,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            // Nomor / kode
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    selected ? const Color(0xFF1565C0) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  gejala.kode,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nama gejala
            Expanded(
              child: Text(
                gejala.nama,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? const Color(0xFF1A237E) : Colors.black87,
                ),
              ),
            ),

            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF1565C0) : Colors.transparent,
                border: Border.all(
                  color:
                      selected ? const Color(0xFF1565C0) : Colors.grey.shade400,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 20)).fadeIn();
  }
}
