import 'package:flutter/material.dart';

class PengumumanPage extends StatelessWidget {
  const PengumumanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text('Halaman Pengumuman'),
      ),
    );
  }
}