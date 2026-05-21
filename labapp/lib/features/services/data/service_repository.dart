import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/domain/paginated_response.dart';
import '../domain/service.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.watch(dioProvider));
});

class ServiceRepository {
  const ServiceRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponse<Service>> listServices({
    required int page,
    String? query,
    String? categoryId,
  }) async {
    try {
      final response = await _dio.get(
        '/services',
        queryParameters: {
          'page': page,
          'size': AppConstants.pageSize,
          if (query != null && query.isNotEmpty) 'search': query,
          if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
        },
      );
      final data = response.data;
      final items = data is Map ? data['content'] ?? data['items'] ?? [] : data;
      final totalPages = data is Map ? data['totalPages'] as int? : null;
      final last = data is Map ? data['last'] as bool? : null;
      return PaginatedResponse(
        items: (items as List)
            .map((item) => Service.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        page: page,
        hasMore: totalPages != null ? page + 1 < totalPages : !(last ?? false),
      );
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Service> getService(String id) async {
    try {
      final response = await _dio.get('/services/$id');
      return Service.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Service> createService(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/services', data: payload);
      return Service.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<Service> updateService(String id, Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put('/services/$id', data: payload);
      return Service.fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<String> uploadImage(String serviceId, XFile file) async {
    try {
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.name),
      });
      final response = await _dio.post('/services/$serviceId/images', data: form);
      final data = Map<String, dynamic>.from(response.data as Map);
      return (data['url'] ?? data['imageUrl']).toString();
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<void> deleteImage(String serviceId, String imageId) async {
    try {
      await _dio.delete('/services/$serviceId/images/$imageId');
    } catch (error) {
      throw mapDioException(error);
    }
  }
}
