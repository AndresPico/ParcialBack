import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/network/api_client.dart';
import '../domain/chat_models.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final inboxProvider = FutureProvider<List<ChatPreview>>((ref) {
  return ref.watch(chatRepositoryProvider).inbox();
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((ref, chatId) {
  return ref.watch(chatRepositoryProvider).pollMessages(chatId);
});

class ChatRepository {
  const ChatRepository(this._dio);

  final Dio _dio;

  Future<List<ChatPreview>> inbox() async {
    try {
      final response = await _dio.get('/chats');
      return (response.data as List)
          .map((item) => ChatPreview.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (error) {
      throw mapDioException(error);
    }
  }

  Stream<List<ChatMessage>> pollMessages(String chatId) async* {
    while (true) {
      try {
        final response = await _dio.get('/chats/$chatId/messages');
        yield (response.data as List)
            .map((item) => ChatMessage.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      } catch (error) {
        throw mapDioException(error);
      }
      await Future<void>.delayed(AppConstants.chatPollingInterval);
    }
  }

  Future<void> sendMessage(String chatId, String text) async {
    try {
      await _dio.post('/chats/$chatId/messages', data: {'text': text});
    } catch (error) {
      throw mapDioException(error);
    }
  }

  WebSocketChannel connectSocket(String chatId) {
    return WebSocketChannel.connect(Uri.parse('${AppEnvironment.wsUrl}/chats/$chatId'));
  }
}
