import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/city/city.dart';
import 'package:ts_basecode/data/models/api/responses/weather_entry/weather_entry.dart';

part 'weather_forecast.freezed.dart';
part 'weather_forecast.g.dart';

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    @JsonKey() String? cod,
    @JsonKey() int? message,
    @JsonKey() int? cnt,
    @JsonKey() List<WeatherEntry>? list,
    @JsonKey() City? city,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}
