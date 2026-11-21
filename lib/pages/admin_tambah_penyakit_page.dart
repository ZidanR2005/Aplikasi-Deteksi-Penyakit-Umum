// lib/pages/admin_tambah_penyakit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/penyakit_model.dart';
import '../services/penyakit_manager.dart';

class AdminTambahPenyakitPage extends StatefulWidget {
  final Penyakit? penyakitEdit; // null = tambah, isi = edit

  const AdminTambahPenyakitPage({super.key, this.penyakitEdit});

  @override
  State<AdminTambahPenyakitPage> createState() =>
      _AdminTambahPenyakitPageState();
}

class _AdminTambahPenyakitPageState extends State<AdminTambahPenyakitPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kodeCtrl;
  late TextEditingController _namaCtrl;
  late TextEditingController _namaLatinCtrl;
  late TextEditingController _deskripsiCtrl;
  late TextEditingController _gejalaUtamaCtrl;
  late TextEditingController _pengobatanCtrl;
  late TextEditingController _pencegahanCtrl;

  String _selectedEmoji = '🦠';
  String _selectedKategori = 'Lainnya';

  bool get _isEditMode => widget.penyakitEdit != null;

  @override
  void initState() {
    super.initState();
    final p = widget.penyakitEdit;
    _kodeCtrl =
        TextEditingController(text: p?.kode ?? PenyakitManager.generateKode());
    _namaCtrl = TextEditingController(text: p?.nama ?? '');
    _namaLatinCtrl = TextEditingController(text: p?.namaLatin ?? '');
    _deskripsiCtrl = TextEditingController(text: p?.deskripsi ?? '');
    _gejalaUtamaCtrl = TextEditingController(text: p?.gejalaUtama ?? '');
    _pengobatanCtrl = TextEditingController(text: p?.pengobatan ?? '');
    _pencegahanCtrl = TextEditingController(text: p?.pencegahan ?? '');
    _selectedEmoji = p?.iconEmoji ?? '🦠';
    _selectedKategori = p?.kategori ?? 'Lainnya';
  }

  @override
  void dispose() {
    _kodeCtrl.dispose();
    _namaCtrl.dispose();
    _namaLatinCtrl.dispose();
    _deskripsiCtrl.dispose();
    _gejalaUtamaCtrl.dispose();
    _pengobatanCtrl.dispose();
    _pencegahanCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final kode = _kodeCtrl.text.trim().toUpperCase();

    // Cek duplikasi kode (hanya saat tambah baru)
    if (!_isEditMode && PenyakitManager.kodeExists(kode)) {
      _showSnackbar('❌ Kode "$kode" sudah digunakan!', isError: true);
      return;
    }

    final penyakitBaru = Penyakit(
      kode: kode,
      nama: _namaCtrl.text.trim(),
      namaLatin: _namaLatinCtrl.text.trim(),
      deskripsi: _deskripsiCtrl.text.trim(),
      gejalaUtama: _gejalaUtamaCtrl.text.trim(),
      pengobatan: _pengobatanCtrl.text.trim(),
      pencegahan: _pencegahanCtrl.text.trim(),
      iconEmoji: _selectedEmoji,
      kategori: _selectedKategori,
    );

    if (_isEditMode) {
      PenyakitManager.editPenyakit(widget.penyakitEdit!.kode, penyakitBaru);
      _showSnackbar('✅ Penyakit berhasil diperbarui!');
    } else {
      PenyakitManager.tambahPenyakit(penyakitBaru);
      _showSnackbar('✅ Penyakit "${penyakitBaru.nama}" berhasil ditambahkan!');
    }

    Navigator.pop(context);
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
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
          _isEditMode ? 'Edit Penyakit' : 'Tambah Penyakit Baru',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header info
              _buildInfoBanner().animate().fadeIn(),

              const SizedBox(height: 20),

              // ── SECTION 1: Identitas Penyakit ──
              _SectionHeader(title: '1. Identitas Penyakit', emoji: '🏷️'),
              const SizedBox(height: 12),
              _buildIdentitasCard()
                  .animate(delay: 100.ms)
                  .fadeIn()
                  .slideY(begin: 0.1),

              const SizedBox(height: 20),

              // ── SECTION 2: Pilih Ikon & Kategori ──
              _SectionHeader(title: '2. Ikon & Kategori', emoji: '🎨'),
              const SizedBox(height: 12),
              _buildIkonKategoriCard()
                  .animate(delay: 150.ms)
                  .fadeIn()
                  .slideY(begin: 0.1),

              const SizedBox(height: 20),

              // ── SECTION 3: Deskripsi & Gejala ──
              _SectionHeader(title: '3. Deskripsi & Gejala Utama', emoji: '📖'),
              const SizedBox(height: 12),
              _buildDeskripsiCard()
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.1),

              const SizedBox(height: 20),

              // ── SECTION 4: Pengobatan & Pencegahan ──
              _SectionHeader(title: '4. Pengobatan & Pencegahan', emoji: '💊'),
              const SizedBox(height: 12),
              _buildPengobatanCard()
                  .animate(delay: 250.ms)
                  .fadeIn()
                  .slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Preview Card
              _buildPreviewCard()
                  .animate(delay: 300.ms)
                  .fadeIn()
                  .slideY(begin: 0.1),

              const SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: Icon(
                    _isEditMode ? Icons.save_outlined : Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isEditMode ? 'Simpan Perubahan' : 'Tambah Penyakit',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                ),
              ).animate(delay: 350.ms).fadeIn(),

              const SizedBox(height: 10),

              // Tombol Batal
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Batal',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ).animate(delay: 400.ms).fadeIn(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widgets builder ──

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF90CAF9), width: 1),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isEditMode
                  ? 'Mode edit: Ubah data penyakit yang sudah ada.'
                  : 'Isi semua field berikut untuk menambahkan penyakit baru ke dalam sistem pakar.',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF1565C0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentitasCard() {
    return _FormCard(
      children: [
        // Kode
        _FieldLabel(label: 'Kode Penyakit'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _kodeCtrl,
          enabled: !_isEditMode,
          textCapitalization: TextCapitalization.characters,
          decoration: _inputDeco(
            hint: 'Contoh: P011',
            icon: Icons.tag,
            enabled: !_isEditMode,
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'Kode tidak boleh kosong';
            }
            if (!RegExp(r'^P\d+$', caseSensitive: false).hasMatch(v.trim())) {
              return 'Format kode harus P diikuti angka (contoh: P011)';
            }
            return null;
          },
        ),
        if (_isEditMode) ...[
          const SizedBox(height: 4),
          Text(
            '⚠️ Kode tidak dapat diubah saat edit',
            style: GoogleFonts.poppins(
                fontSize: 10, color: Colors.orange.shade700),
          ),
        ],

        const SizedBox(height: 14),

        // Nama
        _FieldLabel(label: 'Nama Penyakit'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _namaCtrl,
          decoration: _inputDeco(
              hint: 'Contoh: Diabetes Melitus',
              icon: Icons.local_hospital_outlined),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Nama penyakit tidak boleh kosong'
              : null,
        ),

        const SizedBox(height: 14),

        // Nama Latin
        _FieldLabel(label: 'Nama Latin / Ilmiah'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _namaLatinCtrl,
          decoration: _inputDeco(
              hint: 'Contoh: Diabetes Mellitus Type 2',
              icon: Icons.science_outlined),
          style: GoogleFonts.poppins(fontSize: 13, fontStyle: FontStyle.italic),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Nama latin tidak boleh kosong'
              : null,
        ),
      ],
    );
  }

  Widget _buildIkonKategoriCard() {
    return _FormCard(
      children: [
        // Pilih Emoji
        _FieldLabel(label: 'Pilih Ikon Penyakit'),
        const SizedBox(height: 10),

        // Preview ikon terpilih
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
              ),
              child: Center(
                child:
                    Text(_selectedEmoji, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Ikon terpilih',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Grid emoji
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PenyakitManager.daftarEmoji.map((e) {
            final selected = _selectedEmoji == e;
            return GestureDetector(
              onTap: () => setState(() => _selectedEmoji = e),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFF1565C0) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF1565C0)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Center(
                  child: Text(e, style: const TextStyle(fontSize: 22)),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // Kategori
        _FieldLabel(label: 'Kategori Penyakit'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedKategori,
          decoration:
              _inputDeco(hint: 'Pilih kategori', icon: Icons.category_outlined),
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          items: PenyakitManager.daftarKategori
              .map((k) => DropdownMenuItem(
                    value: k,
                    child: Text(k),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedKategori = val);
          },
        ),
      ],
    );
  }

  Widget _buildDeskripsiCard() {
    return _FormCard(
      children: [
        _FieldLabel(label: 'Deskripsi Penyakit'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _deskripsiCtrl,
          maxLines: 4,
          decoration: _inputDeco(
            hint: 'Jelaskan penyakit ini secara singkat dan jelas...',
            icon: Icons.description_outlined,
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Deskripsi tidak boleh kosong'
              : null,
        ),
        const SizedBox(height: 14),
        _FieldLabel(label: 'Gejala Utama (ringkasan)'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _gejalaUtamaCtrl,
          maxLines: 2,
          decoration: _inputDeco(
            hint: 'Contoh: Demam, mual, nyeri kepala...',
            icon: Icons.sick_outlined,
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Gejala utama tidak boleh kosong'
              : null,
        ),
      ],
    );
  }

  Widget _buildPengobatanCard() {
    return _FormCard(
      children: [
        _FieldLabel(label: 'Pengobatan'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _pengobatanCtrl,
          maxLines: 3,
          decoration: _inputDeco(
            hint: 'Jelaskan cara pengobatan yang direkomendasikan...',
            icon: Icons.medication_outlined,
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Pengobatan tidak boleh kosong'
              : null,
        ),
        const SizedBox(height: 14),
        _FieldLabel(label: 'Pencegahan'),
        const SizedBox(height: 6),
        TextFormField(
          controller: _pencegahanCtrl,
          maxLines: 3,
          decoration: _inputDeco(
            hint: 'Jelaskan cara pencegahan penyakit ini...',
            icon: Icons.health_and_safety_outlined,
          ),
          style: GoogleFonts.poppins(fontSize: 13),
          validator: (v) => v == null || v.trim().isEmpty
              ? 'Pencegahan tidak boleh kosong'
              : null,
        ),
      ],
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF1565C0).withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header preview
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Text('👁️', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  'Preview Card Penyakit',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Preview isi
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(_selectedEmoji,
                        style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _namaCtrl.text.isEmpty
                            ? 'Nama Penyakit'
                            : _namaCtrl.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        _namaLatinCtrl.text.isEmpty
                            ? 'Nama Latin'
                            : _namaLatinCtrl.text,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _selectedKategori,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDeco({
    required String hint,
    required IconData icon,
    bool enabled = true,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: const Color(0xFF1565C0), size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      filled: true,
      fillColor: enabled ? const Color(0xFFF8F9FF) : Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

// ── Helper Widgets ──

class _SectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
