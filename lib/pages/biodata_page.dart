import 'package:flutter/material.dart';

import '../services/biodata_service.dart';

class BiodataPage extends StatefulWidget {
  const BiodataPage({super.key});

  @override
  State<BiodataPage> createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final BiodataService biodataService = BiodataService();

  final namaController = TextEditingController();
  final sekolahController = TextEditingController();
  final tempatLahirController = TextEditingController();
  final tanggalLahirController = TextEditingController();
  final tinggiController = TextEditingController();
  final beratController = TextEditingController();
  final golonganDarahController = TextEditingController();
  final riwayatPenyakitController = TextEditingController();
  final motivasiController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String statusVerifikasi = 'belum_lengkap';
  String catatanAdmin = '-';

  @override
  void initState() {
    super.initState();
    loadBiodata();
  }

  Future<void> loadBiodata() async {
    try {
      final response = await biodataService.getBiodata();
      final data = response['data'];

      if (data != null) {
        namaController.text = data['nama_lengkap'] ?? '';
        sekolahController.text = data['asal_sekolah'] ?? '';
        tempatLahirController.text = data['tempat_lahir'] ?? '';
        tanggalLahirController.text = data['tanggal_lahir'] ?? '';
        tinggiController.text = data['tinggi_badan']?.toString() ?? '';
        beratController.text = data['berat_badan']?.toString() ?? '';
        golonganDarahController.text = data['golongan_darah'] ?? '';
        riwayatPenyakitController.text = data['riwayat_penyakit'] ?? '';
        motivasiController.text = data['motivasi_esai'] ?? '';

        statusVerifikasi = data['status_verifikasi'] ?? 'belum_lengkap';
        catatanAdmin = data['catatan_admin'] ?? '-';
      }
    } catch (e) {
      showMessage('Gagal mengambil biodata.');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveBiodata() async {
    if (namaController.text.isEmpty ||
        sekolahController.text.isEmpty ||
        tempatLahirController.text.isEmpty ||
        tanggalLahirController.text.isEmpty ||
        tinggiController.text.isEmpty ||
        beratController.text.isEmpty) {
      showMessage('Field wajib tidak boleh kosong.');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final response = await biodataService.updateBiodata(
        namaLengkap: namaController.text,
        asalSekolah: sekolahController.text,
        tempatLahir: tempatLahirController.text,
        tanggalLahir: tanggalLahirController.text,
        tinggiBadan: tinggiController.text,
        beratBadan: beratController.text,
        golonganDarah: golonganDarahController.text,
        riwayatPenyakit: riwayatPenyakitController.text,
        motivasiEsai: motivasiController.text,
      );

      if (!mounted) return;

      if (response['data'] != null) {
        setState(() {
          statusVerifikasi = response['data']['status_verifikasi'] ?? 'menunggu_verifikasi';
          catatanAdmin = response['data']['catatan_admin'] ?? '-';
        });

        showMessage('Biodata berhasil disimpan.');
      } else {
        showMessage(response['message'] ?? 'Gagal menyimpan biodata.');
      }
    } catch (e) {
      showMessage('Terjadi kesalahan koneksi.');
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });
  }

  Future<void> pilihTanggal() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final year = pickedDate.year.toString().padLeft(4, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final day = pickedDate.day.toString().padLeft(2, '0');

      tanggalLahirController.text = '$year-$month-$day';
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case 'lulus_verifikasi':
        return Colors.green;
      case 'menunggu_verifikasi':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
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

  Widget inputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
  void dispose() {
    namaController.dispose();
    sekolahController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    golonganDarahController.dispose();
    riwayatPenyakitController.dispose();
    motivasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Pendaftaran'),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: statusColor(statusVerifikasi),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Status: ${statusText(statusVerifikasi)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (catatanAdmin != '-' && catatanAdmin.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Text('Catatan Admin: $catatanAdmin'),
                      ),
                    ),

                  const SizedBox(height: 16),

                  inputField(
                    label: 'Nama Lengkap',
                    controller: namaController,
                  ),
                  inputField(
                    label: 'Asal Sekolah',
                    controller: sekolahController,
                  ),
                  inputField(
                    label: 'Tempat Lahir',
                    controller: tempatLahirController,
                  ),
                  inputField(
                    label: 'Tanggal Lahir',
                    controller: tanggalLahirController,
                    readOnly: true,
                    onTap: pilihTanggal,
                  ),
                  inputField(
                    label: 'Tinggi Badan',
                    controller: tinggiController,
                    keyboardType: TextInputType.number,
                  ),
                  inputField(
                    label: 'Berat Badan',
                    controller: beratController,
                    keyboardType: TextInputType.number,
                  ),
                  inputField(
                    label: 'Golongan Darah',
                    controller: golonganDarahController,
                  ),
                  inputField(
                    label: 'Riwayat Penyakit',
                    controller: riwayatPenyakitController,
                    maxLines: 3,
                  ),
                  inputField(
                    label: 'Motivasi Esai',
                    controller: motivasiController,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : saveBiodata,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Simpan Biodata'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}