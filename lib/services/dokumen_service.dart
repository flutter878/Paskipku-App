import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_service.dart';

class DokumenService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getDokumen() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/dokumen'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadDokumen({
    required String jenisDokumen,
    required String filePath,
  }) async {
    final token = await _authService.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/dokumen/upload'),
    );

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['jenis_dokumen'] = jenisDokumen;
    request.files.add(
      await http.MultipartFile.fromPath('file', filePath),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> deleteDokumen(int id) async {
    final token = await _authService.getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/dokumen/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
}