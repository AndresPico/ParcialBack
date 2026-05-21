import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String username,
    required String displayName,
    required String role,
    @Default('') String bio,
    @Default('') String avatarUrl,
    @Default(0) int servicesCount,
    @Default(0) double rating,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
