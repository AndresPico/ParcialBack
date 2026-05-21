import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/user_session.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
});

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<UserSession> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      '/authenticate/login',
      data: {'username': username, 'password': password},
    );
    return _sessionFromResponse(response.data, fallbackUsername: username);
  }

  Future<UserSession> register({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _dio.post(
      '/authenticate/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      },
    );
    return _sessionFromResponse(response.data, fallbackUsername: username);
  }

  UserSession _sessionFromResponse(
    dynamic data, {
    required String fallbackUsername,
  }) {
    final json = Map<String, dynamic>.from(data as Map);
    return UserSession(
      token: (json['token'] ?? json['jwt'] ?? json['accessToken']).toString(),
      role: (json['role'] ?? json['userRole'] ?? 'CLIENT').toString(),
      username: (json['username'] ?? fallbackUsername).toString(),
    );
  }
}
