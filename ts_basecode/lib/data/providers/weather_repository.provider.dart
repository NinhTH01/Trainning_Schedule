import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/providers/api_weather_client_provider.dart';
import 'package:ts_basecode/data/repositories/api/weather/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>(
  (ref) => WeatherRepositoryImpl(
    ref.watch(apiWeatherClientProvider),
  ),
);
