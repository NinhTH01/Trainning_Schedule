import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(LatLng(0, 0)) LatLng currentPosition,
    @Default(null) GoogleMapController? googleMapController,
    @Default([]) List<LatLng> polylineCoordinateList,
    @Default({}) Set<Polyline> polylines,
    @Default(false) bool isRunning,
  }) = _MapState;

  const MapState._();
}
