import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';

class WeatherViewModel extends BaseViewModel<WeatherState> {
  WeatherViewModel({
    required this.ref,
    required this.mapViewModel,
  }) : super(WeatherState());

  final StateNotifierProvider<MapViewModel, MapState> mapViewModel;

  MapViewModel get viewModel => ref.read(mapViewModel.notifier);

  final Ref ref;
}
