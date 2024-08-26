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
    @JsonKey() List<WeatherData>? weather,
    @JsonKey() Main? main,
    @JsonKey() int? visibility,
    @JsonKey() Wind? wind,
    @JsonKey() Rain? rain,
    @JsonKey() Clouds? clouds,
    @JsonKey() int? dt,
    @JsonKey() Sys? sys,
    @JsonKey() dynamic pop,
    @JsonKey() String? dtTxt,
  }) = _WeatherEntry;

  factory WeatherEntry.fromJson(Map<String, dynamic> json) =>
      _$WeatherEntryFromJson(json);
}
