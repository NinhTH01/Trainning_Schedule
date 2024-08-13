import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';

part 'weather_state.freezed.dart';

@freezed
class WeatherState with _$WeatherState {
  const factory WeatherState({
    @Default(null) Weather? currentWeather,
    @Default(null) WeatherForecast? weatherForecast,
    @Default(null) Color? backgroundColor,
    @Default(250.0) double containerHeight,
    @Default(1.0) double descriptionOpacity,
    @Default(0.0) double minimizeOpacity,
    @Default(0.0) double scrollPadding,
  }) = _WeatherState;

  const WeatherState._();
}
