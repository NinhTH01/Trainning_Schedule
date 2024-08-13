import 'package:freezed_annotation/freezed_annotation.dart';

part 'wind.freezed.dart';
part 'wind.g.dart';

@freezed
class Wind with _$Wind {
  const factory Wind({
    @JsonKey(name: 'speed') num? speed,
    @JsonKey(name: 'deg') int? deg,
    @JsonKey(name: 'gust') num? gust,
  }) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}
