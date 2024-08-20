import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/data/services/api/weather/api_weather_client.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather({
    required Function(Weather weather) saveWeatherForSession,
    required Function(Weather weather) writeWeatherForSecureStorage,
    required double lat,
    required double lon,
  });

  Future<WeatherForecast> getWeatherForecast({
    required Function(WeatherForecast weatherForecast)
        saveWeatherForecastForSession,
    required Function(WeatherForecast weatherForecast)
        writeWeatherForecastForSecureStorage,
    required double lat,
    required double lon,
  });
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(
    this._apiWeatherClient,
  );

  final ApiWeatherClient _apiWeatherClient;
  static const apiKey = String.fromEnvironment('WEATHER_API_KEY');

  @override
  Future<Weather> getWeather({
    required Function(Weather weather) saveWeatherForSession,
    required Function(Weather weather) writeWeatherForSecureStorage,
    required double lat,
    required double lon,
  }) async {
    final weatherResponse = await _apiWeatherClient.getWeather(
      lat: '$lat',
      lon: '$lon',
      apiKey: apiKey,
      units: 'metric',
    );
    saveWeatherForSession(weatherResponse);
    writeWeatherForSecureStorage(weatherResponse);
    return weatherResponse;
  }

  @override
  Future<WeatherForecast> getWeatherForecast({
    required Function(WeatherForecast weatherForecast)
        saveWeatherForecastForSession,
    required Function(WeatherForecast weatherForecast)
        writeWeatherForecastForSecureStorage,
    required double lat,
    required double lon,
  }) async {
    final weatherForecastResponse = await _apiWeatherClient.getWeatherForecast(
      lat: '$lat',
      lon: '$lon',
      apiKey: apiKey,
      units: 'metric',
    );
    saveWeatherForecastForSession(weatherForecastResponse);
    writeWeatherForecastForSecureStorage(weatherForecastResponse);
    return weatherForecastResponse;
  }
}
