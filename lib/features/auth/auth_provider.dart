import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/storage/token_storage.dart';
import 'auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(tokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  );
});

class AuthState {
  final Map<String, dynamic>? user;

  const AuthState({this.user});

  bool get isAuthenticated => user != null;
}

final authProvider =
    AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository;

  @override
  Future<AuthState> build() async {
    _repository = ref.read(authRepositoryProvider);

    final token = await ref.read(tokenStorageProvider).readToken();

    if (token == null) {
      return const AuthState();
    }

    try {
      final user = await _repository.me();
      return AuthState(user: user);
    } catch (_) {
      await ref.read(tokenStorageProvider).deleteToken();
      return const AuthState();
    }
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final user = await _repository.login(username, password);
      return AuthState(user: user);
    });
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _repository.register(
        username: username,
        email: email,
        password: password,
      );

      final user = await _repository.login(username, password);

      return AuthState(user: user);
    });
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(AuthState());
  }
}