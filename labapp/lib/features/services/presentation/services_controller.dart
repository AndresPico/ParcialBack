import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/service_repository.dart';
import '../domain/service.dart';

final servicesControllerProvider =
    AsyncNotifierProvider<ServicesController, ServicesState>(ServicesController.new);

final serviceDetailProvider = FutureProvider.family<Service, String>((ref, id) {
  return ref.watch(serviceRepositoryProvider).getService(id);
});

class ServicesState {
  const ServicesState({
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
    this.query = '',
    this.categoryId,
    this.isLoadingMore = false,
  });

  final List<Service> items;
  final int page;
  final bool hasMore;
  final String query;
  final String? categoryId;
  final bool isLoadingMore;

  ServicesState copyWith({
    List<Service>? items,
    int? page,
    bool? hasMore,
    String? query,
    String? categoryId,
    bool clearCategory = false,
    bool? isLoadingMore,
  }) {
    return ServicesState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ServicesController extends AsyncNotifier<ServicesState> {
  @override
  Future<ServicesState> build() async {
    final response = await ref.watch(serviceRepositoryProvider).listServices(page: 0);
    return ServicesState(items: response.items, hasMore: response.hasMore);
  }

  Future<void> search(String value) async {
    final current = state.value ?? const ServicesState();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(serviceRepositoryProvider).listServices(
            page: 0,
            query: value,
            categoryId: current.categoryId,
          );
      return current.copyWith(
        items: response.items,
        page: 0,
        hasMore: response.hasMore,
        query: value,
      );
    });
  }

  Future<void> filterByCategory(String? categoryId) async {
    final current = state.value ?? const ServicesState();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(serviceRepositoryProvider).listServices(
            page: 0,
            query: current.query,
            categoryId: categoryId,
          );
      return current.copyWith(
        items: response.items,
        page: 0,
        hasMore: response.hasMore,
        categoryId: categoryId,
        clearCategory: categoryId == null,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.isLoadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    final nextPage = current.page + 1;
    final response = await ref.read(serviceRepositoryProvider).listServices(
          page: nextPage,
          query: current.query,
          categoryId: current.categoryId,
        );
    state = AsyncData(
      current.copyWith(
        items: [...current.items, ...response.items],
        page: nextPage,
        hasMore: response.hasMore,
        isLoadingMore: false,
      ),
    );
  }
}
