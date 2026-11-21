// lib/pages/admin_daftar_gejala_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gejala_model.dart';
import '../services/knowledge_base.dart';
import '../services/gejala_manager.dart';
import 'admin_tambah_gejala_page.dart';

class AdminDaftarGejalaPage extends StatefulWidget {
  const AdminDaftarGejalaPage({super.key});

  @override
  State<AdminDaftarGejalaPage> createState() => _AdminDaftarGejalaPageState();
}

class _AdminDaftarGejalaPageState extends State<AdminDaftarGejalaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Gejala> get _defaultGejala {
    return KnowledgeBase.daftarGejala.where((g) {
      return _search.isEmpty ||
          g.nama.toLowerCase().contains(_search.toLowerCase()) ||
          g.kode.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  List<Gejala> get _adminGejala {
    return GejalaManager.getGejalaAdmin().where((g) {
      return _search.isEmpty ||
          g.nama.toLowerCase().contains(_search.toLowerCase()) ||
          g.kode.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  void _hapusGejala(String kode, String nama) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🗑️'),
            const SizedBox(width: 8),
            Text('Hapus Gejala',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            children: [
              const TextSpan(text: 'Apakah Anda yakin ingin menghapus gejala '),
              TextSpan(
                text: '"$nama"',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              GejalaManager.hapusGejala(kode);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF388E3C),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: Row(
                    children: [
                      const Text('✅'),
                      const SizedBox(width: 8),
                      Text('Gejala "$nama" berhasil dihapus',
                          style: GoogleFonts.poppins(fontSize: 13)),
                    ],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Hapus',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          'Kelola Data Gejala',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Gejala',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminTambahGejalaPage(),
                ),
              );
              setState(() {});
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
          unselectedLabelStyle: GoogleFonts.poppins(),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storage, size: 16),
                  const SizedBox(width: 6),
                  Text('Default (${KnowledgeBase.daftarGejala.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_box_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text('Tambahan (${GejalaManager.getGejalaAdmin().length})'),
                ],
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: const Color(0xFF1565C0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _search = val),
                decoration: InputDecoration(
                  hintText: 'Cari kode atau nama gejala...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF1565C0)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Gejala Default
                _buildDefaultGejalaTab(),
                // Tab 2: Gejala Admin
                _buildAdminGejalaTab(),
              ],
            ),
          ),
        ],
      ),

      // FAB tambah gejala
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminTambahGejalaPage(),
            ),
          );
          setState(() {});
          _tabController.animateTo(1); // pindah ke tab admin
        },
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Gejala',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildDefaultGejalaTab() {
    final list = _defaultGejala;
    if (list.isEmpty) {
      return _buildEmpty('Gejala tidak ditemukan');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final g = list[i];
        return _GejalaCard(
          gejala: g,
          isAdmin: false,
          index: i,
          onEdit: null,
          onHapus: null,
        )
            .animate(delay: Duration(milliseconds: i * 30))
            .fadeIn()
            .slideX(begin: 0.05);
      },
    );
  }

  Widget _buildAdminGejalaTab() {
    final list = _adminGejala;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📋', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 14),
            Text(
              'Belum ada gejala tambahan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tekan tombol "Tambah Gejala"\nuntuk menambah gejala baru',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminTambahGejalaPage(),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('Tambah Gejala Sekarang',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final g = list[i];
        return _GejalaCard(
          gejala: g,
          isAdmin: true,
          index: i,
          onEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminTambahGejalaPage(gejalaEdit: g),
              ),
            );
            setState(() {});
          },
          onHapus: () => _hapusGejala(g.kode, g.nama),
        )
            .animate(delay: Duration(milliseconds: i * 50))
            .fadeIn()
            .slideX(begin: 0.05);
      },
    );
  }

  Widget _buildEmpty(String msg) {
    return Center(
      child: Text(msg, style: GoogleFonts.poppins(color: Colors.grey.shade500)),
    );
  }
}

class _GejalaCard extends StatelessWidget {
  final Gejala gejala;
  final bool isAdmin;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onHapus;

  const _GejalaCard({
    required this.gejala,
    required this.isAdmin,
    required this.index,
    required this.onEdit,
    required this.onHapus,
  });

  @override
  Widget build(BuildContext context) {
    final penyakitTerkait = gejala.massFunctions.keys.toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isAdmin
            ? Border.all(
                color: const Color(0xFF1565C0).withOpacity(0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kode badge
            Column(
              children: [
                Container(
                  width: 48,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? const Color(0xFF1565C0)
                        : const Color(0xFF1565C0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      gejala.kode,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isAdmin ? Colors.white : const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'BARU',
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(width: 12),

            // Info gejala
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gejala.nama,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (penyakitTerkait.isNotEmpty) ...[
                    Text(
                      'Terkait penyakit:',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: penyakitTerkait.map((kode) {
                        final nilaiDS = gejala.massFunctions[kode] ?? 0.0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$kode (${(nilaiDS * 100).toStringAsFixed(0)}%)',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Tombol edit & hapus (hanya untuk gejala admin)
            if (isAdmin)
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: Color(0xFF1565C0), size: 20),
                    tooltip: 'Edit',
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Color(0xFFD32F2F), size: 20),
                    tooltip: 'Hapus',
                    onPressed: onHapus,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              )
            else
              Icon(Icons.lock_outline, size: 16, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
