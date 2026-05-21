import 'package:freezed_annotation/freezed_annotation.dart';

part 'service.freezed.dart';
part 'service.g.dart';

@freezed
abstract class Service with _$Service {
  const factory Service({
    required String id,
    required String title,
    required String description,
    required String entrepreneurUsername,
    required String category,
    required double price,
    required double rating,
    required int reviewCount,
    required double latitude,
    required double longitude,
    @Default([]) List<String> imageUrls,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
}
