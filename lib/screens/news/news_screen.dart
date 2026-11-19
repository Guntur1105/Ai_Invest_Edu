import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Berita Investasi")),
      body: const Center(child: Text("Halaman Berita Investasi (Segera Hadir)")),
    );
  }
}