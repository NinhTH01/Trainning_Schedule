import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/clouds/clouds.dart';
import 'package:ts_basecode/data/models/api/responses/main/main.dart';
import 'package:ts_basecode/data/models/api/responses/rain/rain.dart';
import 'package:ts_basecode/data/models/api/responses/sys/sys.dart';
import 'package:ts_basecode/data/models/api/responses/weather_data/weather_data.dart';
import 'package:ts_basecode/data/models/api/responses/wind/wind.dart';

part 'weather_entry.freezed.dart';
part 'weather_entry.g.dart';

@freezed
class WeatherEntry with _$WeatherEntry {
  const factory WeatherEntry({
    @JsonKey(name: 'weather') List<WeatherData>? weather,
    @JsonKey(name: 'main') Main? main,
    @JsonKey(name: 'visibility') int? visibility,
    @JsonKey(name: 'wind') Wind? wind,
    @JsonKey(name: 'rain') Rain? rain,
    @JsonKey(name: 'clouds') Clouds? clouds,
    @JsonKey(name: 'dt') int? dt,
    @JsonKey(name: 'sys') Sys? sys,
    @JsonKey(name: 'pop') dynamic? pop,
    @JsonKey(name: 'dt_txt') String? dtTxt,
  }) = _WeatherEntry;

  factory WeatherEntry.fromJson(Map<String, dynamic> json) =>
      _$WeatherEntryFromJson(json);
}
