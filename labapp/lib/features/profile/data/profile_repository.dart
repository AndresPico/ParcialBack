import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/network/api_client.dart';
import '../domain/profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(dioProvider));
});

final myProfileProvider = FutureProvider<Profile>((ref) {
  return ref.watch(profileRepositoryProvider).me();
});

final publicProfileProvider = FutureProvider.family<Profile, String>((ref, username) {
  return ref.watch(profileRepositoryProvider).publicProfile(username);
});

class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  Future<Profile> me() async {
    try {
      final response = await _dio.get('/profiles/me');
      return Profile.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Profile> publicProfile(String username) async {
    try {
      final response = await _dio.get('/profiles/$username');
      return Profile.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Profile> update(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put('/profiles/me', data: payload);
      return Profile.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }
}
