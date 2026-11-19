import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ⬅️ Import Google Fonts
import 'quiz_screen.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  // Palet Warna (Sesuai Dashboard & Login)
  static const Color primaryColor = Color(0xff4F46E5);
  static const Color darkNavy = Color(0xff0F172A);
  static const Color slateGray = Color(0xff64748B);
  static const Color bgLight = Color(0xffF8FAFC);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : bgLight,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xff1E293B) : darkNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pilih Tingkat Kesulitan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              const SizedBox(height: 10),
              Text(
                "Uji Pemahamanmu! 🎯",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : darkNavy,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pilih tingkat kesulitan yang sesuai dengan kemampuanmu.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey.shade400 : slateGray,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              // ================= KARTU MUDAH =================
              _buildDifficultyCard(
                context,
                title: "Mudah",
                subtitle: "5 Soal • Cocok untuk pemula",
                icon: Icons.sentiment_satisfied_alt_rounded,
                color: const Color(0xff10B981), // Emerald (Hijau modern)
                questionCount: 5,
                level: "easy",
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),

              // ================= KARTU SEDANG =================
              _buildDifficultyCard(
                context,
                title: "Sedang",
                subtitle: "10 Soal • Untuk yang sudah paham",
                icon: Icons.sentiment_neutral_rounded,
                color: const Color(0xffF59E0B), // Amber (Kuning modern)
                questionCount: 10,
                level: "medium",
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 16),

              // ================= KARTU SULIT =================
              _buildDifficultyCard(
                context,
                title: "Sulit",
                subtitle: "20 Soal • Tantang dirimu!",
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xffEF4444), // Red (Merah modern)
                questionCount: 20,
                level: "hard",
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 30),

              // ================= TIPS =================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xff1E293B) : primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Disarankan mulai dari level Mudah dulu, lalu naik ke level berikutnya.",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDarkMode ? Colors.grey.shade400 : slateGray,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGET KARTU =================
  Widget _buildDifficultyCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int questionCount,
    required String level,
    required bool isDarkMode,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(level: level),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xff1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ikon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 32),
            ),

            const SizedBox(width: 16),

            // Teks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : darkNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey.shade400 : slateGray,
                    ),
                  ),
                ],
              ),
            ),

            // Panah
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}