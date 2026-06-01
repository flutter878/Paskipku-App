import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_config.dart';
import '../services/auth_service.dart';

class KartuPesertaPage extends StatefulWidget {
  const KartuPesertaPage({super.key});

  @override
  State<KartuPesertaPage> createState() => _KartuPesertaPageState();
}

class _KartuPesertaPageState extends State<KartuPesertaPage> {
  final AuthService authService = AuthService();

  bool isLoading = false;

  Future<void> bukaKartuPeserta() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = await authService.getToken();

      if (token == null) {
        showMessage('Token tidak ditemukan. Silakan login ulang.');
        return;
      }

      final url = '${ApiConfig.baseUrl}/kartu-peserta/preview-token?token=$token';
      final uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        showMessage('Tidak dapat membuka kartu peserta.');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan saat membuka kartu peserta.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = Colors.red,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      height: 1.4,
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

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Kartu Peserta'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.red,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.badge, color: Colors.white, size: 42),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Kartu Peserta Seleksi Paskibraka',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            infoCard(
              icon: Icons.verified,
              title: 'Syarat Download',
              subtitle:
                  'Kartu peserta hanya tersedia jika biodata peserta sudah lulus verifikasi oleh admin.',
              color: Colors.green,
            ),

            infoCard(
              icon: Icons.info,
              title: 'Catatan',
              subtitle:
                  'Jika kartu belum tersedia, silakan tunggu proses verifikasi atau cek catatan admin pada menu biodata.',
              color: Colors.orange,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : bukaKartuPeserta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                icon: const Icon(Icons.picture_as_pdf),
                label: isLoading
                    ? const Text('Membuka...')
                    : const Text(
                        'Buka Kartu Peserta PDF',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}