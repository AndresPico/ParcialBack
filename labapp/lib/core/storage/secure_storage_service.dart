import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

class SecureStorageService {
  const SecureStorageService(this._storage);

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'auth_role';
  static const _usernameKey = 'auth_username';

  final FlutterSecureStorage _storage;

  Future<void> saveSession({
    required String token,
    required String role,
    required String username,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: token),
      _storage.write(key: _roleKey, value: role),
      _storage.write(key: _usernameKey, value: username),
    ]);
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<String?> readRole() => _storage.read(key: _roleKey);
  Future<String?> readUsername() => _storage.read(key: _usernameKey);

  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _roleKey),
      _storage.delete(key: _usernameKey),
    ]);
  }
}
