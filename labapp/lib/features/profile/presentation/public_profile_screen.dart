import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import '../data/profile_repository.dart';

class PublicProfileScreen extends ConsumerWidget {
  const PublicProfileScreen({required this.username, super.key});

  final String username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(publicProfileProvider(username));
    return Scaffold(
      appBar: AppBar(title: const Text('Emprendedor')),
      body: profile.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: AppSkeleton(height: 260)),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (item) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(radius: 48, child: Text(item.displayName.isEmpty ? '?' : item.displayName[0])),
            const SizedBox(height: 16),
            Center(child: Text(item.displayName, style: Theme.of(context).textTheme.headlineSmall)),
            Center(child: Text(item.bio)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _Metric(label: 'Servicios', value: '${item.servicesCount}')),
                const SizedBox(width: 12),
                Expanded(child: _Metric(label: 'Rating', value: item.rating.toStringAsFixed(1))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label),
          ],
        ),
      ),
    );
  }
}
