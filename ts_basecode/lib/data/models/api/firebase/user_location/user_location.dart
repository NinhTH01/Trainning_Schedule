import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    double? latitude,
    double? longitude,
    // It's temporary, so refactor to use id in the future.
    String? name,
    @JsonKey(name: 'isFinished') bool? isFinished,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);
}
