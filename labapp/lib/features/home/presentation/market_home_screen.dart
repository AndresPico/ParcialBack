import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import '../../categories/data/category_repository.dart';
import '../../services/presentation/services_controller.dart';
import '../../services/presentation/widgets/service_card.dart';

class MarketHomeScreen extends ConsumerStatefulWidget {
  const MarketHomeScreen({super.key});

  @override
  ConsumerState<MarketHomeScreen> createState() => _MarketHomeScreenState();
}

class _MarketHomeScreenState extends ConsumerState<MarketHomeScreen> {
  final _scrollController = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 360) {
        ref.read(servicesControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesControllerProvider);
    final categories = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('LabApp'),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/services/new'),
        icon: const Icon(Icons.add),
        label: const Text('Servicio'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(servicesControllerProvider.future),
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscar servicios',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: ref.read(servicesControllerProvider.notifier).search,
            ),
            const SizedBox(height: 14),
            categories.when(
              data: (items) => SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ActionChip(
                        avatar: const Icon(Icons.grid_view_rounded),
                        label: const Text('Todos'),
                        onPressed: () => ref.read(servicesControllerProvider.notifier).filterByCategory(null),
                      );
                    }
                    final category = items[index - 1];
                    return ActionChip(
                      avatar: const Icon(Icons.sell_outlined),
                      label: Text(category.name),
                      onPressed: () => ref.read(servicesControllerProvider.notifier).filterByCategory(category.id),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: items.length + 1,
                ),
              ),
              loading: () => const AppSkeleton(height: 44, radius: 22),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),
            services.when(
              loading: () => const Column(
                children: [
                  AppSkeleton(height: 260),
                  SizedBox(height: 14),
                  AppSkeleton(height: 260),
                ],
              ),
              error: (error, _) => AppErrorState(
                message: error.toString(),
                onRetry: () => ref.invalidate(servicesControllerProvider),
              ),
              data: (state) {
                if (state.items.isEmpty) {
                  return const AppEmptyState(
                    title: 'Sin servicios',
                    message: 'Prueba con otra búsqueda o categoría.',
                    icon: Icons.search_off,
                  );
                }
                return Column(
                  children: [
                    for (final service in state.items) ...[
                      ServiceCard(service: service),
                      const SizedBox(height: 14),
                    ],
                    if (state.isLoadingMore) const AppSkeleton(height: 120),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
