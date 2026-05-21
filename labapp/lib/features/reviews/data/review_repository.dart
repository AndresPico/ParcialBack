import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/domain/paginated_response.dart';
import '../domain/review.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(dioProvider));
});

final reviewsProvider = FutureProvider.family<PaginatedResponse<Review>, String>((ref, serviceId) {
  return ref.watch(reviewRepositoryProvider).list(serviceId: serviceId, page: 0);
});

class ReviewRepository {
  const ReviewRepository(this._dio);

  final Dio _dio;

  Future<PaginatedResponse<Review>> list({required String serviceId, required int page}) async {
    try {
      final response = await _dio.get(
        '/services/$serviceId/reviews',
        queryParameters: {'page': page, 'size': AppConstants.pageSize},
      );
      final data = response.data;
      final items = data is Map ? data['content'] ?? data['items'] ?? [] : data;
      final totalPages = data is Map ? data['totalPages'] as int? : null;
      return PaginatedResponse(
        items: (items as List)
            .map((item) => Review.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
        page: page,
        hasMore: totalPages != null ? page + 1 < totalPages : false,
      );
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Future<void> create({
    required String serviceId,
    required int rating,
    required String comment,
  }) async {
    try {
      await _dio.post('/services/$serviceId/reviews', data: {
        'rating': rating,
        'comment': comment,
      });
    } catch (error) {
      throw mapDioException(error);
    }
  }
}
