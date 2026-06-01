import '../config/api_config.dart';
import 'auth_service.dart';

class KartuPesertaService {
  final AuthService _authService = AuthService();

  Future<String> getPreviewUrl() async {
    final token = await _authService.getToken();

    return '${ApiConfig.baseUrl}/kartu-peserta/preview?token=$token';
  }

  Future<String> getDownloadUrl() async {
    final token = await _authService.getToken();

    return '${ApiConfig.baseUrl}/kartu-peserta/download?token=$token';
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }
}