import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';

extension GetConfig on WeatherStatus {
  Color getBackgroundColor() {
    switch (this) {
      case WeatherStatus.cloud:
        return ColorName.cloudColor;
      case WeatherStatus.thunderstorm:
        return ColorName.cloudColor;
      case WeatherStatus.rain:
        return ColorName.rainColor;
      case WeatherStatus.drizzle:
        return ColorName.rainColor;
      case WeatherStatus.clear:
        return ColorName.clearColor;
      default:
        return ColorName.clearColor;
    }
  }

  Icon getWeatherIcon() {
    switch (this) {
      case WeatherStatus.clear:
        return const Icon(Icons.wb_sunny, size: 20.0, color: Colors.yellow);
      case WeatherStatus.cloud:
        return const Icon(Icons.cloud, size: 20.0, color: Colors.white);
      case WeatherStatus.thunderstorm:
        return const Icon(Icons.flash_on, size: 20.0, color: Colors.orange);
      case WeatherStatus.rain:
        return const Icon(Icons.beach_access, size: 20.0, color: Colors.white);
      case WeatherStatus.drizzle:
        return const Icon(Icons.grain, size: 20.0, color: Colors.lightBlue);
      default:
        return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
    }
  }

  String getBackgroundImagePath() {
    switch (this) {
      case WeatherStatus.clear:
        return Assets.images.normal.path;
      case WeatherStatus.cloud:
        return Assets.images.cloud.path;
      case WeatherStatus.drizzle:
        return Assets.images.drizzle.path;
      case WeatherStatus.rain:
        return Assets.images.rain.path;
      case WeatherStatus.thunderstorm:
        return Assets.images.lightning.path;
      default:
        return Assets.images.clear.path;
    }
  }
}
