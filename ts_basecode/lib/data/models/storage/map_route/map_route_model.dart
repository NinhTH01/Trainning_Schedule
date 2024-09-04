import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_route_model.freezed.dart';
part 'map_route_model.g.dart';

const String tableMapRoute = 'mapRoutes';

class MapRouteFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String description = 'description';
  static const String markers = 'markerLocations';
  static const String orderIndex = 'orderIndex';
}

@freezed
class MapRouteModel with _$MapRouteModel {
  const factory MapRouteModel({
    @JsonKey(name: MapRouteFields.id) int? id,
    @JsonKey(name: MapRouteFields.markers) List? markerLocations,
    @JsonKey(name: MapRouteFields.orderIndex) int? orderIndex,
    String? name,
    String? description,
  }) = _MapRouteModel;

  factory MapRouteModel.fromJson(Map<String, dynamic> json) =>
      _$MapRouteModelFromJson(json);
}
