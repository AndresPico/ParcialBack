import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_error_state.dart';
import '../../../shared/widgets/app_skeleton.dart';
import '../data/chat_repository.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inbox = ref.watch(inboxProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: inbox.when(
        loading: () => const Padding(padding: EdgeInsets.all(16), child: AppSkeleton(height: 220)),
        error: (error, _) => AppErrorState(message: error.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyState(
              title: 'Sin conversaciones',
              message: 'Tus chats aparecerán aquí.',
              icon: Icons.chat_bubble_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final chat = items[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                  title: Text(chat.participantName),
                  subtitle: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/chats/${chat.id}'),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}
