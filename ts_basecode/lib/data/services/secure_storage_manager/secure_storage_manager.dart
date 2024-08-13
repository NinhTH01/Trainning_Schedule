import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _weather = 'weather';
  static const _weather_forecast = 'weather_forecast';

  Future<dynamic> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  Future<void> _write({
    required String key,
    required String? value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> writeWeather(Weather weather) async {
    try {
      await _write(
        key: _weather,
        value: json.encode(weather),
      );
    } catch (_) {}
  }

  Future<Weather?> readWeather() async {
    final result = await _read(key: _weather);
    if (result == null) {
      return null;
    } else {
      try {
        return result;
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> writeWeatherForecast(WeatherForecast weatherForecast) async {
    try {
      await _write(
        key: _weather_forecast,
        value: json.encode(weatherForecast),
      );
    } catch (_) {}
  }

  Future<WeatherForecast?> readWeatherForecast() async {
    final result = await _read(key: _weather_forecast);
    if (result == null) {
      return null;
    } else {
      try {
        return result;
      } catch (_) {
        return null;
      }
    }
  }
}
