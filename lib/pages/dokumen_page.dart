import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/dokumen_service.dart';
import '../config/api_config.dart';
class DokumenPage extends StatefulWidget {
  const DokumenPage({super.key});

  @override
  State<DokumenPage> createState() => _DokumenPageState();
}

class _DokumenPageState extends State<DokumenPage> {
  final DokumenService dokumenService = DokumenService();

  bool isLoading = true;
  bool isUploading = false;

  List<dynamic> dokumenList = [];

  final List<Map<String, String>> jenisDokumen = [
    {
      'value': 'surat_izin_orang_tua',
      'label': 'Surat Izin Orang Tua',
    },
    {
      'value': 'surat_sehat',
      'label': 'Surat Sehat',
    },
    {
      'value': 'nilai_rapor',
      'label': 'Nilai Rapor',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadDokumen();
  }

  Future<void> loadDokumen() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await dokumenService.getDokumen();

      if (!mounted) return;

      setState(() {
        dokumenList = response['data'] ?? [];
      });
    } catch (e) {
      showMessage('Gagal mengambil data dokumen.');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pilihDanUpload(String jenis) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final filePath = result.files.single.path!;

    setState(() {
      isUploading = true;
    });

    try {
      final response = await dokumenService.uploadDokumen(
        jenisDokumen: jenis,
        filePath: filePath,
      );

      if (!mounted) return;

      if (response['data'] != null) {
        showMessage('Berkas berhasil diupload.');
        await loadDokumen();
      } else {
        showMessage(response['message'] ?? 'Upload gagal.');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan saat upload.');
    }

    if (!mounted) return;

    setState(() {
      isUploading = false;
    });
  }

  Future<void> hapusDokumen(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Dokumen'),
          content: const Text('Yakin ingin menghapus dokumen ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final response = await dokumenService.deleteDokumen(id);

      if (!mounted) return;

      showMessage(response['message'] ?? 'Dokumen berhasil dihapus.');
      await loadDokumen();
    } catch (e) {
      showMessage('Gagal menghapus dokumen.');
    }
  }

  Future<void> bukaFile(String fileUrl) async {
    final uri = Uri.parse(fileUrl);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      showMessage('Tidak dapat membuka file.');
    }
  }

  String labelJenis(String value) {
    final item = jenisDokumen.firstWhere(
      (element) => element['value'] == value,
      orElse: () => {
        'value': value,
        'label': value,
      },
    );

    return item['label'] ?? value;
  }

  String statusText(String status) {
    switch (status) {
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      case 'revisi':
        return 'Revisi';
      default:
        return 'Menunggu';
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'revisi':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String? getFileUrl(dynamic dokumen) {
    final filePath = dokumen['file_path'];

    if (filePath == null) return null;

    final base = ApiConfig.baseUrl.replaceAll('/api', '');
    return '$base/storage/$filePath';
  }

  dynamic cariDokumen(String jenis) {
    try {
      return dokumenList.firstWhere(
        (item) => item['jenis_dokumen'] == jenis,
      );
    } catch (e) {
      return null;
    }
  }

  Widget dokumenCard(Map<String, String> jenis) {
    final dokumen = cariDokumen(jenis['value']!);
    final sudahUpload = dokumen != null;

    final status = sudahUpload ? dokumen['status_dokumen'] ?? 'menunggu' : 'belum_upload';
    final catatan = sudahUpload ? dokumen['catatan_admin'] : null;
    final fileUrl = sudahUpload ? getFileUrl(dokumen) : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jenis['label']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            if (sudahUpload)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText(status),
                  style: TextStyle(
                    color: statusColor(status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const Text(
                'Belum upload',
                style: TextStyle(color: Colors.grey),
              ),

            if (catatan != null && catatan.toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Catatan Admin: $catatan',
                style: const TextStyle(color: Colors.black87),
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isUploading
                          ? null
                          : () {
                              pilihDanUpload(jenis['value']!);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.red.shade200,
                        disabledForegroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      icon: const Icon(
                        Icons.upload_file_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        sudahUpload ? 'Upload Ulang' : 'Upload Berkas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                if (sudahUpload) ...[
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      tooltip: 'Lihat File',
                      onPressed: fileUrl == null
                          ? null
                          : () {
                              bukaFile(fileUrl);
                            },
                      icon: const Icon(
                        Icons.visibility_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      tooltip: 'Hapus',
                      onPressed: () {
                        hapusDokumen(dokumen['id']);
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ],
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
      appBar: AppBar(
        title: const Text('Upload Berkas'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDokumen,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        'Upload dokumen persyaratan dalam format PDF, JPG, JPEG, atau PNG. Maksimal 2 MB per file.',
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (isUploading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: LinearProgressIndicator(),
                    ),

                  ...jenisDokumen.map(dokumenCard).toList(),
                ],
              ),
            ),
    );
  }
}