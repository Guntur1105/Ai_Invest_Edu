import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Hitung nilai (0-100)
  int get nilai => ((widget.score / widget.total) * 100).round();

  // Tentukan feedback berdasarkan nilai
  Map<String, dynamic> get feedback {
    if (nilai >= 80) {
      return {
        'title': 'Luar Biasa! 🎉',
        'message': 'Kamu sangat memahami materi ini dengan baik!',
        'color': const Color(0xff16A34A),
        'icon': Icons.emoji_events_rounded,
      };
    } else if (nilai >= 60) {
      return {
        'title': 'Bagus! 👍',
        'message': 'Sedikit lagi kamu bisa lebih baik. Terus semangat!',
        'color': const Color(0xffF59E0B),
        'icon': Icons.thumb_up_rounded,
      };
    } else {
      return {
        'title': 'Perlu Belajar Lagi 📚',
        'message': 'Jangan menyerah! Coba baca ulang materinya ya.',
        'color': const Color(0xffEF4444),
        'icon': Icons.menu_book_rounded,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final fb = feedback;
    final color = fb['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Hasil Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ================= TROFI / IKON =================
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          color.withOpacity(0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      fb['icon'] as IconData,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= JUDUL FEEDBACK =================
                Text(
                  fb['title'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    fb['message'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xff4B5563),
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // ================= KARTU NILAI =================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Label Nilai
                      Text(
                        "NILAI AKHIR",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Angka Nilai Besar
                      Text(
                        "$nilai",
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: color,
                          height: 1,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Divider
                      Container(
                        height: 1,
                        color: Colors.grey.shade200,
                      ),

                      const SizedBox(height: 15),

                      // Baris Statistik: Benar & Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            icon: Icons.check_circle_rounded,
                            iconColor: const Color(0xff16A34A),
                            label: "Benar",
                            value: "${widget.score}",
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey.shade200,
                          ),
                          _buildStatItem(
                            icon: Icons.cancel_rounded,
                            iconColor: const Color(0xffEF4444),
                            label: "Salah",
                            value: "${widget.total - widget.score}",
                          ),
                          Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey.shade200,
                          ),
                          _buildStatItem(
                            icon: Icons.list_alt_rounded,
                            iconColor: const Color(0xff3B82F6),
                            label: "Total",
                            value: "${widget.total}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= TIPS CARD =================
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xffFEF3C7),
                        const Color(0xffFDE68A).withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xffF59E0B).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF59E0B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          nilai >= 60
                              ? "Pertahankan prestasimu dan pelajari materi berikutnya!"
                              : "Coba baca ulang materi dan kerjakan quiz sekali lagi ya!",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff78350F),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ================= TOMBOL AKSI =================
                Row(
                  children: [
                    // Tombol Ulangi
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: color,
                        ),
                        label: Text(
                          "Ulangi",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: color, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Tombol Selesai / Kembali ke Dashboard
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Kembali ke dashboard (hapus semua route sampai root)
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(
                          Icons.home_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Selesai",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                          shadowColor: color.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= WIDGET STAT ITEM =================
  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2937),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}