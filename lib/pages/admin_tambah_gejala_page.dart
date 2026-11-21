// lib/pages/admin_tambah_gejala_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gejala_model.dart';
import '../services/knowledge_base.dart';
import '../services/gejala_manager.dart';

class AdminTambahGejalaPage extends StatefulWidget {
  final Gejala? gejalaEdit; // null = mode tambah, isi = mode edit

  const AdminTambahGejalaPage({super.key, this.gejalaEdit});

  @override
  State<AdminTambahGejalaPage> createState() => _AdminTambahGejalaPageState();
}

class _AdminTambahGejalaPageState extends State<AdminTambahGejalaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kodeCtrl;
  late TextEditingController _namaCtrl;

  bool get _isEditMode => widget.gejalaEdit != null;

  // Map penyakit -> nilai DS yang dipilih
  final Map<String, double> _selectedPenyakit = {};

  // Daftar semua penyakit yang tersedia untuk dipilih
  final List<String> _allPenyakitKode = [
    'P001',
    'P002',
    'P003',
    'P004',
    'P005',
    'P006',
    'P007',
    'P008',
    'P009',
    'P010'
  ];

  final Map<String, String> _namaPenyakit = {
    'P001': 'Vertigo',
    'P002': 'Nyeri Kepala',
    'P003': 'Anemia',
    'P004': 'ISK',
    'P005': 'Pneumonia',
    'P006': 'Tipes',
    'P007': 'Dispepsia',
    'P008': 'Konjungtivitis',
    'P009': 'Amandel',
    'P010': 'Biduran',
  };

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _kodeCtrl = TextEditingController(text: widget.gejalaEdit!.kode);
      _namaCtrl = TextEditingController(text: widget.gejalaEdit!.nama);
      _selectedPenyakit.addAll(widget.gejalaEdit!.massFunctions);
    } else {
      _kodeCtrl = TextEditingController(text: GejalaManager.generateKode());
      _namaCtrl = TextEditingController();
    }
  }

  @override
  void dispose() {
    _kodeCtrl.dispose();
    _namaCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPenyakit.isEmpty) {
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
              Text('Pilih minimal 1 penyakit terkait!',
                  style: GoogleFonts.poppins(fontSize: 13)),
            ],
          ),
        ),
      );
      return;
    }

    final kode = _kodeCtrl.text.trim().toUpperCase();
    final nama = _namaCtrl.text.trim();

    // Cek duplikasi kode (hanya saat tambah baru)
    if (!_isEditMode && GejalaManager.kodeExists(kode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD32F2F),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Text('❌'),
              const SizedBox(width: 8),
              Text('Kode "$kode" sudah digunakan!',
                  style: GoogleFonts.poppins(fontSize: 13)),
            ],
          ),
        ),
      );
      return;
    }

    final gejalaBar = Gejala(
      kode: kode,
      nama: nama,
      massFunctions: Map.from(_selectedPenyakit),
    );

    if (_isEditMode) {
      GejalaManager.editGejala(widget.gejalaEdit!.kode, gejalaBar);
    } else {
      GejalaManager.tambahGejala(gejalaBar);
    }

    // Tampilkan sukses

