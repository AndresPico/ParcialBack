import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import '../data/review_repository.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({required this.serviceId, super.key});

  final String serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(reviewsProvider(serviceId));
    return Scaffold(
      appBar: AppBar(title: const Text('Reseñas')),
      body: reviews.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: AppSkeleton(height: 240)),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (page) {
          if (page.items.isEmpty) {
            return const AppEmptyState(
              title: 'Sin reseñas',
              message: 'Sé la primera persona en opinar.',
              icon: Icons.reviews_outlined,
            );
          }
          final average = page.items.map((e) => e.rating).reduce((a, b) => a + b) / page.items.length;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Text(average.toStringAsFixed(1), style: Theme.of(context).textTheme.displaySmall),
                      const SizedBox(width: 14),
                      Expanded(
                        child: LinearProgressIndicator(value: average / 5, minHeight: 10, borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              for (final review in page.items)
                Card(
                  child: ListTile(
                    title: Text(review.authorUsername),
                    subtitle: Text(review.comment),
                    trailing: Text(DateFormat('dd MMM').format(review.createdAt)),
                    leading: CircleAvatar(child: Text('${review.rating}')),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
