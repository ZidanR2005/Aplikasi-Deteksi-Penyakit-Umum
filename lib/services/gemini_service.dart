// lib/services/gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'penyakit_manager.dart';
import 'gejala_manager.dart';

class GeminiService {
  // =====================================================
  // GANTI 'YOUR_GEMINI_API_KEY' dengan API key Anda
  // Dapatkan gratis di: https://aistudio.google.com/app/apikey
  // =====================================================
  static const String _apiKey = 'ISI API SENDIRI YA';

  static GeminiService? _instance;
  static GeminiService get instance => _instance ??= GeminiService._();

  GeminiService._();

  GenerativeModel? _model;
  ChatSession? _chat;

  /// Cek apakah API key sudah diisi (bukan placeholder)
  bool get isConfigured =>
      _apiKey.isNotEmpty && _apiKey != 'YOUR_GEMINI_API_KEY';

  String _buildSystemPrompt() {
    final penyakitList = PenyakitManager.getAllPenyakit();
    final gejalaList = GejalaManager.getAllGejala();

    // Gunakan field yang ada di model Penyakit (gejalaUtama, bukan gejalaDsValues)
    final penyakitInfo = penyakitList.map((p) {
      return '- ${p.nama} (${p.kode}): ${p.deskripsi}\n'
          '  Gejala: ${p.gejalaUtama}\n'
          '  Pengobatan: ${p.pengobatan}\n'
          '  Pencegahan: ${p.pencegahan}';
    }).join('\n\n');

    final gejalaInfo =
        gejalaList.map((g) => '- ${g.kode}: ${g.nama}').join('\n');

    return '''Kamu adalah asisten kesehatan virtual dalam aplikasi "Sistem Pakar Deteksi Penyakit Umum" berbasis metode Dempster-Shafer.
Tugasmu adalah membantu pengguna memahami penyakit umum, gejala-gejalanya, dan saran kesehatan umum.

ATURAN PENTING:
- Selalu ingatkan pengguna bahwa kamu BUKAN pengganti dokter profesional.
- Untuk diagnosis akurat, selalu sarankan pengguna menggunakan fitur "Diagnosa" di aplikasi ini atau konsultasi ke dokter.
- Jawab dalam Bahasa Indonesia yang ramah dan mudah dipahami.
- Berikan jawaban yang informatif tapi ringkas (maks 3-4 paragraf).
- Gunakan emoji secukupnya agar mudah dibaca.

DATA PENYAKIT DALAM SISTEM PAKAR:
$penyakitInfo

DAFTAR KODE GEJALA:
$gejalaInfo

Jika pengguna menanyakan sesuatu di luar konteks penyakit di atas, tetap bantu sesuai kemampuanmu sebagai asisten kesehatan umum.''';
  }

  /// Inisialisasi model dan sesi chat
  void initChat() {
    if (!isConfigured) return;

    _model = GenerativeModel(
      model: 'gemini-3.5-flash-lite',
      apiKey: _apiKey,
      systemInstruction: Content.system(_buildSystemPrompt()),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
    );

    _chat = _model!.startChat();
  }

  /// Kirim pesan dan terima balasan dari Gemini
  Future<String> sendMessage(String message) async {
    if (!isConfigured) {
      return '⚠️ API Key belum dikonfigurasi.\n\n'
          'Silakan:\n'
          '1. Buka file `lib/services/gemini_service.dart`\n'
          '2. Ganti `YOUR_GEMINI_API_KEY` dengan key Anda\n'
          '3. Dapatkan key gratis di: aistudio.google.com/app/apikey';
    }

    // Init model jika belum
    if (_model == null) {
      initChat();
    }

    _chat ??= _model!.startChat();

    try {
      final response = await _chat!.sendMessage(Content.text(message));
      final text = response.text;
      if (text == null || text.isEmpty) {
        return 'Maaf, tidak ada respons dari AI. Coba lagi.';
      }
      return text;
    } catch (e) {
      final errMsg = e.toString();
      if (errMsg.contains('API_KEY') || errMsg.contains('API key')) {
        return '❌ API Key tidak valid. Pastikan key Anda benar di file `gemini_service.dart`.';
      } else if (errMsg.contains('quota') || errMsg.contains('QUOTA')) {
        return '❌ Kuota API habis. Silakan coba lagi nanti atau cek quota di Google AI Studio.';
      } else if (errMsg.contains('network') || errMsg.contains('connection')) {
        return '❌ Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      }
      return '❌ Terjadi kesalahan: $errMsg';
    }
  }

  /// Reset percakapan ke awal
  void resetChat() {
    _chat = null;
    if (isConfigured && _model != null) {
      _chat = _model!.startChat();
    }
  }
}