// Tampilkan sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Text('✅'),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _isEditMode
                    ? 'Gejala berhasil diperbarui!'
                    : 'Gejala "$nama" berhasil ditambahkan!',
                style: GoogleFonts.poppins(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text(
          _isEditMode ? 'Edit Gejala' : 'Tambah Gejala Baru',
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
              Container(
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
                            ? 'Mode edit: Ubah data gejala yang sudah ada.'
                            : 'Isi form berikut untuk menambahkan gejala baru ke dalam sistem pakar.',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: const Color(0xFF1565C0)),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

              const SizedBox(height: 20),

              // ── SECTION 1: Informasi Gejala ──
              _SectionHeader(title: '1. Informasi Gejala', emoji: '📝'),
              const SizedBox(height: 12),

              // Form card
              Container(
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
                  children: [
                    // Kode Gejala
                    _FieldLabel(label: 'Kode Gejala'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _kodeCtrl,
                      enabled: !_isEditMode,
                      textCapitalization: TextCapitalization.characters,
                      decoration: _inputDeco(
                        hint: 'Contoh: G52',
                        icon: Icons.tag,
                        enabled: !_isEditMode,
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Kode gejala tidak boleh kosong';
                        }
                        if (!RegExp(r'^G\d+$', caseSensitive: false)
                            .hasMatch(v.trim())) {
                          return 'Format kode harus G diikuti angka (contoh: G52)';
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

                    const SizedBox(height: 16),

                    // Nama Gejala
                    _FieldLabel(label: 'Nama Gejala'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _namaCtrl,
                      decoration: _inputDeco(
                        hint: 'Contoh: Nyeri Sendi',
                        icon: Icons.text_fields,
                      ),
                      style: GoogleFonts.poppins(fontSize: 13),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama gejala tidak boleh kosong';
                        }
                        if (v.trim().length < 3) {
                          return 'Nama gejala minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 20),

              // ── SECTION 2: Relasi Penyakit & Nilai DS ──
              _SectionHeader(
                  title: '2. Penyakit Terkait & Nilai Keyakinan', emoji: '🦠'),
              const SizedBox(height: 6),
              Text(
                'Pilih penyakit yang berkaitan dengan gejala ini, lalu atur nilai keyakinan Dempster-Shafer (0.0 – 1.0)',
                style: GoogleFonts.poppins(
                    fontSize: 11.5, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),

              // List penyakit dengan slider DS
              ..._allPenyakitKode.asMap().entries.map((entry) {
                final kode = entry.value;
                final nama = _namaPenyakit[kode] ?? kode;
                final isSelected = _selectedPenyakit.containsKey(kode);
                final nilaiDS = _selectedPenyakit[kode] ?? 0.5;

                return _PenyakitDSCard(
                  kode: kode,
                  nama: nama,
                  isSelected: isSelected,
                  nilaiDS: nilaiDS,
                  index: entry.key,
                  onToggle: (val) {
                    setState(() {
                      if (val) {
                        _selectedPenyakit[kode] = 0.5;
                      } else {
                        _selectedPenyakit.remove(kode);
                      }
                    });
                  },
                  onSliderChanged: (val) {
                    setState(() => _selectedPenyakit[kode] = val);
                  },
                );
              }),

              const SizedBox(height: 20),

              // ── Preview nilai DS ──
              if (_selectedPenyakit.isNotEmpty) ...[
                _SectionHeader(title: '3. Ringkasan Nilai DS', emoji: '📊'),
                const SizedBox(height: 12),
                _buildPreviewDS(),
                const SizedBox(height: 20),
              ],

              // Tombol simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: Icon(
                    _isEditMode ? Icons.save_outlined : Icons.add_circle,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isEditMode ? 'Simpan Perubahan' : 'Tambah Gejala',
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
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: 10),

              // Tombol batal
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate(delay: 250.ms).fadeIn(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewDS() {
    return Container(
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
        children: [
          // Nama gejala
          if (_namaCtrl.text.isNotEmpty) ...[
            Text(
              _namaCtrl.text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Kode: ${_kodeCtrl.text}',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 10),
          ],
          ..._selectedPenyakit.entries.map((e) {
            final namaPenyakit = _namaPenyakit[e.key] ?? e.key;
            final pct = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      e.key,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1565C0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      namaPenyakit,
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getColorForValue(pct).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'DS: ${pct.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _getColorForValue(pct),
                      ),
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

  Color _getColorForValue(double val) {
    if (val >= 0.7) return const Color(0xFF2E7D32);
    if (val >= 0.4) return const Color(0xFFE65100);
    return const Color(0xFFB71C1C);
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

// ── Widget helper ──

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

class _PenyakitDSCard extends StatelessWidget {
  final String kode;
  final String nama;
  final bool isSelected;
  final double nilaiDS;
  final int index;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onSliderChanged;

  const _PenyakitDSCard({
    required this.kode,
    required this.nama,
    required this.isSelected,
    required this.nilaiDS,
    required this.index,
    required this.onToggle,
    required this.onSliderChanged,
  });

  Color get _sliderColor {
    if (nilaiDS >= 0.7) return const Color(0xFF2E7D32);
    if (nilaiDS >= 0.4) return const Color(0xFFE65100);
    return const Color(0xFFB71C1C);
  }

  String get _levelLabel {
    if (nilaiDS >= 0.7) return 'Tinggi';
    if (nilaiDS >= 0.4) return 'Sedang';
    return 'Rendah';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF1565C0) : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onToggle(!isSelected),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  // Kode badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      kode,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nama,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFF1A237E)
                            : Colors.black87,
                      ),
                    ),
                  ),
                  // Checkbox
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1565C0)
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                ],
              ),
            ),
          ),

          // Slider (hanya tampil kalau dipilih)
          if (isSelected)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: Colors.blue.shade100),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Nilai DS (Keyakinan):',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: _sliderColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${nilaiDS.toStringAsFixed(2)} ($_levelLabel)',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _sliderColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: _sliderColor,
                      thumbColor: _sliderColor,
                      inactiveTrackColor: Colors.grey.shade200,
                      overlayColor: _sliderColor.withOpacity(0.1),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: nilaiDS,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      onChanged: onSliderChanged,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0.1 (Rendah)',
                          style: GoogleFonts.poppins(
                              fontSize: 9, color: Colors.grey.shade400)),
                      Text('1.0 (Tinggi)',
                          style: GoogleFonts.poppins(
                              fontSize: 9, color: Colors.grey.shade400)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 40))
        .fadeIn()
        .slideX(begin: 0.05);
  }
}
