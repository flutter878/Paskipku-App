import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import 'biodata_page.dart';
import 'dokumen_page.dart';
import 'pengumuman_page.dart';
import 'kartu_peserta_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String name = '';
  String nik = '';

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? 'Peserta';
      nik = prefs.getString('nik') ?? '-';
    });
  }

  Future<void> handleLogout() async {
    await authService.logout();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: Colors.red),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Dashboard Peserta'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: handleLogout,
            icon: const Icon(Icons.logout),
          )
        ],
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.red, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'NIK: $nik',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Menu Peserta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            menuItem(
              icon: Icons.assignment,
              title: 'Biodata Pendaftaran',
              subtitle: 'Isi dan perbarui data diri peserta',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BiodataPage()),
                );
              },
            ),

            menuItem(
              icon: Icons.upload_file,
              title: 'Upload Berkas',
              subtitle: 'Upload surat izin, surat sehat, dan nilai rapor',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DokumenPage()),
                );
              },
            ),

            menuItem(
              icon: Icons.campaign,
              title: 'Pengumuman',
              subtitle: 'Lihat informasi terbaru dari panitia',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PengumumanPage()),
                );
              },
            ),

            menuItem(
              icon: Icons.badge,
              title: 'Kartu Peserta',
              subtitle: 'Download kartu peserta jika sudah lulus verifikasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KartuPesertaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}