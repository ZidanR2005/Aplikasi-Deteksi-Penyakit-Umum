// lib/services/knowledge_base.dart
import '../models/penyakit_model.dart';
import '../models/gejala_model.dart';

class KnowledgeBase {
  static final List<Penyakit> daftarPenyakit = [
    Penyakit(
      kode: 'P001',
      nama: 'Vertigo',
      namaLatin: 'Benign Paroxysmal Positional Vertigo',
      deskripsi:
          'Vertigo adalah kondisi yang menyebabkan sensasi pusing berputar. BPPV adalah jenis vertigo yang paling umum, ditandai dengan episode singkat pusing yang dipicu oleh perubahan posisi kepala. Kondisi ini terjadi ketika partikel kalsium kecil (kanalit) menumpuk di saluran telinga bagian dalam.',
      gejalaUtama:
          'Pusing berputar, mual, muntah, keringat dingin, gangguan pendengaran',
      pengobatan:
          'Manuver Epley, obat antivertigo (betahistine), latihan vestibular, istirahat cukup. Konsultasikan dengan dokter spesialis THT.',
      pencegahan:
          'Hindari gerakan kepala yang tiba-tiba, tidur dengan kepala sedikit lebih tinggi, lakukan latihan keseimbangan secara rutin.',
      iconEmoji: '🌀',
      kategori: 'Saraf & Keseimbangan',
    ),
    Penyakit(
      kode: 'P002',
      nama: 'Nyeri Kepala',
      namaLatin: 'Tension Type Headache',
      deskripsi:
          'Nyeri kepala tipe tegang adalah jenis sakit kepala yang paling umum. Ditandai dengan rasa nyeri yang menekan atau seperti diikat di sekitar kepala. Penyebabnya berkaitan dengan ketegangan otot, stres, kurang tidur, atau depresi.',
      gejalaUtama:
          'Nyeri kepala seperti ditekan, nyeri di kedua sisi kepala, kepala terasa berat, tidak memburuk saat aktivitas',
      pengobatan:
          'Analgesik (paracetamol, ibuprofen), relaksasi otot, manajemen stres, kompres hangat/dingin, istirahat yang cukup.',
      pencegahan:
          'Kelola stres dengan baik, tidur yang cukup dan teratur, olahraga rutin, hindari pemicu seperti kafein berlebihan.',
      iconEmoji: '🤕',
      kategori: 'Saraf & Kepala',
    ),
    Penyakit(
      kode: 'P003',
      nama: 'Anemia',
      namaLatin: 'Anemia Defisiensi Besi',
      deskripsi:
          'Anemia defisiensi besi adalah kondisi kekurangan sel darah merah atau hemoglobin akibat kurangnya zat besi dalam tubuh. Zat besi diperlukan untuk produksi hemoglobin yang membawa oksigen ke seluruh tubuh.',
      gejalaUtama:
          'Pucat, lemah, letih, lesu, penglihatan berkunang-kunang, pusing',
      pengobatan:
          'Suplemen zat besi, konsumsi makanan kaya zat besi (daging merah, bayam, kacang-kacangan), vitamin C untuk penyerapan besi, dalam kasus berat: transfusi darah.',
      pencegahan:
          'Konsumsi makanan kaya zat besi secara rutin, hindari konsumsi teh/kopi bersamaan dengan makan, rutin cek darah.',
      iconEmoji: '🩸',
      kategori: 'Darah & Nutrisi',
    ),
    Penyakit(
      kode: 'P004',
      nama: 'ISK',
      namaLatin: 'Infeksi Saluran Kencing',
      deskripsi:
          'Infeksi Saluran Kemih (ISK) adalah infeksi yang terjadi di bagian mana pun dari sistem kemih, termasuk ginjal, ureter, kandung kemih, dan uretra. Sebagian besar infeksi melibatkan saluran kemih bagian bawah yaitu kandung kemih dan uretra.',
      gejalaUtama:
          'Demam, nyeri pinggang, nyeri di atas kemaluan, nyeri saat kencing, sering kencing',
      pengobatan:
          'Antibiotik sesuai resep dokter, banyak minum air putih, obat pereda nyeri, hindari menahan kencing.',
      pencegahan:
          'Minum air yang cukup, jaga kebersihan area genital, buang air kecil setelah berhubungan, hindari penggunaan produk yang mengiritasi.',
      iconEmoji: '🫘',
      kategori: 'Urologi',
    ),
    Penyakit(
      kode: 'P005',
      nama: 'Pneumonia',
      namaLatin: 'Radang Parenkim Paru',
      deskripsi:
          'Pneumonia adalah infeksi yang menyebabkan peradangan pada kantung udara di satu atau kedua paru-paru. Kantung udara dapat terisi dengan cairan atau nanah, menyebabkan batuk dengan dahak, demam, menggigil, dan kesulitan bernapas.',
      gejalaUtama: 'Batuk dahak kental, pilek, demam, sesak napas',
      pengobatan:
          'Antibiotik (untuk pneumonia bakteri), antipiretik, ekspektoran, istirahat total, banyak minum, rawat inap jika parah.',
      pencegahan:
          'Vaksinasi pneumonia, vaksin flu tahunan, cuci tangan rutin, jaga kebersihan, hindari merokok.',
      iconEmoji: '🫁',
      kategori: 'Pernapasan',
    ),
    Penyakit(
      kode: 'P006',
      nama: 'Tipes',
      namaLatin: 'Tifoid Fever',
      deskripsi:
          'Demam tifoid adalah penyakit infeksi akut yang disebabkan oleh bakteri Salmonella typhi. Penyakit ini ditandai dengan demam yang berlangsung lebih dari 7 hari, gangguan pencernaan, dan gangguan kesadaran pada kasus berat.',
      gejalaUtama:
          'Demam >7 hari, nyeri kepala, konstipasi/diare, mual, susah makan, keringat dingin',
      pengobatan:
          'Antibiotik (kloramfenikol, amoksisilin, siprofloksasin), istirahat total, diet lunak, banyak minum, rawat inap untuk kasus berat.',
      pencegahan:
          'Vaksinasi tifoid, cuci tangan dengan sabun, konsumsi air matang, jaga kebersihan makanan, hindari jajan sembarangan.',
      iconEmoji: '🤒',
      kategori: 'Infeksi Bakteri',
    ),
    Penyakit(
      kode: 'P007',
      nama: 'Dispepsia',
      namaLatin: 'Sindrom Dispepsia / Dyspepsia',
      deskripsi:
          'Dispepsia atau gangguan pencernaan adalah istilah umum untuk ketidaknyamanan atau nyeri di perut bagian atas. Kondisi ini seringkali berkaitan dengan kebiasaan makan, stres, atau kondisi medis tertentu seperti GERD atau tukak lambung.',
      gejalaUtama:
          'Nyeri perut tengah atas seperti terbakar, rasa penuh setelah makan, cepat kenyang, perut kembung, sendawa',
      pengobatan:
          'Antasida, PPI (omeprazole), H2 blocker, perubahan pola makan, hindari makanan pemicu, manajemen stres.',
      pencegahan:
          'Makan teratur dan tidak terburu-buru, hindari makanan berlemak dan pedas, kurangi kafein dan alkohol, kelola stres.',
      iconEmoji: '🫃',
      kategori: 'Pencernaan',
    ),
    Penyakit(
      kode: 'P008',
      nama: 'Konjungtivitis',
      namaLatin: 'Radang Selaput Mata',
      deskripsi:
          'Konjungtivitis adalah peradangan atau infeksi pada membran transparan (konjungtiva) yang melapisi kelopak mata dan bagian putih bola mata. Dapat disebabkan oleh bakteri, virus, alergi, atau bahan kimia.',
      gejalaUtama:
          'Mata merah, mata berair, mata terasa mengganjal, keluar banyak kotoran di mata',
      pengobatan:
          'Tetes mata antibiotik (bakteri), tetes mata antivirus (virus), antihistamin (alergi), kompres hangat, hindari mengucek mata.',
      pencegahan:
          'Cuci tangan sering, hindari menyentuh mata, jangan berbagi handuk atau alat makeup, ganti lensa kontak secara teratur.',
      iconEmoji: '👁️',
      kategori: 'Mata',
    ),
    Penyakit(
      kode: 'P009',
      nama: 'Amandel',
      namaLatin: 'Tonsilitis Akut',
      deskripsi:
          'Tonsilitis akut adalah peradangan pada amandel (tonsil) yang disebabkan oleh infeksi virus atau bakteri. Amandel adalah dua massa jaringan berbentuk oval di bagian belakang tenggorokan yang berfungsi sebagai bagian dari sistem kekebalan tubuh.',
      gejalaUtama:
          'Tenggorokan kering, nyeri tenggorokan, nyeri menelan, demam tinggi, tidak mau makan',
      pengobatan:
          'Antibiotik (jika bakteri), analgesik, obat kumur antiseptik, banyak minum air hangat, istirahat, operasi tonsilektomi untuk kasus kronis.',
      pencegahan:
          'Cuci tangan rutin, hindari kontak dengan orang yang sakit, jaga daya tahan tubuh, konsumsi makanan bergizi.',
      iconEmoji: '🫀',
      kategori: 'THT',
    ),
    Penyakit(
      kode: 'P010',
      nama: 'Biduran',
      namaLatin: 'Urtikaria',
      deskripsi:
          'Urtikaria atau biduran adalah reaksi kulit yang menyebabkan bintik-bintik merah yang gatal. Kondisi ini biasanya dipicu oleh alergen seperti makanan, obat-obatan, gigitan serangga, atau faktor lingkungan.',
      gejalaUtama:
          'Gatal, kulit bentol-bentol kemerahan, sensasi seperti tersengat atau sangat gatal hingga terasa panas',
      pengobatan:
          'Antihistamin (cetirizine, loratadine), kortikosteroid untuk kasus berat, hindari pemicu alergi, kompres dingin pada area yang gatal.',
      pencegahan:
          'Identifikasi dan hindari pemicu alergi, catat makanan/obat yang dikonsumsi saat reaksi terjadi, konsultasi dengan dokter alergi.',
      iconEmoji: '🌡️',
      kategori: 'Kulit & Alergi',
    ),
  ];

