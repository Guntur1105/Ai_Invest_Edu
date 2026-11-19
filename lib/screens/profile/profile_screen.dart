import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi text field dengan nama saat ini
    _nameController.text = _user?.displayName ?? _user?.email?.split('@')[0] ?? "";
  }

  // Fungsi Simpan Nama Baru
  Future<void> _updateName() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await _user?.updateDisplayName(_nameController.text.trim());
      await _user?.reload(); // Refresh data user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nama berhasil diperbarui!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Kembali ke dashboard dengan status true (berhasil update)
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update nama: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: AppBar(
        title: const Text("Profil Saya", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Foto Profil (Simulasi)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xff4F46E5).withOpacity(0.1),
                    child: const Icon(Icons.person_rounded, size: 70, color: Color(0xff4F46E5)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xff4F46E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Info Email (Tidak bisa diubah)
            TextFormField(
              initialValue: _user?.email ?? "email@contoh.com",
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Input Nama Tampilan (Bisa diubah)
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nama Tampilan",
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4F46E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Perubahan", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Pengaturan
            ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              tileColor: Colors.white,
              leading: const Icon(Icons.settings_rounded, color: Color(0xff4F46E5)),
              title: const Text("Pengaturan Aplikasi", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}