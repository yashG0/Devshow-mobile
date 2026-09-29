import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/storage/token_storage.dart';

class AuthRepository {
  final ApiClient api;
  final TokenStorage storage;

  AuthRepository(this.api, this.storage);

  Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await api.dio.post(
      '/api/auth/token',
      data: FormData.fromMap({
        'username': username,
        'password': password,
      }),
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final token = response.data['access_token'] as String;
    await storage.saveToken(token);

    return me();
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await api.dio.post(
      '/api/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
      },
    );

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> me() async {
    final response = await api.dio.get('/api/auth/me');

    return Map<String, dynamic>.from(response.data);
  }

  Future<void> logout() {
    return storage.deleteToken();
  }
}
