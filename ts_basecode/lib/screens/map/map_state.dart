import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(null) LatLng? currentPosition,
    @Default(null) LatLng? lastPosition,
    @Default(null) GoogleMapController? googleMapController,
    @Default([]) List<LatLng> polylineCoordinateList,
    @Default({}) Set<Polyline> polylines,
    @Default(false) bool isRunning,
    @Default(false) bool isTakingScreenshot,
    @Default(0.0) double totalDistance,
    @Default(0.0) double distanceCoveredSinceLastNotification,
    @Default(1) int distanceThresholdPassCounter,
    @Default(null) BitmapDescriptor? mapMarker,
    @Default(0.0) double directionAngle,
  }) = _MapState;

  const MapState._();
}
