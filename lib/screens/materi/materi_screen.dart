import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/materi.dart';
import '../../data/materi_data.dart';
import 'detail_materi_screen.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getMateriStyle(String title) {
    final t = title.toLowerCase();
    if (t.contains('pengertian')) {
      return {'icon': Icons.school_rounded, 'color': primaryColor};
    } else if (t.contains('saham')) {
      return {'icon': Icons.trending_up_rounded, 'color': const Color(0xff10B981)};
    } else if (t.contains('reksa') || t.contains('reksadana')) {
      return {'icon': Icons.pie_chart_rounded, 'color': const Color(0xffF59E0B)};
    } else if (t.contains('obligasi')) {
      return {'icon': Icons.account_balance_rounded, 'color': const Color(0xff8B5CF6)};
    } else if (t.contains('emas')) {
      return {'icon': Icons.monetization_on_rounded, 'color': const Color(0xffEAB308)};
    } else if (t.contains('risiko')) {
      return {'icon': Icons.shield_rounded, 'color': const Color(0xffEF4444)};
    }
    return {'icon': Icons.menu_book_rounded, 'color': primaryColor};
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : bgLight,
      body: CustomScrollView(
        slivers: [
          // ================= APPBAR (Teks di Tengah) =================
          SliverAppBar(
            pinned: true,
            expandedHeight: 100, 
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
                child: const SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center, // ⬅️ Diubah ke center
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, // ⬅️ Diubah ke center
                          children: [
                            Icon(Icons.menu_book_rounded, color: primaryColor, size: 24),
                            SizedBox(width: 12),
                            Text(
                              "Materi Investasi",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- BANNER (Model Card) ----------
                      _buildBanner(isDarkMode),

                      const SizedBox(height: 30),

                      // ---------- JUDUL DAFTAR ----------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Daftar Materi",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : darkNavy,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${materiList.length} Materi",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ---------- LIST MATERI ----------
                      ...materiList.asMap().entries.map((entry) {
                        final index = entry.key;
                        final materi = entry.value;
                        final style = _getMateriStyle(materi.title);

                        return _buildMateriCard(
                          context: context,
                          index: index + 1,
                          materi: materi,
                          icon: style['icon'] as IconData,
                          color: style['color'] as Color,
                          isDarkMode: isDarkMode,
                        );
                      }),

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

  // ================= BANNER =================
  Widget _buildBanner(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_stories_rounded, color: primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Belajar Investasi",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : darkNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pelajari investasi dari dasar hingga memahami risiko.",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey.shade400 : slateGray,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= KARTU MATERI =================
  Widget _buildMateriCard({
    required BuildContext context,
    required int index,
    required Materi materi,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailMateriScreen(materi: materi),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xff1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
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
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: isDarkMode ? const Color(0xff1E293B) : Colors.white, width: 2),
                        ),
                        child: Text(
                          "$index",
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        materi.title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : darkNavy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        materi.description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: slateGray,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}