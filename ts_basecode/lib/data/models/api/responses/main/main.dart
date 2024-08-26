import 'package:freezed_annotation/freezed_annotation.dart';

part 'main.freezed.dart';
part 'main.g.dart';

@freezed
class Main with _$Main {
  const factory Main({
    @JsonKey() num? temp,
    @JsonKey() num? feelsLike,
    @JsonKey() num? tempMin,
    @JsonKey() num? tempMax,
    @JsonKey() int? pressure,
    @JsonKey() int? humidity,
    @JsonKey() int? seaLevel,
    @JsonKey() int? grndLevel,
    @JsonKey() int? visibility,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}
