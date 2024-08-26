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
    @JsonKey() Coord? coord,
    @JsonKey() List<WeatherData>? weather,
    @JsonKey() String? base,
    @JsonKey() Main? main,
    @JsonKey() int? visibility,
    @JsonKey() Wind? wind,
    @JsonKey() Rain? rain,
    @JsonKey() Clouds? clouds,
    @JsonKey() int? dt,
    @JsonKey() Sys? sys,
    @JsonKey() int? timezone,
    @JsonKey() int? id,
    @JsonKey() String? name,
    @JsonKey() int? cod,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
