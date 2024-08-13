import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/clouds/clouds.dart';
import 'package:ts_basecode/data/models/api/responses/coord/coord.dart';
import 'package:ts_basecode/data/models/api/responses/main/main.dart';
import 'package:ts_basecode/data/models/api/responses/rain/rain.dart';
import 'package:ts_basecode/data/models/api/responses/sys/sys.dart';
import 'package:ts_basecode/data/models/api/responses/weather_data/weather_data.dart';
import 'package:ts_basecode/data/models/api/responses/wind/wind.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

@freezed
class Weather with _$Weather {
  const factory Weather({
    @JsonKey(name: 'coord') Coord? coord,
    @JsonKey(name: 'weather') List<WeatherData>? weather,
    @JsonKey(name: 'base') String? base,
    @JsonKey(name: 'main') Main? main,
    @JsonKey(name: 'visibility') int? visibility,
    @JsonKey(name: 'wind') Wind? wind,
    @JsonKey(name: 'rain') Rain? rain,
    @JsonKey(name: 'clouds') Clouds? clouds,
    @JsonKey(name: 'dt') int? dt,
    @JsonKey(name: 'sys') Sys? sys,
    @JsonKey(name: 'timezone') int? timezone,
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'cod') int? cod,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
