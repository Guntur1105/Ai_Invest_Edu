import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // ⬅️ Import Google Fonts
import '../../models/materi.dart';
import '../quiz/difficulty_screen.dart';

class DetailMateriScreen extends StatefulWidget {
  final Materi materi;

  const DetailMateriScreen({
    super.key,
    required this.materi,
  });

  @override
  State<DetailMateriScreen> createState() => _DetailMateriScreenState();
}

class _DetailMateriScreenState extends State<DetailMateriScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Palet Warna (Sesuai Dashboard)
  static const Color primaryColor = Color(0xff4F46E5);
  static const Color darkNavy = Color(0xff0F172A);
  static const Color slateGray = Color(0xff64748B);
  static const Color bgLight = Color(0xffF8FAFC);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final materi = widget.materi;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : bgLight,
      body: CustomScrollView(
        slivers: [
          // ================= APPBAR + HEADER =================
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: isDarkMode ? const Color(0xff1E293B) : darkNavy,
            foregroundColor: Colors.white,
            elevation: 0,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode 
                      ? [const Color(0xff1E293B), darkNavy]
                      : [darkNavy, const Color(0xff1E293B)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon buku dengan efek glow
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: primaryColor,
                            size: 50,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Judul Materi
                        Text(
                          materi.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Badge Kategori
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.school_rounded,
                                color: primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  materi.description,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
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
              ),
            ),
          ),

          // ================= KONTEN =================
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- PENJELASAN ----------
                      _buildSectionTitle(
                        icon: Icons.description_rounded,
                        title: "Penjelasan",
                        color: primaryColor,
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 15),
                      _buildExplanationCard(materi.explanation, isDarkMode),

                      const SizedBox(height: 30),

                      // ---------- POIN PENTING ----------
                      _buildSectionTitle(
                        icon: Icons.list_alt_rounded,
                        title: "Poin Penting",
                        color: const Color(0xffF59E0B), // Amber
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 15),

                      ...materi.points.asMap().entries.map(
                        (entry) => _buildPointItem(
                          index: entry.key + 1,
                          text: entry.value,
                          isDarkMode: isDarkMode,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ---------- TIPS ----------
                      _buildTipsCard(isDarkMode),

                      const SizedBox(height: 30),

                      // ---------- TOMBOL LANJUT KE QUIZ ----------
                      _buildActionButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET BUILDERS =================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : darkNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationCard(String explanation, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: primaryColor, width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        explanation,
        style: GoogleFonts.poppins(
          fontSize: 15,
          height: 1.8,
          color: isDarkMode ? Colors.grey.shade300 : slateGray,
        ),
      ),
    );
  }

  Widget _buildPointItem({required int index, required String text, required bool isDarkMode}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nomor urut
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "$index",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Teks Poin
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : darkNavy,
                height: 1.4,
              ),
            ),
          ),

          // Ikon Centang
          const Icon(
            Icons.check_circle_rounded,
            color: primaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tips Investasi",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Mulailah investasi sesuai kemampuan dan lakukan secara konsisten setiap bulan.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.5,
                    color: isDarkMode ? Colors.grey.shade400 : slateGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== 🔥 TOMBOL LANJUT KE QUIZ ====================
  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DifficultyScreen(),
            ),
          );
        },
        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        label: Text(
          "Selesai & Lanjut ke Quiz",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 5,
          shadowColor: primaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}