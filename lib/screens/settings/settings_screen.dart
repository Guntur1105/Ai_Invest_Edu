import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text("Tampilan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SwitchListTile(
              title: const Text("Mode Gelap"),
              subtitle: const Text("Aktifkan tema gelap pada aplikasi"),
              value: themeProvider.isDarkMode,
              activeColor: const Color(0xff4F46E5),
              onChanged: (val) {
                themeProvider.toggleTheme(val); // ⬅️ Panggil fungsi ganti tema
              },
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: const Color(0xff4F46E5),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text("Tentang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const ListTile(
              leading: Icon(Icons.info_outline, color: Color(0xff4F46E5)),
              title: Text("Versi Aplikasi"),
              trailing: Text("1.0.0", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}