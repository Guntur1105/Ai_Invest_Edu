import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Import Halaman
import '../materi/materi_screen.dart';
import '../quiz/difficulty_screen.dart';
import '../chat/chat_screen.dart';
import '../about/about_screen.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../news/news_screen.dart';
import '../calculator/calculator_screen.dart';
import '../portfolio/portfolio_screen.dart';
import '../achievement/achievement_screen.dart';
import '../../services/auth_service.dart';
import '../../providers/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  User? _currentUser;
  Uint8List? _imageBytes; 

  static const Color primaryColor = Color(0xff4F46E5);
  static const Color darkNavy = Color(0xff0F172A);
  static const Color slateGray = Color(0xff64748B);
  static const Color bgLight = Color(0xffF8FAFC);

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserPhoto();

    // Animasi Entrance (Fade + Slide)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller.forward();
  }

  void _loadUserPhoto() {
    if (_currentUser?.photoURL != null && _currentUser!.photoURL!.startsWith('data:image')) {
      try {
        final base64String = _currentUser!.photoURL!.split(',').last;
        setState(() {
          _imageBytes = base64Decode(base64String);
        });
      } catch (e) {
        debugPrint("Gagal load gambar: $e");
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await AuthService().logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
      maxWidth: 300,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64String = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64String';

      try {
        await _currentUser?.updatePhotoURL(dataUrl);
        await _currentUser?.reload();
        
        setState(() {
          _currentUser = FirebaseAuth.instance.currentUser;
          _imageBytes = bytes;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto profil berhasil diubah!"), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal upload: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showProfileModal() {
    final nameController = TextEditingController(
      text: _currentUser?.displayName ?? _currentUser?.email?.split('@')[0] ?? "",
    );
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 24, right: 24, top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 24),
                  
                  GestureDetector(
                    onTap: () async {
                       await _pickAndUploadImage();
                       setModalState(() {}); 
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: primaryColor.withOpacity(0.1),
                          backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                          child: _imageBytes == null ? const Icon(Icons.person_rounded, size: 50, color: primaryColor) : null,
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle,
                              border: Border.all(color: isDark ? const Color(0xff1E293B) : Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Ketuk foto untuk mengubah", style: TextStyle(color: slateGray, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(_currentUser?.email ?? "email@contoh.com", style: TextStyle(color: slateGray, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Tampilan",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.edit_rounded, color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : () async {
                        if (nameController.text.trim().isNotEmpty) {
                          setModalState(() => isSaving = true);
                          await _currentUser?.updateDisplayName(nameController.text.trim());
                          await _currentUser?.reload();
                          if (mounted) {
                            setState(() => _currentUser = FirebaseAuth.instance.currentUser);
                            Navigator.pop(modalContext);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama berhasil diubah!"), backgroundColor: Colors.green));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isSaving 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Simpan Nama", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(),
                  
                  SwitchListTile(
                    title: Text("Mode Gelap", style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : darkNavy)),
                    value: themeProvider.isDarkMode,
                    activeColor: primaryColor,
                    onChanged: (val) {
                      themeProvider.toggleTheme(val);
                      setModalState(() {});
                    },
                    secondary: const Icon(Icons.dark_mode_rounded, color: primaryColor),
                  ),

                  ListTile(
                    leading: const Icon(Icons.settings_rounded, color: primaryColor),
                    title: Text("Pengaturan Lainnya", style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : darkNavy)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.pop(modalContext);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.red),
                    title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.pop(modalContext);
                      _handleLogout();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayName = _currentUser?.displayName ?? 
                         _currentUser?.email?.split('@')[0] ?? 
                         "Investor";
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : bgLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(displayName, isDarkMode),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menu Utama",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : darkNavy,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ================= GRID MENU DENGAN ANIMASI STAGGERED =================
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 3;
                      }

                      final spacing = 16.0;
                      final itemWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;

                      // Daftar menu
                      final menus = [
                        {'title': 'Materi', 'sub': 'Belajar dasar', 'icon': Icons.menu_book_rounded, 'color': primaryColor, 'route': const MateriScreen()},
                        {'title': 'Quiz', 'sub': 'Uji kemampuan', 'icon': Icons.quiz_rounded, 'color': const Color(0xffF59E0B), 'route': const DifficultyScreen()},
                        {'title': 'Tanya AI', 'sub': 'Konsultasi', 'icon': Icons.smart_toy_rounded, 'color': const Color(0xff0EA5E9), 'route': const ChatScreen()},
                        {'title': 'Berita', 'sub': 'Info Pasar', 'icon': Icons.newspaper_rounded, 'color': const Color(0xff10B981), 'route': const NewsScreen()},
                        {'title': 'Leaderboard', 'sub': 'Peringkat', 'icon': Icons.emoji_events_rounded, 'color': const Color(0xffF43F5E), 'route': const LeaderboardScreen()},
                        {'title': 'Tentang', 'sub': 'Info aplikasi', 'icon': Icons.info_rounded, 'color': const Color(0xff8B5CF6), 'route': const AboutScreen()},
                        {'title': 'Kalkulator', 'sub': 'Hitung Bunga', 'icon': Icons.calculate_rounded, 'color': const Color(0xff14B8A6), 'route': const CalculatorScreen()},
                        {'title': 'Simulasi', 'sub': 'Portofolio', 'icon': Icons.account_balance_wallet_rounded, 'color': const Color(0xff6366F1), 'route': const PortfolioScreen()},
                        {'title': 'Pencapaian', 'sub': 'Badge', 'icon': Icons.military_tech_rounded, 'color': const Color(0xffF97316), 'route': const AchievementScreen()},
                      ];

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: menus.asMap().entries.map((entry) {
                          int index = entry.key;
                          var menu = entry.value;
                          
                          // Animasi Staggered (Muncul satu per satu)
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 400 + (index * 100)), // Delay bertingkat
                            curve: Curves.easeOutBack,
                            builder: (context, double value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
                              );
                            },
                            child: SizedBox(
                              width: itemWidth, 
                              child: _HoverMenuCard(
                                title: menu['title'] as String,
                                subtitle: menu['sub'] as String,
                                icon: menu['icon'] as IconData,
                                color: menu['color'] as Color,
                                isDarkMode: isDarkMode,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => menu['route'] as Widget)),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 32),
                  _buildMotivationBanner(isDarkMode),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : darkNavy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: darkNavy.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: _showProfileModal,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: primaryColor.withOpacity(0.2),
                        backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                        child: _imageBytes == null ? const Icon(Icons.person_rounded, color: Colors.white, size: 28) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _currentUser?.email ?? "user@email.com",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: _showProfileModal,
                icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.5), size: 18),
              )
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Selamat Datang di AI InvestEdu",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationBanner(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1E293B) : primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tips Investasi", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : darkNavy)),
                const SizedBox(height: 4),
                Text("Investasi terbaik dimulai dari ilmu. Yuk mulai belajar sekarang!", style: GoogleFonts.poppins(fontSize: 13, color: isDarkMode ? Colors.grey.shade400 : slateGray, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// WIDGET KARTU MENU DENGAN ANIMASI HOVER
// =====================================================================
class _HoverMenuCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _HoverMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_HoverMenuCard> createState() => _HoverMenuCardState();
}

class _HoverMenuCardState extends State<_HoverMenuCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0), // Efek Membesar
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xff1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered 
                ? widget.color.withOpacity(0.5) 
                : (widget.isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200),
            width: _isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? widget.color.withOpacity(0.2) 
                  : Colors.black.withOpacity(0.02),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 28),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title, 
                    style: GoogleFonts.poppins(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: widget.isDarkMode ? Colors.white : const Color(0xff0F172A)
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle, 
                    style: GoogleFonts.poppins(
                      fontSize: 12, 
                      color: const Color(0xff64748B), 
                      fontWeight: FontWeight.w400
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}