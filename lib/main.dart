import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // ⬅️ Import Provider

import 'screens/onboarding/onboarding_screen.dart';
import 'providers/theme_provider.dart'; // ⬅️ Import ThemeProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load file .env
  await dotenv.load(fileName: ".env");

  runApp(const AIInvestEduApp());
}

class AIInvestEduApp extends StatelessWidget {
  const AIInvestEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus aplikasi dengan ChangeNotifierProvider untuk manajemen tema
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AI InvestEdu',
            
            // ⬇️ Pengaturan Tema
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            
            // Tema Terang
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.indigo, // Menggunakan Indigo sesuai tema dashboard baru
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            
            // Tema Gelap (Dark Mode)
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.indigo,
              scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep Navy
              textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
              ),
            ),
            
            home: const OnboardingScreen(),
          );
        },
      ),
    );
  }
}