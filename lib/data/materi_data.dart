
import 'package:flutter/material.dart';
import '../models/materi.dart';

List<Materi> materiList = [
  // 1. PENGERTIAN INVESTASI
  Materi(
    title: "Pengertian Investasi",
    description: "Mengenal konsep dan tujuan investasi",
    explanation:
        "Investasi adalah kegiatan menanamkan sejumlah uang atau modal ke dalam suatu aset atau instrumen keuangan dengan tujuan memperoleh keuntungan atau meningkatkan nilai aset tersebut di masa depan. Sederhananya, investasi merupakan cara mengembangkan uang agar nilainya dapat bertambah seiring berjalannya waktu. Berbeda dengan menabung yang umumnya bertujuan menyimpan uang agar dapat digunakan sewaktu-waktu, investasi bertujuan mengembangkan kekayaan untuk memenuhi kebutuhan finansial jangka pendek, menengah, maupun panjang. Namun, investasi tidak selalu menghasilkan keuntungan karena setiap instrumen memiliki risiko, termasuk kemungkinan mengalami kerugian.",
    points: [
      "Menambah dan mengembangkan kekayaan.",
      "Membantu melindungi nilai uang dari inflasi.",
      "Mencapai tujuan keuangan di masa depan.",
      "Mempersiapkan dana pendidikan.",
      "Mempersiapkan dana pensiun.",
      "Membangun kebebasan finansial.",
      "Mengembangkan modal agar menghasilkan keuntungan."
    ],
    icon: Icons.school,
    color: Colors.blue,
  ),

  // 2. TUJUAN INVESTASI
  Materi(
    title: "Tujuan Investasi",
    description: "Mengapa seseorang perlu berinvestasi?",
    explanation:
        "Tujuan investasi adalah hasil keuangan yang ingin dicapai seseorang dengan menanamkan modal pada suatu aset. Setiap orang memiliki tujuan investasi yang berbeda sesuai kebutuhan, kondisi keuangan, dan rencana masa depan. Dengan menentukan tujuan sejak awal, investor dapat memilih instrumen investasi yang tepat dan menentukan berapa lama dana tersebut akan diinvestasikan.",
    points: [
      "Menyiapkan biaya pendidikan.",
      "Membeli rumah atau kendaraan.",
      "Mempersiapkan dana pensiun.",
      "Membangun kekayaan dalam jangka panjang.",
      "Mendapatkan penghasilan tambahan.",
      "Melindungi nilai kekayaan dari inflasi.",
      "Mencapai kebebasan finansial."
    ],
    icon: Icons.flag,
    color: Colors.green,
  ),

  // 3. DASAR-DASAR INVESTASI
  Materi(
    title: "Dasar-Dasar Investasi",
    description: "Pengetahuan dasar sebelum berinvestasi",
    explanation:
        "Dasar-dasar investasi merupakan pengetahuan awal yang harus dipahami sebelum seseorang mulai menanamkan modal. Pengetahuan ini membantu investor mengambil keputusan secara bijak berdasarkan kemampuan keuangan, tujuan, dan tingkat risiko yang dapat diterima. Seorang investor perlu memahami modal, keuntungan, risiko, jangka waktu, dan jenis instrumen investasi agar tidak hanya mengikuti tren atau janji keuntungan yang belum tentu benar.",
    points: [
      "Tujuan investasi: menentukan hasil yang ingin dicapai.",
      "Modal investasi: uang yang digunakan untuk membeli aset.",
      "Return: hasil atau keuntungan dari investasi.",
      "Risiko: kemungkinan mengalami kerugian.",
      "Jangka waktu: lamanya dana diinvestasikan.",
      "Diversifikasi: membagi modal ke beberapa instrumen.",
      "Profil risiko: mengetahui kemampuan menerima kerugian."
    ],
    icon: Icons.menu_book,
    color: Colors.indigo,
  ),

  // 4. MODAL INVESTASI
  Materi(
    title: "Modal Investasi",
    description: "Memahami dana awal untuk berinvestasi",
    explanation:
        "Modal investasi adalah sejumlah uang atau dana yang digunakan seseorang untuk membeli instrumen atau aset investasi. Besarnya modal bergantung pada jenis investasi dan kemampuan keuangan masing-masing individu. Investasi tidak selalu harus dimulai dengan uang yang besar karena beberapa instrumen memungkinkan seseorang memulai dengan nominal kecil. Sebelum berinvestasi, kebutuhan sehari-hari dan dana darurat sebaiknya sudah dipersiapkan.",
    points: [
      "Modal digunakan untuk membeli aset investasi.",
      "Investasi dapat dimulai dengan nominal kecil.",
      "Sesuaikan modal dengan kemampuan keuangan.",
      "Jangan menggunakan uang kebutuhan sehari-hari.",
      "Siapkan dana darurat sebelum berinvestasi.",
      "Hindari berutang hanya untuk berinvestasi.",
      "Tambahkan modal secara bertahap sesuai kemampuan."
    ],
    icon: Icons.account_balance_wallet,
    color: Colors.teal,
  ),

  // 5. SAHAM
  Materi(
    title: "Saham",
    description: "Belajar kepemilikan perusahaan untuk pemula",
    explanation:
        "Saham adalah bukti kepemilikan seseorang terhadap sebagian modal suatu perusahaan. Ketika membeli saham, investor menjadi salah satu pemilik perusahaan tersebut. Keuntungan dapat diperoleh melalui kenaikan harga saham yang disebut Capital Gain dan pembagian keuntungan perusahaan yang disebut Dividen. Namun, harga saham dapat berubah setiap saat mengikuti kondisi pasar, kinerja perusahaan, dan berbagai faktor ekonomi. Oleh karena itu, investasi saham membutuhkan pengetahuan dan pemahaman terhadap perusahaan yang dipilih.",
    points: [
      "Saham merupakan bukti kepemilikan perusahaan.",
      "Capital Gain: keuntungan dari kenaikan harga saham.",
      "Dividen: pembagian keuntungan perusahaan.",
      "Capital Loss: kerugian akibat penurunan harga saham.",
      "Harga saham dapat naik dan turun.",
      "Memiliki risiko kehilangan sebagian atau seluruh modal.",
      "Perlu menganalisis kondisi dan kinerja perusahaan.",
      "Cocok untuk investor yang memahami risiko pasar."
    ],
    icon: Icons.show_chart,
    color: Colors.green,
  ),

  // 6. REKSA DANA
  Materi(
    title: "Reksa Dana",
    description: "Investasi yang dikelola manajer investasi",
    explanation:
        "Reksa dana merupakan wadah untuk menghimpun dana dari masyarakat pemodal yang kemudian dikelola oleh Manajer Investasi ke dalam berbagai instrumen keuangan seperti saham, obligasi, dan pasar uang. Investor tidak perlu mengelola seluruh aset sendiri karena dana dikelola oleh tenaga profesional. Reksa dana dapat menjadi pilihan bagi pemula yang ingin berinvestasi dengan modal relatif kecil. Meskipun demikian, nilai investasi tetap dapat mengalami kenaikan maupun penurunan.",
    points: [
      "Dana dikumpulkan dari banyak investor.",
      "Dikelola oleh Manajer Investasi.",
      "Reksa Dana Pasar Uang.",
      "Reksa Dana Pendapatan Tetap.",
      "Reksa Dana Campuran.",
      "Reksa Dana Saham.",
      "Modal awal relatif terjangkau.",
      "Risiko berbeda sesuai jenis reksa dana."
    ],
    icon: Icons.pie_chart,
    color: Colors.orange,
  ),

  // 7. OBLIGASI
  Materi(
    title: "Obligasi",
    description: "Mengenal investasi melalui surat utang",
    explanation:
        "Obligasi adalah surat utang yang diterbitkan oleh pemerintah atau perusahaan kepada investor. Ketika membeli obligasi, investor pada dasarnya memberikan pinjaman kepada penerbit obligasi. Sebagai imbalannya, investor dapat menerima pembayaran kupon atau bunga sesuai ketentuan serta pengembalian pokok pada saat jatuh tempo. Obligasi dapat menjadi pilihan bagi investor yang menginginkan pendapatan berkala, tetapi tetap memiliki risiko seperti gagal bayar dan perubahan harga di pasar.",
    points: [
      "Diterbitkan oleh pemerintah atau perusahaan.",
      "Investor bertindak sebagai pemberi pinjaman.",
      "Dapat memberikan pendapatan berupa kupon.",
      "Memiliki jangka waktu dan tanggal jatuh tempo.",
      "Risiko berbeda berdasarkan penerbit obligasi.",
      "Memiliki risiko gagal bayar.",
      "Harga obligasi dapat berubah sebelum jatuh tempo."
    ],
    icon: Icons.account_balance,
    color: Colors.purple,
  ),

  // 8. EMAS
  Materi(
    title: "Emas",
    description: "Investasi melalui logam mulia",
    explanation:
        "Emas merupakan salah satu instrumen investasi yang banyak digunakan untuk menyimpan nilai kekayaan. Investasi emas dapat dilakukan dengan membeli emas batangan, koin emas, atau emas digital melalui penyedia yang sesuai ketentuan. Emas sering dipilih untuk diversifikasi dan perlindungan nilai kekayaan dalam jangka panjang. Namun, harga emas tetap dapat mengalami kenaikan dan penurunan. Investor juga perlu memperhatikan selisih harga beli dan harga jual.",
    points: [
      "Dapat berupa emas batangan dan emas digital.",
      "Dapat digunakan untuk diversifikasi investasi.",
      "Relatif mudah dipahami oleh pemula.",
      "Harga emas dapat berubah mengikuti kondisi pasar.",
      "Perhatikan selisih harga beli dan harga jual.",
      "Memiliki biaya penyimpanan untuk bentuk fisik tertentu.",
      "Cocok dipertimbangkan untuk jangka menengah dan panjang."
    ],
    icon: Icons.monetization_on,
    color: Colors.amber,
  ),

  // 9. DEPOSITO
  Materi(
    title: "Deposito",
    description: "Mengenal simpanan berjangka di bank",
    explanation:
        "Deposito adalah produk simpanan berjangka yang disediakan oleh bank. Nasabah menyimpan sejumlah uang dalam periode tertentu, misalnya 1, 3, 6, atau 12 bulan, dan memperoleh bunga sesuai ketentuan. Berbeda dengan tabungan biasa, deposito memiliki aturan pencairan berdasarkan jangka waktu yang telah disepakati. Deposito dapat menjadi pilihan bagi orang yang mengutamakan kestabilan hasil, tetapi tetap perlu memperhatikan ketentuan pencairan dan perlindungan simpanan.",
    points: [
      "Disediakan oleh lembaga perbankan.",
      "Memiliki jangka waktu tertentu.",
      "Memberikan bunga sesuai ketentuan bank.",
      "Pencairan sebelum jatuh tempo dapat dikenakan penalti.",
      "Perhatikan batas dan ketentuan penjaminan LPS.",
      "Risiko relatif rendah jika memenuhi ketentuan penjaminan."
    ],
    icon: Icons.savings,
    color: Colors.cyan,
  ),

  // 10. PROPERTI
  Materi(
    title: "Investasi Properti",
    description: "Investasi melalui tanah dan bangunan",
    explanation:
        "Investasi properti adalah kegiatan membeli aset berupa tanah, rumah, apartemen, atau bangunan dengan tujuan memperoleh keuntungan di masa depan. Keuntungan dapat berasal dari kenaikan harga properti maupun pendapatan sewa. Properti sering digunakan sebagai investasi jangka panjang karena memiliki nilai guna dan dapat menghasilkan pendapatan. Namun, investasi ini membutuhkan modal relatif besar, biaya perawatan, serta memiliki likuiditas yang lebih rendah dibandingkan beberapa instrumen keuangan.",
    points: [
      "Membeli tanah, rumah, apartemen, atau bangunan.",
      "Berpotensi memperoleh keuntungan dari kenaikan harga.",
      "Dapat menghasilkan pendapatan melalui penyewaan.",
      "Membutuhkan modal relatif besar.",
      "Memiliki biaya perawatan dan pajak.",
      "Perhatikan lokasi dan perkembangan wilayah.",
      "Pastikan legalitas kepemilikan properti."
    ],
    icon: Icons.home_work,
    color: Colors.brown,
  ),

  // 11. RETURN INVESTASI
  Materi(
    title: "Keuntungan Investasi (Return)",
    description: "Memahami hasil yang diperoleh investor",
    explanation:
        "Return adalah hasil yang diperoleh investor dari kegiatan investasi dalam periode tertentu. Return dapat berupa keuntungan dari kenaikan harga aset, pembagian keuntungan perusahaan, bunga, atau kupon. Return dapat bernilai positif ketika investasi menghasilkan keuntungan dan negatif ketika investasi mengalami kerugian. Oleh karena itu, investor perlu menilai keuntungan berdasarkan risiko dan jangka waktu investasi, bukan hanya melihat angka keuntungan yang dijanjikan.",
    points: [
      "Return merupakan hasil investasi.",
      "Capital Gain berasal dari kenaikan harga aset.",
      "Dividen berasal dari pembagian keuntungan perusahaan.",
      "Kupon merupakan pendapatan dari obligasi.",
      "Return dapat bernilai positif maupun negatif.",
      "Keuntungan tidak selalu dapat dipastikan.",
      "Bandingkan return dengan risiko investasi."
    ],
    icon: Icons.trending_up,
    color: Colors.green,
  ),

  // 12. RISIKO INVESTASI
  Materi(
    title: "Risiko Investasi",
    description: "Memahami kemungkinan kerugian",
    explanation:
        "Risiko investasi adalah kemungkinan seseorang mengalami kerugian atau memperoleh hasil yang tidak sesuai dengan harapan. Setiap instrumen memiliki tingkat risiko yang berbeda. Sebagai contoh, seseorang membeli saham senilai Rp1.000.000, kemudian nilainya turun menjadi Rp800.000. Artinya, nilai investasinya berkurang sebesar Rp200.000. Dengan memahami risiko, investor dapat memilih instrumen yang sesuai dengan kemampuan dan tujuan keuangannya.",
    points: [
      "Risiko pasar akibat perubahan harga aset.",
      "Risiko inflasi akibat penurunan daya beli uang.",
      "Risiko likuiditas ketika aset sulit dijual.",
      "Risiko gagal bayar dari penerbit instrumen utang.",
      "Risiko bisnis akibat penurunan kinerja perusahaan.",
      "Risiko perubahan suku bunga.",
      "Kenali risiko sebelum menanamkan modal."
    ],
    icon: Icons.warning_amber,
    color: Colors.red,
  ),

  // 13. JANGKA WAKTU INVESTASI
  Materi(
    title: "Jangka Waktu Investasi",
    description: "Memahami periode investasi",
    explanation:
        "Jangka waktu investasi adalah lamanya seseorang menanamkan modal sebelum menggunakan atau mencairkan hasil investasinya. Jangka waktu biasanya dibedakan menjadi pendek, menengah, dan panjang. Pemilihan jangka waktu perlu disesuaikan dengan tujuan keuangan, kebutuhan dana, dan karakteristik instrumen investasi yang digunakan.",
    points: [
      "Jangka pendek: umumnya kurang dari 1 tahun hingga sekitar 2 tahun.",
      "Jangka menengah: sekitar 3 sampai 5 tahun.",
      "Jangka panjang: lebih dari 5 tahun.",
      "Sesuaikan investasi dengan waktu penggunaan dana.",
      "Pilih instrumen sesuai tujuan keuangan.",
      "Hindari menempatkan dana darurat pada aset berisiko tinggi."
    ],
    icon: Icons.schedule,
    color: Colors.indigo,
  ),

  // 14. DIVERSIFIKASI
  Materi(
    title: "Diversifikasi Investasi",
    description: "Strategi membagi modal untuk mengelola risiko",
    explanation:
        "Diversifikasi adalah strategi membagi modal ke beberapa jenis instrumen investasi untuk mengurangi ketergantungan pada satu aset. Contohnya, seseorang memiliki investasi pada emas, saham, dan reksa dana. Jika salah satu instrumen mengalami penurunan, dampaknya terhadap keseluruhan portofolio dapat lebih terkendali. Diversifikasi bukan berarti menghilangkan seluruh risiko, tetapi membantu mengelola risiko investasi.",
    points: [
      "Membagi modal ke beberapa instrumen.",
      "Mengurangi ketergantungan pada satu aset.",
      "Menggabungkan aset dengan karakteristik berbeda.",
      "Membantu mengelola risiko portofolio.",
      "Sesuaikan pembagian modal dengan profil risiko.",
      "Diversifikasi tidak menjamin keuntungan."
    ],
    icon: Icons.pie_chart_outline,
    color: Colors.deepPurple,
  ),

  // 15. PROFIL RISIKO
  Materi(
    title: "Profil Risiko Investor",
    description: "Mengenali karakter investor",
    explanation:
        "Profil risiko adalah gambaran mengenai kemampuan dan kesediaan seseorang dalam menerima risiko kerugian dari kegiatan investasi. Profil risiko membantu investor menentukan instrumen yang sesuai dengan kondisi keuangan, tujuan, pengalaman, dan kenyamanan menghadapi perubahan nilai investasi. Secara umum, profil risiko dibagi menjadi konservatif, moderat, dan agresif.",
    points: [
      "Konservatif: cenderung mengutamakan kestabilan dan risiko rendah.",
      "Moderat: bersedia menerima risiko sedang untuk memperoleh potensi keuntungan lebih tinggi.",
      "Agresif: bersedia menerima risiko tinggi demi potensi keuntungan lebih besar.",
      "Sesuaikan investasi dengan kemampuan keuangan.",
      "Pertimbangkan pengalaman dan tujuan investasi.",
      "Profil risiko setiap orang dapat berubah seiring waktu."
    ],
    icon: Icons.person_search,
    color: Colors.blueGrey,
  ),

  // 16. ISTILAH INVESTASI
  Materi(
    title: "Istilah-Istilah Investasi",
    description: "Mengenal kosakata dalam dunia investasi",
    explanation:
        "Dalam dunia investasi terdapat berbagai istilah yang sering digunakan untuk menjelaskan proses, keuntungan, risiko, dan kondisi aset. Memahami istilah tersebut akan membantu investor membaca informasi keuangan, memahami laporan investasi, dan mengambil keputusan dengan lebih baik.",
    points: [
      "Investor: orang yang melakukan investasi.",
      "Modal: dana yang digunakan untuk berinvestasi.",
      "Return: hasil atau keuntungan investasi.",
      "Risiko: kemungkinan mengalami kerugian.",
      "Portofolio: kumpulan aset investasi yang dimiliki.",
      "Diversifikasi: membagi modal ke beberapa instrumen.",
      "Capital Gain: keuntungan dari kenaikan harga aset.",
      "Capital Loss: kerugian akibat penurunan harga aset.",
      "Dividen: pembagian keuntungan perusahaan.",
      "Likuiditas: kemudahan aset dicairkan menjadi uang tunai.",
      "Inflasi: kenaikan harga barang dan jasa secara umum.",
      "Manajer Investasi: pihak profesional yang mengelola portofolio investasi."
    ],
    icon: Icons.library_books,
    color: Colors.deepOrange,
  ),

  // 17. MANAJEMEN RISIKO
  Materi(
    title: "Manajemen Risiko",
    description: "Strategi mengelola risiko investasi",
    explanation:
        "Manajemen risiko adalah proses mengenali, mengukur, dan mengelola kemungkinan kerugian dalam kegiatan investasi. Tujuannya bukan menghilangkan seluruh risiko, melainkan mengendalikan risiko agar tidak melebihi kemampuan keuangan investor. Manajemen risiko dapat dilakukan dengan diversifikasi, menentukan batas kerugian, memahami instrumen, dan membuat perencanaan investasi.",
    points: [
      "Melakukan diversifikasi investasi.",
      "Mempelajari instrumen sebelum membeli.",
      "Menentukan tujuan dan batas risiko.",
      "Menyesuaikan investasi dengan profil risiko.",
      "Tidak menggunakan seluruh modal pada satu aset.",
      "Menghindari keputusan karena FOMO.",
      "Melakukan evaluasi portofolio secara berkala."
    ],
    icon: Icons.shield,
    color: Colors.red,
  ),

  // 18. PRINSIP INVESTASI
  Materi(
    title: "Prinsip Sebelum Berinvestasi",
    description: "Panduan penting bagi investor pemula",
    explanation:
        "Sebelum mulai berinvestasi, seseorang perlu memahami beberapa prinsip agar dapat mengambil keputusan secara bijak. Investasi sebaiknya dilakukan berdasarkan pengetahuan, kemampuan keuangan, dan perencanaan yang jelas. Jangan mudah tergiur oleh janji keuntungan besar dalam waktu singkat karena setiap investasi memiliki risiko. Selalu periksa legalitas penyedia investasi melalui OJK atau otoritas yang berwenang sesuai jenis produknya.",
    points: [
      "Pahami instrumen investasi sebelum membeli.",
      "Gunakan uang yang tidak dibutuhkan dalam waktu dekat.",
      "Siapkan dana darurat terlebih dahulu.",
      "Mulai dengan modal sesuai kemampuan.",
      "Kenali potensi keuntungan dan risiko.",
      "Tentukan tujuan dan jangka waktu investasi.",
      "Jangan mudah percaya janji keuntungan pasti.",
      "Periksa legalitas penyedia investasi.",
      "Hindari keputusan karena ikut-ikutan tren.",
      "Lakukan investasi secara konsisten dan disiplin."
    ],
    icon: Icons.verified_user,
    color: Colors.teal,
  ),

  // 19. KESIMPULAN
  Materi(
    title: "Kesimpulan Investasi",
    description: "Rangkuman pembelajaran investasi",
    explanation:
        "Investasi merupakan salah satu cara untuk mengembangkan dan meningkatkan nilai kekayaan di masa depan. Dengan berinvestasi, seseorang dapat mempersiapkan kebutuhan finansial, membangun aset, dan mencapai tujuan keuangan. Namun, investasi tidak menjamin keuntungan. Setiap investor perlu memahami modal, return, risiko, jangka waktu, diversifikasi, dan karakteristik instrumen sebelum mengambil keputusan. Pengetahuan, perencanaan, serta kedisiplinan merupakan hal penting dalam menjalankan investasi.",
    points: [
      "Investasi adalah kegiatan menanamkan modal untuk masa depan.",
      "Investasi memiliki potensi keuntungan dan risiko.",
      "Kenali karakteristik setiap instrumen investasi.",
      "Sesuaikan investasi dengan kemampuan keuangan.",
      "Tentukan tujuan dan jangka waktu investasi.",
      "Gunakan diversifikasi untuk membantu mengelola risiko.",
      "Periksa legalitas penyedia investasi.",
      "Lakukan investasi secara bijak, konsisten, dan bertanggung jawab."
    ],
    icon: Icons.lightbulb,
    color: Colors.orange,
  ),
];
