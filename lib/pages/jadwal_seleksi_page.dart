import 'package:flutter/material.dart';

import '../services/jadwal_seleksi_service.dart';

class JadwalSeleksiPage extends StatefulWidget {
  const JadwalSeleksiPage({super.key});

  @override
  State<JadwalSeleksiPage> createState() => _JadwalSeleksiPageState();
}

class _JadwalSeleksiPageState extends State<JadwalSeleksiPage> {
  final JadwalSeleksiService jadwalService = JadwalSeleksiService();

  bool isLoading = true;
  List<dynamic> jadwalList = [];

  @override
  void initState() {
    super.initState();
    loadJadwal();
  }

  Future<void> loadJadwal() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await jadwalService.getJadwalSeleksi();

      if (!mounted) return;

      setState(() {
        jadwalList = response['data'] ?? [];
      });
    } catch (e) {
      showMessage('Gagal mengambil jadwal seleksi.');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  String formatTanggal(String? value) {
    if (value == null) return '-';

    try {
      final date = DateTime.parse(value);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      return '$day-$month-$year';
    } catch (e) {
      return value;
    }
  }

  String formatJam(String? value) {
    if (value == null || value.isEmpty) return '-';

    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }

  Widget jadwalCard(dynamic item, int index) {
    final namaKegiatan = item['nama_kegiatan'] ?? '-';
    final tanggal = formatTanggal(item['tanggal']);
    final jamMulai = formatJam(item['jam_mulai']);
    final jamSelesai = formatJam(item['jam_selesai']);
    final lokasi = item['lokasi'] ?? '-';
    final keterangan = item['keterangan'] ?? '-';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            namaKegiatan,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    infoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Tanggal',
                      value: tanggal,
                    ),

                    infoRow(
                      icon: Icons.access_time_rounded,
                      label: 'Waktu',
                      value: '$jamMulai - $jamSelesai',
                    ),

                    infoRow(
                      icon: Icons.location_on_rounded,
                      label: 'Lokasi',
                      value: lokasi,
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        keterangan,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.red,
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              ': $value',
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
      child: const Row(
        children: [
          Icon(
            Icons.event_available_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Jadwal tahapan seleksi Paskibraka dapat dilihat pada halaman ini.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.4,
                fontSize: 15,
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Jadwal Seleksi'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : RefreshIndicator(
              onRefresh: loadJadwal,
              color: Colors.red,
              child: jadwalList.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        headerSection(),
                        const SizedBox(height: 120),
                        Icon(
                          Icons.event_busy_rounded,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 14),
                        Center(
                          child: Text(
                            'Belum ada jadwal seleksi.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                      children: [
                        headerSection(),
                        const SizedBox(height: 24),
                        const Text(
                          'Daftar Jadwal',
                          style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pastikan kamu mengikuti jadwal sesuai informasi panitia.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...jadwalList.asMap().entries.map(
                              (entry) => jadwalCard(entry.value, entry.key),
                            ),
                      ],
                    ),
            ),
    );
  }
}