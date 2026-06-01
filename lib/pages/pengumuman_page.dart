import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/api_config.dart';
import '../services/pengumuman_service.dart';

class PengumumanPage extends StatefulWidget {
  const PengumumanPage({super.key});

  @override
  State<PengumumanPage> createState() => _PengumumanPageState();
}

class _PengumumanPageState extends State<PengumumanPage> {
  final PengumumanService pengumumanService = PengumumanService();

  bool isLoading = true;
  List<dynamic> pengumumanList = [];

  @override
  void initState() {
    super.initState();
    loadPengumuman();
  }

  Future<void> loadPengumuman() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await pengumumanService.getPengumuman();

      if (!mounted) return;

      setState(() {
        pengumumanList = response['data'] ?? [];
      });
    } catch (e) {
      showMessage('Gagal mengambil data pengumuman.');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  String getLampiranUrl(dynamic item) {
    final lampiran = item['lampiran'];

    if (lampiran == null || lampiran.toString().isEmpty) {
      return '';
    }

    final base = ApiConfig.baseUrl.replaceAll('/api', '');
    return '$base/storage/$lampiran';
  }

  Future<void> bukaLampiran(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showMessage('Tidak dapat membuka lampiran.');
    }
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

  void showDetailPengumuman(dynamic item) {
    final lampiranUrl = getLampiranUrl(item);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Text(
                    item['judul'] ?? '-',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        formatTanggal(item['created_at']),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    item['isi_konten'] ?? '-',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  if (lampiranUrl.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          bukaLampiran(lampiranUrl);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Buka Lampiran'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget pengumumanCard(dynamic item) {
    final lampiranUrl = getLampiranUrl(item);
    final adaLampiran = lampiranUrl.isNotEmpty;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          showDetailPengumuman(item);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['judul'] ?? '-',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                item['isi_konten'] ?? '-',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    formatTanggal(item['created_at']),
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const Spacer(),

                  if (adaLampiran)
                    const Icon(Icons.attach_file, size: 18, color: Colors.red),
                ],
              ),
            ],
          ),
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
        title: const Text('Pengumuman'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadPengumuman,
              child: pengumumanList.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(20),
                      children: const [
                        SizedBox(height: 160),
                        Icon(Icons.campaign, size: 72, color: Colors.grey),
                        SizedBox(height: 14),
                        Center(
                          child: Text(
                            'Belum ada pengumuman terbaru.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(18),
                      children: [
                        const Card(
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.red),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Informasi terbaru dari panitia seleksi Paskibraka.',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        ...pengumumanList.map(pengumumanCard).toList(),
                      ],
                    ),
            ),
    );
  }
}