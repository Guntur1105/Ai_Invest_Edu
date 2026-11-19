import '../models/question.dart';

// ==================== LEVEL MUDAH (5 SOAL) ====================
final List<Question> questionsEasy = [
  Question(
    question: "Apa itu investasi?",
    options: [
      "Menabung di bank",
      "Menanamkan modal untuk mendapat keuntungan di masa depan",
      "Membeli barang mewah",
      "Meminjam uang",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Manfaat utama investasi adalah?",
    options: [
      "Menambah kekayaan",
      "Mengurangi uang",
      "Menambah hutang",
      "Membeli barang",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Investasi dapat mengalahkan?",
    options: [
      "Pajak",
      "Inflasi",
      "Diskon",
      "Bunga bank",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Salah satu tujuan investasi adalah?",
    options: [
      "Membeli mobil",
      "Mencapai tujuan keuangan",
      "Bersantai",
      "Jalan-jalan",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Investasi sebaiknya dilakukan secara?",
    options: [
      "Sekali saja",
      "Konsisten",
      "Terburu-buru",
      "Sembarangan",
    ],
    answerIndex: 1,
  ),
];

// ==================== LEVEL SEDANG (10 SOAL) ====================
final List<Question> questionsMedium = [
  ...questionsEasy, // 5 soal pertama sama
  Question(
    question: "Apa itu reksadana?",
    options: [
      "Wadah investasi yang menghimpun dana masyarakat",
      "Pinjaman bank",
      "Tabungan biasa",
      "Kartu kredit",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Saham adalah bukti kepemilikan?",
    options: [
      "Utang perusahaan",
      "Bagian dari perusahaan",
      "Tabungan bank",
      "Barang mewah",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Obligasi adalah surat berharga yang bersifat?",
    options: [
      "Kepemilikan",
      "Utang",
      "Hadiah",
      "Hibah",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Risiko investasi saham tergolong?",
    options: [
      "Rendah",
      "Sedang",
      "Tinggi",
      "Tidak ada",
    ],
    answerIndex: 2,
  ),
  Question(
    question: "Diversifikasi bertujuan untuk?",
    options: [
      "Mengurangi risiko",
      "Menambah risiko",
      "Menghabiskan uang",
      "Menambah hutang",
    ],
    answerIndex: 0,
  ),
];

// ==================== LEVEL SULIT (20 SOAL) ====================
final List<Question> questionsHard = [
  ...questionsMedium, // 10 soal pertama sama
  Question(
    question: "Apa itu diversifikasi?",
    options: [
      "Menaruh semua dana di satu aset",
      "Menyebar dana ke berbagai aset",
      "Meminjam uang",
      "Menghabiskan uang",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Indeks Harga Saham Gabungan (IHSG) adalah?",
    options: [
      "Indeks saham di BEI",
      "Nama perusahaan",
      "Jenis obligasi",
      "Mata uang",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Apa itu return investasi?",
    options: [
      "Kerugian",
      "Keuntungan dari investasi",
      "Pajak",
      "Biaya admin",
    ],
    answerIndex: 1,
  ),
  Question(
    question: "Profil risiko investor dibagi menjadi?",
    options: [
      "Konservatif, moderat, agresif",
      "Kaya dan miskin",
      "Tua dan muda",
      "Pria dan wanita",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Apa itu compounding?",
    options: [
      "Bunga berbunga",
      "Kerugian",
      "Pajak",
      "Biaya",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Lembaga yang mengatur pasar modal Indonesia adalah?",
    options: [
      "OJK",
      "BI",
      "Kemenkeu",
      "Bappenas",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Investasi jangka panjang biasanya minimal?",
    options: [
      "1 bulan",
      "1 tahun",
      "5 tahun",
      "1 minggu",
    ],
    answerIndex: 2,
  ),
  Question(
    question: "Apa itu aset produktif?",
    options: [
      "Aset yang menghasilkan uang",
      "Aset yang tidak berguna",
      "Aset yang hilang",
      "Aset yang rusak",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Apa itu inflasi?",
    options: [
      "Kenaikan harga barang secara umum",
      "Penurunan harga",
      "Diskon",
      "Promo",
    ],
    answerIndex: 0,
  ),
  Question(
    question: "Investasi yang paling aman adalah?",
    options: [
      "Saham",
      "Deposito",
      "Forex",
      "Kripto",
    ],
    answerIndex: 1,
  ),
];

// Backward compatibility (agar kode lama tetap jalan)
final List<Question> questions = questionsEasy;