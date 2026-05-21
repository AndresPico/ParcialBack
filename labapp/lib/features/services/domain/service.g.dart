// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  entrepreneurUsername: json['entrepreneurUsername'] as String,
  category: json['category'] as String,
  price: (json['price'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'entrepreneurUsername': instance.entrepreneurUsername,
  'category': instance.category,
  'price': instance.price,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'imageUrls': instance.imageUrls,
};
