import 'package:flutter/material.dart';

import '../services/hasil_seleksi_service.dart';

class HasilSeleksiPage extends StatefulWidget {
  const HasilSeleksiPage({super.key});

  @override
  State<HasilSeleksiPage> createState() => _HasilSeleksiPageState();
}

class _HasilSeleksiPageState extends State<HasilSeleksiPage> {
  final HasilSeleksiService hasilService = HasilSeleksiService();

  bool isLoading = true;
  List<dynamic> hasilList = [];

  @override
  void initState() {
    super.initState();
    loadHasilSeleksi();
  }

  Future<void> loadHasilSeleksi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await hasilService.getHasilSeleksi();

      if (!mounted) return;

      setState(() {
        hasilList = response['data'] ?? [];
      });
    } catch (e) {
      showMessage('Gagal mengambil hasil seleksi.');
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

  String statusText(String status) {
    switch (status) {
      case 'lulus':
        return 'Lulus';
      case 'tidak_lulus':
        return 'Tidak Lulus';
      case 'cadangan':
        return 'Cadangan';
      default:
        return 'Menunggu';
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'lulus':
        return const Color(0xFF16A34A);
      case 'tidak_lulus':
        return const Color(0xFFDC2626);
      case 'cadangan':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'lulus':
        return Icons.check_circle_rounded;
      case 'tidak_lulus':
        return Icons.cancel_rounded;
      case 'cadangan':
        return Icons.hourglass_bottom_rounded;
      default:
        return Icons.pending_rounded;
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
      child: const Row(
        children: [
          Icon(
            Icons.emoji_events_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Pantau hasil setiap tahapan seleksi Paskibraka kamu di halaman ini.',
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

  Widget hasilCard(dynamic item, int index) {
    final tahap = item['tahap'] ?? '-';
    final nilai = item['nilai'];
    final status = item['status'] ?? 'menunggu';
    final catatan = item['catatan'] ?? '-';
    final tanggal = formatTanggal(item['created_at']);

    final color = statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  statusIcon(status),
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tahap,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Tanggal input: $tanggal',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: infoBox(
                  title: 'Status',
                  value: statusText(status),
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: infoBox(
                  title: 'Nilai',
                  value: nilai == null ? '-' : nilai.toString(),
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7FB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Catatan: $catatan',
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.4,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
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

  Widget emptyState() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        headerSection(),
        const SizedBox(height: 120),
        Icon(
          Icons.emoji_events_outlined,
          size: 80,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            'Belum ada hasil seleksi.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            'Hasil akan muncul setelah admin menginput data seleksi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget contentState() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
      children: [
        headerSection(),
        const SizedBox(height: 24),
        const Text(
          'Hasil Seleksi',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Berikut hasil seleksi berdasarkan tahapan yang sudah diproses admin.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 14),
        ...hasilList.asMap().entries.map(
              (entry) => hasilCard(entry.value, entry.key),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Hasil Seleksi'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : RefreshIndicator(
              onRefresh: loadHasilSeleksi,
              color: Colors.red,
              child: hasilList.isEmpty ? emptyState() : contentState(),
            ),
    );
  }
}