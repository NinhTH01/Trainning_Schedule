import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/repositories/api/weather/weather_repository.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/screens/weather/helpers/weather_helper.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';

class WeatherViewModel extends BaseViewModel<WeatherState> {
  WeatherViewModel({
    required this.ref,
    required this.weatherRepository,
    required this.geolocatorManager,
    required this.globalMapManager,
  }) : super(const WeatherState());

  final Ref ref;

  final WeatherRepository weatherRepository;

  final GlobalRunningStatusManager globalMapManager;

  final GeolocatorManager geolocatorManager;

  Future<void> initData() async {
    await geolocatorManager.checkPermissionForWeather();
    Position currentLocation = await geolocatorManager.getCurrentLocation();
    await Future.wait([
      _getWeather(currentLocation),
      _getWeatherForecast(currentLocation),
    ]);
  }

  Future<void> _getWeather(Position currentLocation) async {
    final weatherResponse = await weatherRepository.getWeather(
      lat: currentLocation.latitude,
      lon: currentLocation.longitude,
    );

    state = state.copyWith(
      currentWeather: weatherResponse,
      needRetry: false,
      backgroundColor:
          WeatherHelper.getBackgroundColor(weatherResponse.weather?[0].main),
    );
  }

  Future<void> _getWeatherForecast(Position currentLocation) async {
    final weatherForecastResponse = await weatherRepository.getWeatherForecast(
      lat: currentLocation.latitude,
      lon: currentLocation.longitude,
    );
    state = state.copyWith(
      weatherForecast: weatherForecastResponse,
      needRetry: false,
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