  static final List<Gejala> daftarGejala = [
    Gejala(
      kode: 'G1',
      nama: 'Pusing Berputar',
      massFunctions: {'P001': 0.8},
    ),
    Gejala(
      kode: 'G2',
      nama: 'Ada atau Tidak Gangguan Pendengaran',
      massFunctions: {'P001': 0.5},
    ),
    Gejala(
      kode: 'G3',
      nama: 'Sering Mual',
      massFunctions: {'P001': 0.6, 'P006': 0.9, 'P007': 0.7},
    ),
    Gejala(
      kode: 'G4',
      nama: 'Sering Muntah',
      massFunctions: {'P001': 0.5, 'P006': 0.7, 'P007': 0.5},
    ),
    Gejala(
      kode: 'G5',
      nama: 'Keringat Dingin',
      massFunctions: {'P001': 0.4, 'P006': 0.1},
    ),
    Gejala(
      kode: 'G6',
      nama: 'Nyeri Kepala Seperti Ditekan',
      massFunctions: {'P002': 0.9},
    ),
    Gejala(
      kode: 'G7',
      nama: 'Nyeri Di Kedua Bagian Kepala',
      massFunctions: {'P002': 0.8},
    ),
    Gejala(
      kode: 'G8',
      nama: 'Tidak Bertambah Berat Dengan Aktivitas',
      massFunctions: {'P002': 0.7},
    ),
    Gejala(
      kode: 'G9',
      nama: 'Kepala Terasa Berat',
      massFunctions: {'P002': 0.6},
    ),
    Gejala(
      kode: 'G10',
      nama: 'Ada Gangguan Tidur',
      massFunctions: {'P002': 0.5},
    ),
    Gejala(
      kode: 'G11',
      nama: 'Pencetus (Stres, Depresi, Kurang Tidur)',
      massFunctions: {'P002': 0.7},
    ),
    Gejala(
      kode: 'G12',
      nama: 'Pucat',
      massFunctions: {'P003': 0.8},
    ),
    Gejala(
      kode: 'G13',
      nama: 'Lemah',
      massFunctions: {'P003': 0.7},
    ),
    Gejala(
      kode: 'G14',
      nama: 'Letih',
      massFunctions: {'P003': 0.7},
    ),
    Gejala(
      kode: 'G15',
      nama: 'Lesu',
      massFunctions: {'P003': 0.7},
    ),
    Gejala(
      kode: 'G16',
      nama: 'Penglihatan Berkunang-Kunang',
      massFunctions: {'P003': 0.8},
    ),
    Gejala(
      kode: 'G17',
      nama: 'Pusing',
      massFunctions: {'P003': 0.6},
    ),
    Gejala(
      kode: 'G18',
      nama: 'Demam',
      massFunctions: {'P004': 0.6, 'P005': 0.7},
    ),
    Gejala(
      kode: 'G19',
      nama: 'Jarang Mual',
      massFunctions: {'P004': 0.3},
    ),
    Gejala(
      kode: 'G20',
      nama: 'Jarang Muntah',
      massFunctions: {'P004': 0.3},
    ),
    Gejala(
      kode: 'G21',
      nama: 'Nyeri Pinggang',
      massFunctions: {'P004': 0.8},
    ),
    Gejala(
      kode: 'G22',
      nama: 'Nyeri Di Atas Kemaluan',
      massFunctions: {'P004': 0.9},
    ),
    Gejala(
      kode: 'G23',
      nama: 'Nyeri Kencing',
      massFunctions: {'P004': 0.9},
    ),
    Gejala(
      kode: 'G24',
      nama: 'Sering Kencing',
      massFunctions: {'P004': 0.8},
    ),
    Gejala(
      kode: 'G25',
      nama: 'Batuk Dahak Kental',
      massFunctions: {'P005': 0.9},
    ),
    Gejala(
      kode: 'G26',
      nama: 'Pilek',
      massFunctions: {'P005': 0.6},
    ),
    Gejala(
      kode: 'G27',
      nama: 'Demam >7 Hari',
      massFunctions: {'P006': 0.9},
    ),
    Gejala(
      kode: 'G28',
      nama: 'Nyeri Kepala',
      massFunctions: {'P006': 0.7},
    ),
    Gejala(
      kode: 'G29',
      nama: 'Konstipasi (Susah Buang Air Besar)',
      massFunctions: {'P006': 0.6},
    ),
    Gejala(
      kode: 'G30',
      nama: 'Diare',
      massFunctions: {'P006': 0.9, 'P007': 0.4},
    ),
    Gejala(
      kode: 'G31',
      nama: 'BAB Berdarah',
      massFunctions: {'P006': 0.3},
    ),
    Gejala(
      kode: 'G32',
      nama: 'Susah Makan',
      massFunctions: {'P006': 0.5, 'P007': 0.6},
    ),
    Gejala(
      kode: 'G33',
      nama: 'Nyeri Perut',
      massFunctions: {'P007': 0.7},
    ),
    Gejala(
      kode: 'G34',
      nama: 'Nyeri Perut Tengah Atas Seperti Terbakar',
      massFunctions: {'P007': 0.9},
    ),
    Gejala(
      kode: 'G35',
      nama: 'Rasa Penuh Setelah Makan',
      massFunctions: {'P007': 0.8},
    ),
    Gejala(
      kode: 'G36',
      nama: 'Cepat Kenyang',
      massFunctions: {'P007': 0.7},
    ),
    Gejala(
      kode: 'G37',
      nama: 'Perut Kembung',
      massFunctions: {'P007': 0.7},
    ),
    Gejala(
      kode: 'G38',
      nama: 'Sendawa',
      massFunctions: {'P007': 0.6},
    ),
    Gejala(
      kode: 'G39',
      nama: 'Mata Merah',
      massFunctions: {'P008': 0.9},
    ),
    Gejala(
      kode: 'G40',
      nama: 'Mata Berair',
      massFunctions: {'P008': 0.8},
    ),
    Gejala(
      kode: 'G41',
      nama: 'Mata Terasa Mengganjal',
      massFunctions: {'P008': 0.8},
    ),
    Gejala(
      kode: 'G42',
      nama: 'Keluar Banyak Kotoran Di Mata',
      massFunctions: {'P008': 0.9},
    ),
    Gejala(
      kode: 'G43',
      nama: 'Tenggorokan Terasa Kering',
      massFunctions: {'P009': 0.7},
    ),
    Gejala(
      kode: 'G44',
      nama: 'Nyeri Tenggorokan',
      massFunctions: {'P009': 0.9},
    ),
    Gejala(
      kode: 'G45',
      nama: 'Nyeri Menelan',
      massFunctions: {'P009': 0.9},
    ),
    Gejala(
      kode: 'G46',
      nama: 'Demam Tinggi',
      massFunctions: {'P009': 0.8},
    ),
    Gejala(
      kode: 'G47',
      nama: 'Tidak Mau Makan',
      massFunctions: {'P009': 0.7},
    ),
    Gejala(
      kode: 'G48',
      nama: 'Gatal',
      massFunctions: {'P010': 0.9},
    ),
    Gejala(
      kode: 'G49',
      nama: 'Kulit Bentol-Bentol Kemerahan',
      massFunctions: {'P010': 0.9},
    ),
    Gejala(
      kode: 'G50',
      nama: 'Seperti Tersengat (Sangat Gatal Hingga Berasa Panas)',
      massFunctions: {'P010': 0.8},
    ),
    Gejala(
      kode: 'G51',
      nama: 'Sesak Napas',
      massFunctions: {'P005': 0.8, 'P010': 0.3},
    ),
  ];
}
