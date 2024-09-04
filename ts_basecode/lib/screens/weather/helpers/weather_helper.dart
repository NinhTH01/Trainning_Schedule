import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';

class WeatherHelper {
  static Color getBackgroundColor(WeatherStatus? weather) {
    switch (weather) {
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

  static Icon getWeatherIcon(WeatherStatus? weatherCondition) {
    switch (weatherCondition) {
      case WeatherStatus.clear:
        return const Icon(Icons.wb_sunny, size: 20.0, color: Colors.yellow);
      case WeatherStatus.cloud:
        return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
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

  static String unixToHH(int unixTime) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

    // Extract the hour
    var hour = dateTime.hour;

    // Format hours as a 2-digit string
    var formattedHour = hour.toString().padLeft(2, '0');

    return formattedHour;
  }

  static String unixToHHmm(int unixTime) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

    // Format DateTime to HH:mm
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
