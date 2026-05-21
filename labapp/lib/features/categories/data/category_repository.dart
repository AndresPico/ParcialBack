import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/network/api_client.dart';
import '../domain/category.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(dioProvider));
});

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

class CategoryRepository {
  const CategoryRepository(this._dio);

  final Dio _dio;

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      final data = response.data;
      final list = data is Map ? data['content'] ?? data['items'] ?? [] : data;
      return (list as List)
          .map((item) => Category.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (error) {
      throw mapDioException(error);
    }
  }
}
