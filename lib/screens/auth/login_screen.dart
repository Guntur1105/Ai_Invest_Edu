import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isRegisterMode = false;
  bool _obscurePassword = true;

  static const Color primaryColor = Color(0xff4F46E5);
  static const Color darkNavy = Color(0xff0F172A);

  void _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_isRegisterMode) {
          await _authService.register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await _authService.login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
        }

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll("Exception: ", "")),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  // ⬇️ FUNGSI LOGIN GOOGLE ⬇️
  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkNavy : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 1. TAMPILAN DESKTOP (Lebar > 800px)
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                // Kiri: Branding Panel
                Expanded(
                  flex: 5,
                  child: Container(
                    color: darkNavy,
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_rounded, color: primaryColor, size: 60),
                        const SizedBox(height: 30),
                        const Text(
                          "AI InvestEdu",
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Platform pembelajaran investasi cerdas. Kuasai dasar-dasar saham, reksadana, dan obligasi dengan bantuan AI.",
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ),
                // Kanan: Form
                Expanded(
                  flex: 6,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: _buildForm(isDarkMode),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // 2. TAMPILAN MOBILE (Lebar < 800px)
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      // Logo di atas untuk Mobile
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.school_rounded, color: primaryColor, size: 40),
                      ),
                      const SizedBox(height: 20),
                      _buildForm(isDarkMode),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= KOMPONEN FORM =================
  Widget _buildForm(bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isRegisterMode ? "Buat Akun" : "Masuk",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : darkNavy,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isRegisterMode
                ? "Silakan isi data diri kamu untuk mendaftar."
                : "Masukkan email dan password untuk melanjutkan.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
          const SizedBox(height: 40),

          // Input Email
          _buildTextField(
            controller: _emailController,
            label: "Email Address",
            icon: Icons.email_outlined,
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.isEmpty) return "Email wajib diisi";
              if (!val.contains('@')) return "Format email tidak valid";
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Input Password
          _buildTextField(
            controller: _passwordController,
            label: "Password",
            icon: Icons.lock_outline_rounded,
            isDarkMode: isDarkMode,
            isPassword: true,
            validator: (val) {
              if (val == null || val.isEmpty) return "Password wajib diisi";
              if (val.length < 6) return "Password minimal 6 karakter";
              return null;
            },
          ),
          
          const SizedBox(height: 30),

          // Tombol Submit
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text(
                      _isRegisterMode ? "Daftar Akun" : "Masuk ke Akun",
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // ⬇️ DIVIDER "ATAU" ⬇️
          Row(
            children: [
              Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("atau", style: TextStyle(color: Colors.grey.shade500)),
              ),
              Expanded(child: Divider(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300)),
            ],
          ),

          const SizedBox(height: 20),

          // ⬇️ TOMBOL LOGIN GOOGLE ⬇️
          SizedBox(
            height: 55,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 30),
              ),
              label: Text(
                "Masuk dengan Google",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : darkNavy,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: BorderSide(color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Toggle Mode Login/Register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isRegisterMode ? "Sudah punya akun?" : "Belum punya akun?",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegisterMode = !_isRegisterMode;
                  });
                },
                style: TextButton.styleFrom(foregroundColor: primaryColor, padding: const EdgeInsets.symmetric(horizontal: 8)),
                child: Text(
                  _isRegisterMode ? "Masuk" : "Daftar",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= KOMPONEN TEXTFIELD =================
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.grey.shade300 : darkNavy),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey.shade400, size: 22),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
            filled: true,
            fillColor: isDarkMode ? const Color(0xff1E293B) : const Color(0xffF8FAFC),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDarkMode ? Colors.transparent : Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.red.shade400)),
          ),
        ),
      ],
    );
  }
}