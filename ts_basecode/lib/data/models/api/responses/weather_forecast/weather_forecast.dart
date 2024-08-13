import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/city/city.dart';
import 'package:ts_basecode/data/models/api/responses/weather_entry/weather_entry.dart';

part 'weather_forecast.freezed.dart';
part 'weather_forecast.g.dart';

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    @JsonKey(name: 'sys') String? cod,
    @JsonKey(name: 'timezone') int? message,
    @JsonKey(name: 'id') int? cnt,
    @JsonKey(name: 'list') List<WeatherEntry>? list,
    @JsonKey(name: 'city') City? city,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}
