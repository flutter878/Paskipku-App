import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'auth_service.dart';

class HasilSeleksiService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getHasilSeleksi() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/hasil-seleksi'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10));

    return jsonDecode(response.body);
  }
}