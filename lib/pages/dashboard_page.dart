import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import 'biodata_page.dart';
import 'dokumen_page.dart';
import 'pengumuman_page.dart';
import 'kartu_peserta_page.dart';
import 'jadwal_seleksi_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String name = '';
  String nik = '';

  bool isLoading = true;

  String statusVerifikasi = 'belum_lengkap';
  int totalDokumen = 0;
  int dokumenDiterima = 0;
  int dokumenMenunggu = 0;
  int dokumenRevisi = 0;

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      name = prefs.getString('name') ?? 'Peserta';
      nik = prefs.getString('nik') ?? '-';

      final response = await authService.profile();
      final user = response['user'];

      if (user != null) {
        final biodata = user['biodata'];
        final dokumen = user['dokumen'] ?? [];

        if (biodata != null) {
          statusVerifikasi = biodata['status_verifikasi'] ?? 'belum_lengkap';
        }

        totalDokumen = dokumen.length;
        dokumenDiterima = dokumen
            .where((item) => item['status_dokumen'] == 'diterima')
            .length;
        dokumenMenunggu = dokumen
            .where((item) => item['status_dokumen'] == 'menunggu')
            .length;
        dokumenRevisi =
            dokumen.where((item) => item['status_dokumen'] == 'revisi').length;
      }
    } catch (e) {
      showMessage('Gagal memuat dashboard.');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  String statusText(String status) {
    switch (status) {
      case 'lulus_verifikasi':
        return 'Lulus Verifikasi';
      case 'menunggu_verifikasi':
        return 'Menunggu Verifikasi';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Belum Lengkap';
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'lulus_verifikasi':
        return const Color(0xFF16A34A);
      case 'menunggu_verifikasi':
        return const Color(0xFFF59E0B);
      case 'ditolak':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Widget headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE53935),
            Color(0xFFB71C1C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang 👋',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'NIK: $nik',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget statusCard() {
    final color = statusColor(statusVerifikasi);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Status Pendaftaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  statusText(statusVerifikasi),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 7, left: 7, bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: Colors.red,
            size: 26,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF1F2937),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
        trailing: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> goToPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: loadDashboard,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : RefreshIndicator(
              onRefresh: loadDashboard,
              color: Colors.red,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerSection(),

                    statusCard(),

                    const SizedBox(height: 24),

                    sectionTitle(
                      'Ringkasan Dokumen',
                      'Pantau status dokumen pendaftaran kamu.',
                    ),

                    Row(
                      children: [
                        summaryCard(
                          title: 'Dokumen',
                          value: totalDokumen.toString(),
                          icon: Icons.folder_rounded,
                          color: const Color(0xFF2563EB),
                        ),
                        summaryCard(
                          title: 'Diterima',
                          value: dokumenDiterima.toString(),
                          icon: Icons.check_circle_rounded,
                          color: const Color(0xFF16A34A),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        summaryCard(
                          title: 'Menunggu',
                          value: dokumenMenunggu.toString(),
                          icon: Icons.hourglass_bottom_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                        summaryCard(
                          title: 'Revisi',
                          value: dokumenRevisi.toString(),
                          icon: Icons.edit_note_rounded,
                          color: const Color(0xFFDC2626),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    sectionTitle(
                      'Menu Cepat',
                      'Akses fitur utama aplikasi peserta.',
                    ),

                    menuItem(
                      icon: Icons.assignment_outlined,
                      title: 'Biodata Pendaftaran',
                      subtitle: 'Isi dan perbarui data diri peserta.',
                      onTap: () {
                        goToPage(const BiodataPage());
                      },
                    ),

                    menuItem(
                      icon: Icons.upload_file_outlined,
                      title: 'Upload Berkas',
                      subtitle: 'Upload surat izin, surat sehat, dan nilai rapor.',
                      onTap: () {
                        goToPage(const DokumenPage());
                      },
                    ),

                    menuItem(
                      icon: Icons.campaign_outlined,
                      title: 'Pengumuman',
                      subtitle: 'Lihat informasi terbaru dari panitia.',
                      onTap: () {
                        goToPage(const PengumumanPage());
                      },
                    ),

                    menuItem(
                      icon: Icons.event_available_outlined,
                      title: 'Jadwal Seleksi',
                      subtitle: 'Lihat jadwal tahapan seleksi Paskibraka.',
                      onTap: () {
                        goToPage(const JadwalSeleksiPage());
                      },
                    ),

                    menuItem(
                      icon: Icons.badge_outlined,
                      title: 'Kartu Peserta',
                      subtitle: 'Buka kartu peserta setelah lulus verifikasi.',
                      onTap: () {
                        goToPage(const KartuPesertaPage());
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}