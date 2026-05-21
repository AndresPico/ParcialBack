import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/profile_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: profile.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: AppSkeleton(height: 260)),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (item) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CircleAvatar(radius: 44, child: Text(item.displayName.isEmpty ? '?' : item.displayName[0])),
            const SizedBox(height: 16),
            Center(child: Text(item.displayName, style: Theme.of(context).textTheme.headlineSmall)),
            Center(child: Text('@${item.username}')),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Editar perfil'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/profile/edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
