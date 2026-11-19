import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: CustomScrollView(
        slivers: [
          // ================= APPBAR =================
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xff16A34A),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff15803D),
                      Color(0xff16A34A),
                      Color(0xff22C55E),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Ikon Aplikasi
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.info_rounded,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Tentang Aplikasi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Kenali AI InvestEdu lebih dekat",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ================= KONTEN =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- LOGO & NAMA APLIKASI ----------
                  _buildAppHeader(),

                  const SizedBox(height: 25),

                  // ---------- TENTANG APLIKASI ----------
                  _buildSectionTitle(
                    icon: Icons.apps_rounded,
                    title: "Tentang Aplikasi",
                    color: const Color(0xff16A34A),
                  ),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: const Text(
                      "AI InvestEdu adalah aplikasi edukasi investasi dasar berbasis "
                      "Artificial Intelligence (AI) yang dirancang khusus untuk membantu "
                      "Generasi Z memahami dunia investasi dengan cara yang mudah, "
                      "menyenangkan, dan interaktif.\n\n"
                      "Aplikasi ini menggabungkan materi pembelajaran terstruktur, "
                      "kuis interaktif dengan tiga tingkat kesulitan, dan asisten AI "
                      "yang siap menjawab pertanyaan seputar investasi kapan saja.",
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.7,
                        color: Color(0xff374151),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ---------- FITUR UTAMA ----------
                  _buildSectionTitle(
                    icon: Icons.star_rounded,
                    title: "Fitur Utama",
                    color: const Color(0xffF59E0B),
                  ),
                  const SizedBox(height: 12),

                  _buildFeatureItem(
                    icon: Icons.menu_book_rounded,
                    color: const Color(0xff16A34A),
                    title: "Materi Pembelajaran",
                    description:
                        "Belajar dasar-dasar investasi: reksadana, saham, obligasi, dan lainnya dengan penjelasan yang mudah dipahami.",
                  ),
                  _buildFeatureItem(
                    icon: Icons.quiz_rounded,
                    color: const Color(0xffF59E0B),
                    title: "Kuis Interaktif",
                    description:
                        "Uji pemahaman dengan kuis 3 tingkat kesulitan: Mudah (5 soal), Sedang (10 soal), dan Sulit (20 soal).",
                  ),
                  _buildFeatureItem(
                    icon: Icons.smart_toy_rounded,
                    color: const Color(0xff3B82F6),
                    title: "Asisten AI",
                    description:
                        "Tanya apa saja tentang investasi dan dapatkan jawaban instan dari AI yang cerdas dan ramah.",
                  ),
                  _buildFeatureItem(
                    icon: Icons.emoji_events_rounded,
                    color: const Color(0xff8B5CF6),
                    title: "Hasil & Feedback",
                    description:
                        "Dapatkan nilai, feedback, dan tips belajar yang dipersonalisasi setelah menyelesaikan kuis.",
                  ),

                  const SizedBox(height: 25),

                  // ---------- TUJUAN APLIKASI ----------
                  _buildSectionTitle(
                    icon: Icons.flag_rounded,
                    title: "Tujuan Aplikasi",
                    color: const Color(0xff3B82F6),
                  ),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Column(
                      children: [
                        _buildGoalItem(
                          "Meningkatkan literasi keuangan generasi muda Indonesia.",
                        ),
                        _buildGoalItem(
                          "Menyediakan pembelajaran investasi yang mudah diakses dan gratis.",
                        ),
                        _buildGoalItem(
                          "Memanfaatkan teknologi AI untuk pengalaman belajar yang personal.",
                        ),
                        _buildGoalItem(
                          "Mempersiapkan Generasi Z menjadi investor cerdas sejak dini.",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ---------- INFORMASI PENGEMBANG ----------
                  _buildSectionTitle(
                    icon: Icons.person_rounded,
                    title: "Pengembang",
                    color: const Color(0xff8B5CF6),
                  ),
                  const SizedBox(height: 12),
                  _buildDeveloperCard(),

                  const SizedBox(height: 25),

                  // ---------- VERSI APLIKASI ----------
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Versi 1.0.0",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff16A34A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "© 2026 AI InvestEdu. All rights reserved.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET BUILDERS =================

  // 1. Header Aplikasi
  Widget _buildAppHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff16A34A), Color(0xff22C55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff16A34A).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Nama & Tagline
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI InvestEdu",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Belajar Investasi Bersama AI",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Judul Section
  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required Color color,
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1F2937),
          ),
        ),
      ],
    );
  }

  // 3. Card dasar
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // 4. Item Fitur
  Widget _buildFeatureItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 5. Item Tujuan
  Widget _buildGoalItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffDBEAFE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xff3B82F6),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff374151),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Kartu Pengembang
  Widget _buildDeveloperCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffF3E8FF),
            Color(0xffE9D5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xff8B5CF6).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff8B5CF6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guntur Hidayat",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff581C87),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Mata Kuliah NLP",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff7E22CE),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Color(0xff8B5CF6),
                  size: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Institut Teknologi Indonesia",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff581C87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}