import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class AuthService {
  Future<Map<String, dynamic>> register({
    required String nik,
    required String name,
    required String asalSekolah,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nik': nik,
        'name': name,
        'asal_sekolah': asalSekolah,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login({
  required String login,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/login'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'login': login,
      'password': password,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data['token'] != null) {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', data['token']);
    await prefs.setString('role', data['user']['role']);
    await prefs.setString('name', data['user']['name']);
    await prefs.setString('email', data['user']['email']);
    await prefs.setString('nik', data['user']['nik']);
  }

  return data;
}

  Future<Map<String, dynamic>> profile() async {
    final token = await getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/profile'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}