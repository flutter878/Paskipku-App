import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_service.dart';

class BiodataService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getBiodata() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/biodata'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateBiodata({
    required String namaLengkap,
    required String asalSekolah,
    required String tempatLahir,
    required String tanggalLahir,
    required String tinggiBadan,
    required String beratBadan,
    required String golonganDarah,
    required String riwayatPenyakit,
    required String motivasiEsai,
  }) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/biodata'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nama_lengkap': namaLengkap,
        'asal_sekolah': asalSekolah,
        'tempat_lahir': tempatLahir,
        'tanggal_lahir': tanggalLahir,
        'tinggi_badan': int.tryParse(tinggiBadan) ?? 0,
        'berat_badan': int.tryParse(beratBadan) ?? 0,
        'golongan_darah': golonganDarah,
        'riwayat_penyakit': riwayatPenyakit,
        'motivasi_esai': motivasiEsai,
      }),
    );

    return jsonDecode(response.body);
  }
}