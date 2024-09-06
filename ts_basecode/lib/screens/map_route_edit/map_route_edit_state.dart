import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_route_edit_state.freezed.dart';

@freezed
class MapRouteEditState with _$MapRouteEditState {
  const factory MapRouteEditState({
    @Default([]) List<LatLng> markerLocationList,
    @Default(false) bool emptyNameValidate,
  }) = _MapRouteEditState;

  const MapRouteEditState._();
}
