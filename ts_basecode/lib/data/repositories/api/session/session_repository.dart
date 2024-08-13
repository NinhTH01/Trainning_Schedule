import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';

abstract class SessionRepository {
  Weather? weather();

  void saveWeather(Weather? weather);

  WeatherForecast? weatherForecast();

  void saveWeatherForecast(WeatherForecast? weatherForecast);
}

class SessionRepositoryImpl implements SessionRepository {
  Weather? _weather;

  WeatherForecast? _weatherForecast;

  @override
  Weather? weather() {
    return _weather;
  }

  @override
  void saveWeather(Weather? weather) {
    _weather = weather;
  }

  @override
  WeatherForecast? weatherForecast() {
    return _weatherForecast;
  }

  @override
  void saveWeatherForecast(WeatherForecast? weatherForecast) {
    _weatherForecast = weatherForecast;
  }
}
