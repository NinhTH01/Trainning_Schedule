import 'package:freezed_annotation/freezed_annotation.dart';

part 'main.freezed.dart';
part 'main.g.dart';

@freezed
class Main with _$Main {
  const factory Main({
    num? temp,
    num? feelsLike,
    num? tempMin,
    num? tempMax,
    int? pressure,
    int? humidity,
    int? seaLevel,
    int? grndLevel,
    int? visibility,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}
