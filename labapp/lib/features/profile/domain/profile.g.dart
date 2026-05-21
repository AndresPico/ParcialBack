// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  username: json['username'] as String,
  displayName: json['displayName'] as String,
  role: json['role'] as String,
  bio: json['bio'] as String? ?? '',
  avatarUrl: json['avatarUrl'] as String? ?? '',
  servicesCount: (json['servicesCount'] as num?)?.toInt() ?? 0,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'username': instance.username,
  'displayName': instance.displayName,
  'role': instance.role,
  'bio': instance.bio,
  'avatarUrl': instance.avatarUrl,
  'servicesCount': instance.servicesCount,
  'rating': instance.rating,
};
