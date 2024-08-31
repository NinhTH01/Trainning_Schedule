import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_route_map_state.freezed.dart';

@freezed
class MapRouteMapState with _$MapRouteMapState {
  const factory MapRouteMapState({
    @Default(LatLng(0, 0)) LatLng? currentLocation,
    @Default({}) Set<Marker> markers,
    @Default([]) List<LatLng> markerLocationList,
  }) = _MapRouteMapState;

  const MapRouteMapState._();
}
