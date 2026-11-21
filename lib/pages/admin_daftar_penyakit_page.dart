// lib/pages/admin_daftar_penyakit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/penyakit_model.dart';
import '../services/knowledge_base.dart';
import '../services/penyakit_manager.dart';
import 'detail_penyakit_page.dart';
import 'admin_tambah_penyakit_page.dart';

class AdminDaftarPenyakitPage extends StatefulWidget {
  const AdminDaftarPenyakitPage({super.key});

  @override
  State<AdminDaftarPenyakitPage> createState() =>
      _AdminDaftarPenyakitPageState();
}

class _AdminDaftarPenyakitPageState extends State<AdminDaftarPenyakitPage>
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

  List<Penyakit> get _defaultPenyakit {
    return KnowledgeBase.daftarPenyakit.where((p) {
      return _search.isEmpty ||
          p.nama.toLowerCase().contains(_search.toLowerCase()) ||
          p.kode.toLowerCase().contains(_search.toLowerCase()) ||
          p.kategori.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  List<Penyakit> get _adminPenyakit {
    return PenyakitManager.getPenyakitAdmin().where((p) {
      return _search.isEmpty ||
          p.nama.toLowerCase().contains(_search.toLowerCase()) ||
          p.kode.toLowerCase().contains(_search.toLowerCase()) ||
          p.kategori.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  void _hapusPenyakit(String kode, String nama) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Text('🗑️'),
            const SizedBox(width: 8),
            Text('Hapus Penyakit',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            children: [
              const TextSpan(
                  text: 'Apakah Anda yakin ingin menghapus penyakit '),
              TextSpan(
                text: '"$nama"',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const TextSpan(
                  text: '? Data yang terhapus tidak dapat dikembalikan.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              PenyakitManager.hapusPenyakit(kode);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF388E3C),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  content: Text('✅  Penyakit "$nama" berhasil dihapus',
                      style: GoogleFonts.poppins(fontSize: 13)),
                ),
              );
            },
            icon: const Icon(Icons.delete, color: Colors.white, size: 18),
            label: Text('Hapus',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
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
          'Kelola Data Penyakit',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Penyakit',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminTambahPenyakitPage(),
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
                  Text('Default (${KnowledgeBase.daftarPenyakit.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_box_outlined, size: 16),
                  const SizedBox(width: 6),
                  Text(
                      'Tambahan (${PenyakitManager.getPenyakitAdmin().length})'),
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
                  hintText: 'Cari kode, nama, atau kategori...',
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
                _buildDefaultTab(),
                _buildAdminTab(),
              ],
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminTambahPenyakitPage(),
            ),
          );
          setState(() {});
          _tabController.animateTo(1);
        },
        backgroundColor: const Color(0xFF1565C0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Tambah Penyakit',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildDefaultTab() {
    final list = _defaultPenyakit;
    if (list.isEmpty) {
      return _buildEmpty('Penyakit tidak ditemukan');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        final p = list[i];
        return _PenyakitCRUDCard(
          penyakit: p,
          isAdmin: false,
          index: i,
          onLihat: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPenyakitPage(penyakit: p)),
          ),
          onEdit: null,
          onHapus: null,
        )
            .animate(delay: Duration(milliseconds: i * 40))
            .fadeIn()
            .slideX(begin: 0.05);
      },
    );
  }

  Widget _buildAdminTab() {
    final list = _adminPenyakit;
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏥', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 14),
            Text(
              'Belum ada penyakit tambahan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tekan "Tambah Penyakit" untuk\nmenambahkan data penyakit baru',
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
                    builder: (_) => const AdminTambahPenyakitPage(),
                  ),
                );
                setState(() {});
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Tambah Penyakit Sekarang',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700),
              ),
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
        final p = list[i];
        return _PenyakitCRUDCard(
          penyakit: p,
          isAdmin: true,
          index: i,
          onLihat: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPenyakitPage(penyakit: p)),
          ),
          onEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminTambahPenyakitPage(penyakitEdit: p),
              ),
            );
            setState(() {});
          },
          onHapus: () => _hapusPenyakit(p.kode, p.nama),
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

// ── Card penyakit dengan aksi CRUD ──
class _PenyakitCRUDCard extends StatelessWidget {
  final Penyakit penyakit;
  final bool isAdmin;
  final int index;
  final VoidCallback onLihat;
  final VoidCallback? onEdit;
  final VoidCallback? onHapus;

  const _PenyakitCRUDCard({
    required this.penyakit,
    required this.isAdmin,
    required this.index,
    required this.onLihat,
    required this.onEdit,
    required this.onHapus,
  });

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
    if (isAdmin) return const Color(0xFF37474F);
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
      child: Column(
        children: [
          // Info row
          Row(
            children: [
              // Ikon & kode
              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(penyakit.iconEmoji,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 4),
                    Text(
                      penyakit.kode,
                      style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BARU',
                          style: GoogleFonts.poppins(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        penyakit.nama,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        penyakit.namaLatin,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          penyakit.kategori,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Aksi (kunci untuk default, edit/hapus untuk admin)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: isAdmin
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined,
                                color: Color(0xFF1565C0), size: 20),
                            tooltip: 'Lihat Detail',
                            onPressed: onLihat,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(height: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Color(0xFF388E3C), size: 20),
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
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined,
                                color: Color(0xFF1565C0), size: 20),
                            tooltip: 'Lihat Detail',
                            onPressed: onLihat,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(height: 4),
                          const Icon(Icons.lock_outline,
                              size: 14, color: Color(0xFFBDBDBD)),
                        ],
                      ),
              ),
            ],
          ),

          // Gejala utama preview (hanya admin)
          if (isAdmin && penyakit.gejalaUtama.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Row(
                children: [
                  const SizedBox(width: 72 + 12), // sama lebar seperti kiri
                  Expanded(
                    child: Text(
                      '📌 ${penyakit.gejalaUtama}',
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
