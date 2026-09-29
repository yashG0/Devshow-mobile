import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_provider.dart';

final publicRepositoryProvider = Provider<PublicRepository>((ref) {
  return PublicRepository(ref.watch(apiClientProvider));
});

class PublicRepository {
  final ApiClient api;

  PublicRepository(this.api);

  Future<Map<String, dynamic>> getDeveloper(String username) async {
    final response = await api.dio.get('/api/public/dev/$username');

    return Map<String, dynamic>.from(response.data);
  }

  Future<Map<String, dynamic>> getProject(String username, String slug) async {
    final response = await api.dio.get('/api/public/dev/$username/$slug');

    return Map<String, dynamic>.from(response.data);
  }
}
