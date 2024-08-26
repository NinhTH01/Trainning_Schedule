import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/data/repositories/api/session/session_repository.dart';
import 'package:ts_basecode/data/repositories/api/weather/weather_repository.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_map_manager.dart';
import 'package:ts_basecode/data/services/secure_storage_manager/secure_storage_manager.dart';
import 'package:ts_basecode/screens/weather/models/weather_container.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';

class WeatherViewModel extends BaseViewModel<WeatherState> {
  WeatherViewModel({
    required this.ref,
    required this.weatherRepository,
    required this.geolocatorManager,
    required this.sessionRepository,
    required this.secureStorageManager,
    required this.globalMapManager,
  }) : super(const WeatherState());

  final Ref ref;

  final WeatherRepository weatherRepository;

  final GlobalMapManager globalMapManager;

  final GeolocatorManager geolocatorManager;

  final SessionRepository sessionRepository;

  final SecureStorageManager secureStorageManager;

  Future<void> initData() async {
    Position currentLocation = await geolocatorManager.getCurrentLocation();
    await Future.wait([
      _getWeather(currentLocation),
      _getWeatherForecast(currentLocation),
    ]);
  }

  Future<void> _getWeather(Position currentLocation) async {
    final hasCachedWeather = await _getCachedWeather();
    if (hasCachedWeather) {
      unawaited(_getWeatherResponse(currentLocation));
    } else {
      await _getWeatherResponse(currentLocation);
    }
  }

  Future<bool> _getCachedWeather() async {
    /// Get info from session
    Weather? weatherResponse = sessionRepository.weather();

    /// If storyResponse == null, get info from secure storage
    weatherResponse ??= await secureStorageManager.readWeather();
    state = state.copyWith(
      currentWeather: weatherResponse,
    );
    return weatherResponse != null;
  }

  Future<void> _getWeatherResponse(Position currentLocation) async {
    final weatherResponse = await weatherRepository.getWeather(
      saveWeatherForSession: (Weather weather) {
        sessionRepository.saveWeather(weather);
      },
      writeWeatherForSecureStorage: (Weather weather) {
        secureStorageManager.writeWeather(weather);
      },
      lat: currentLocation.latitude,
      lon: currentLocation.longitude,
    );

    state = state.copyWith(
      currentWeather: weatherResponse,
      backgroundColor:
          WeatherHelper.getBackgroundColor(weatherResponse.weather?[0].main),
    );
  }

  Future<void> _getWeatherForecast(Position currentLocation) async {
    final hasCachedWeatherForecast = await _getCachedWeatherForecast();
    if (hasCachedWeatherForecast) {
      unawaited(_getWeatherForecastResponse(currentLocation));
    } else {
      await _getWeatherForecastResponse(currentLocation);
    }
  }

  Future<bool> _getCachedWeatherForecast() async {
    /// Get info from session
    WeatherForecast? weatherForecastResponse =
        sessionRepository.weatherForecast();

    /// If postResponse == null, get info from secure storage
    weatherForecastResponse ??=
        await secureStorageManager.readWeatherForecast();
    state = state.copyWith(
      weatherForecast: weatherForecastResponse,
    );
    return weatherForecastResponse != null;
  }

  Future<void> _getWeatherForecastResponse(Position currentLocation) async {
    final weatherForecastResponse = await weatherRepository.getWeatherForecast(
      saveWeatherForecastForSession: (WeatherForecast weatherForecast) {
        sessionRepository.saveWeatherForecast(weatherForecast);
      },
      writeWeatherForecastForSecureStorage: (WeatherForecast weatherForecast) {
        secureStorageManager.writeWeatherForecast(weatherForecast);
      },
      lat: currentLocation.latitude,
      lon: currentLocation.longitude,
    );
    state = state.copyWith(
      weatherForecast: weatherForecastResponse,
    );
  }

  void updateAnimatedState({
    required double containerHeight,
    required double descriptionOpacity,
    required double minimizeOpacity,
    required double scrollPadding,
  }) {
    state = state.copyWith(
      containerHeight: containerHeight,
      descriptionOpacity: descriptionOpacity,
      minimizeOpacity: minimizeOpacity,
      scrollPadding: scrollPadding,
    );
  }

  void handleRetryState(bool needRetry) {
    state = state.copyWith(
      needRetry: needRetry,
    );
  }
}
