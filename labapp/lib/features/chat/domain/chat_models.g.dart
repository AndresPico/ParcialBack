// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatPreview _$ChatPreviewFromJson(Map<String, dynamic> json) => _ChatPreview(
  id: json['id'] as String,
  participantName: json['participantName'] as String,
  lastMessage: json['lastMessage'] as String? ?? '',
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ChatPreviewToJson(_ChatPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantName': instance.participantName,
      'lastMessage': instance.lastMessage,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  senderUsername: json['senderUsername'] as String,
  text: json['text'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderUsername': instance.senderUsername,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
    };
