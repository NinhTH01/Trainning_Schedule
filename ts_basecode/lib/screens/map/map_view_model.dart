import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/screens/map/map_state.dart';

class MapViewModel extends BaseViewModel<MapState> {
  MapViewModel({
    required this.ref,
    required this.geolocatorManager,
  }) : super(const MapState());

  final Ref ref;

  final GeolocatorManager geolocatorManager;

  Future<void> initData() async {
    final currentLocation = await geolocatorManager.getCurrentLocation();
    print(currentLocation);
  }
}
