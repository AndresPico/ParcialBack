import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
abstract class ChatPreview with _$ChatPreview {
  const factory ChatPreview({
    required String id,
    required String participantName,
    @Default('') String lastMessage,
    DateTime? updatedAt,
  }) = _ChatPreview;

  factory ChatPreview.fromJson(Map<String, dynamic> json) => _$ChatPreviewFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderUsername,
    required String text,
    required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
