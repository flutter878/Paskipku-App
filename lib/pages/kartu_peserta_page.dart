import 'package:flutter/material.dart';

class KartuPesertaPage extends StatelessWidget {
  const KartuPesertaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Peserta'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Text('Halaman Kartu Peserta'),
      ),
    );
  }
}