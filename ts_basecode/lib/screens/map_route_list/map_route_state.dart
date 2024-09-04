import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';

part 'map_route_state.freezed.dart';

@freezed
class MapRouteState with _$MapRouteState {
  const factory MapRouteState({
    @Default([]) List<MapRouteModel> mapRouteList,
    @Default(false) bool isEditing,
  }) = _MapRouteState;

  const MapRouteState._();
}
