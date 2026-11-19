import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // ⬅️ Arahkan ke Login

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Warna Tema (Sesuai Login & Dashboard)
  static const Color primaryColor = Color(0xff4F46E5); // Indigo
  static const Color darkNavy = Color(0xff0F172A); // Dark Navy

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Belajar Investasi Dasar",
      "description": "Pahami konsep saham, reksadana, dan obligasi dengan penjelasan yang mudah dicerna.",
      "icon": Icons.menu_book_rounded,
    },
    {
      "title": "Tanya AI InvestEdu",
      "description": "Punya pertanyaan seputar investasi? Tanyakan langsung ke asisten AI kami kapan saja.",
      "icon": Icons.smart_toy_rounded,
    },
    {
      "title": "Uji Kemampuanmu",
      "description": "Kerjakan kuis interaktif dan pantau skormu di papan peringkat (Leaderboard).",
      "icon": Icons.emoji_events_rounded,
    },
  ];

  void _completeOnboarding() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER (SKIP) =================
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 40.0,
                vertical: 10.0,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade500,
                  ),
                  child: const Text(
                    "Lewati",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            // ================= KONTEN PAGEVIEW =================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return _buildPageContent(data, isMobile, size, isDarkMode);
                },
              ),
            ),

            // ================= FOOTER (DOTS & BUTTON) =================
            Padding(
              padding: EdgeInsets.all(isMobile ? 24.0 : 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indikator Titik Minimalis
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index, size, isDarkMode),
                    ),
                  ),
                  // Tombol Next / Mulai (Solid Indigo, Tanpa Gradient)
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 32,
                        vertical: isMobile ? 14 : 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Sudut tegas
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _onboardingData.length - 1 ? "Mulai" : "Lanjut",
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (_currentPage != _onboardingData.length - 1) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET KONTEN PER SLIDE =================
  Widget _buildPageContent(Map<String, dynamic> data, bool isMobile, Size size, bool isDarkMode) {
    final iconSize = isMobile ? size.width * 0.3 : 120.0;
    final titleSize = isMobile ? 24.0 : 32.0;
    final descSize = isMobile ? 14.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 30.0 : 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon Minimalis (Kotak melengkung, bukan lingkaran gradient)
          Container(
            padding: EdgeInsets.all(isMobile ? 30 : 45),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              data['icon'],
              size: iconSize,
              color: primaryColor,
            ),
          ),
          
          SizedBox(height: isMobile ? 40 : 60),
          
          // Judul Tegas
          Text(
            data['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : darkNavy,
              letterSpacing: -0.5,
            ),
          ),
          
          SizedBox(height: isMobile ? 15 : 20),
          
          // Deskripsi Abu-abu Lembut
          Text(
            data['description'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: descSize,
              color: Colors.grey.shade500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET TITIK INDIKATOR =================
  Widget _buildDot(int index, Size size, bool isDarkMode) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: _currentPage == index ? (size.width < 600 ? 24 : 32) : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? primaryColor
            : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}