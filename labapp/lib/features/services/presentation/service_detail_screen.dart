import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import 'services_controller.dart';

class ServiceDetailScreen extends ConsumerWidget {
  const ServiceDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(serviceDetailProvider(id));
    return Scaffold(
      body: service.when(
        loading: () => const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: AppSkeleton(height: 520),
          ),
        ),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (item) {
          final currency = NumberFormat.currency(locale: 'es_CO', symbol: r'$');
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                actions: [
                  IconButton(
                    tooltip: 'Editar',
                    onPressed: () => context.push('/services/$id/edit'),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView(
                    children: item.imageUrls.isEmpty
                        ? [
                            Container(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: const Icon(Icons.image_outlined, size: 60),
                            ),
                          ]
                        : [
                            for (final image in item.imageUrls)
                              CachedNetworkImage(imageUrl: image, fit: BoxFit.cover),
                          ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList.list(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                        ),
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
                        Text('${item.rating.toStringAsFixed(1)} (${item.reviewCount})'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(currency.format(item.price), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 18),
                    Text(item.description),
                    const SizedBox(height: 18),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.storefront)),
                      title: Text(item.entrepreneurUsername),
                      subtitle: Text(item.category),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/entrepreneurs/${item.entrepreneurUsername}'),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      child: const Center(child: Icon(Icons.map_outlined, size: 48)),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => context.push('/services/$id/reviews/new'),
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('Crear reseña'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/services/$id/reviews'),
                      icon: const Icon(Icons.reviews_outlined),
                      label: const Text('Ver reseñas'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
