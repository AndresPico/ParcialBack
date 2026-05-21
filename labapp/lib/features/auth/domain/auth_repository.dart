import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../data/auth_remote_data_source.dart';
import 'user_session.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageProvider),
  );
});

class AuthRepository {
  const AuthRepository(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  Future<UserSession?> restoreSession() async {
    final token = await _storage.readToken();
    final role = await _storage.readRole();
    final username = await _storage.readUsername();
    if (token == null || role == null || username == null) return null;
    return UserSession(token: token, role: role, username: username);
  }

  Future<UserSession> login(String username, String password) async {
    try {
      final session = await _remote.login(username: username, password: password);
      await _storage.saveSession(
        token: session.token,
        role: session.role,
        username: session.username,
      );
      return session;
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<UserSession> register({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final session = await _remote.register(
        username: username,
        email: email,
        password: password,
        role: role,
      );
      await _storage.saveSession(
        token: session.token,
        role: session.role,
        username: session.username,
      );
      return session;
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<void> logout() => _storage.clearSession();
}
