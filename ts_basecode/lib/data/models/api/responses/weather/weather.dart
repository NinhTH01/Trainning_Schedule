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

enum WeatherStatus {
  @JsonValue('Clouds')
  cloud,
  @JsonValue('Clear')
  clear,
  @JsonValue('Drizzle')
  drizzle,
  @JsonValue('Rain')
  rain,
  @JsonValue('Thunderstorm')
  thunderstorm,
}

@freezed
class Weather with _$Weather {
  const factory Weather({
    @JsonKey(name: 'coord') Coord? coordinate,
    @JsonKey(name: 'weather') List<WeatherData>? weatherDataList,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Rain? rain,
    Clouds? clouds,
    @JsonKey(name: 'dt') int? dateTime,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
