import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';

class WeatherCondition {
  static const String cloud = 'Cloud';
  static const String clear = 'Clear';
  static const String drizzle = 'Drizzle';
  static const String rain = 'Rain';
  static const String thunderstorm = 'Thunderstorm';
}

class WeatherHelper {
  static Color getBackgroundColor(String? weather) {
    switch (weather) {
      case WeatherCondition.cloud:
        return ColorName.cloudColor;
      case WeatherCondition.thunderstorm:
        return ColorName.thunderColor;
      case WeatherCondition.rain:
        return ColorName.rainColor;
      case WeatherCondition.drizzle:
        return ColorName.drizzleColor;
      case WeatherCondition.clear:
        return ColorName.clearColor;
      default:
        return ColorName.clearColor;
    }
  }

  static Icon getWeatherIcon(String? weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return const Icon(Icons.wb_sunny, size: 20.0, color: Colors.yellow);
      case WeatherCondition.cloud:
        return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
      case WeatherCondition.thunderstorm:
        return const Icon(Icons.flash_on, size: 20.0, color: Colors.orange);
      case WeatherCondition.rain:
        return const Icon(Icons.beach_access, size: 20.0, color: Colors.white);
      case WeatherCondition.drizzle:
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
