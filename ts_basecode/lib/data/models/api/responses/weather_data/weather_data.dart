import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';

part 'weather_data.freezed.dart';
part 'weather_data.g.dart';

@freezed
class WeatherData with _$WeatherData {
  const factory WeatherData({
    int? id,
    @JsonKey(name: 'main') WeatherStatus? mainWeatherStatus,
    String? description,
    String? icon,
  }) = _WeatherData;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
}
