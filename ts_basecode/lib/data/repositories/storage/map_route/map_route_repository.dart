import 'package:ts_basecode/data/models/storage/coordinate/coordinate.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';

abstract class MapRouteRepository {
  Future<void> insert({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  });

  Future<void> update({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  });

  Future<void> delete(MapRouteModel mapRoute);

  Future<List<MapRouteModel>> getList();

  Future<void> updateListOrder({
    required int id,
    required int newOrderIndex,
  });
}

class MapRouteRepositoryImpl implements MapRouteRepository {
  MapRouteRepositoryImpl(
    this._sqfliteManager,
  );

  final SqfliteManager _sqfliteManager;

  @override
  Future<void> insert({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  }) async {
    return await _sqfliteManager.insertRoute(
      mapRoute: mapRoute,
      coordinates: coordinates,
    );
  }

  @override
  Future<void> update({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  }) async {
    return await _sqfliteManager.updateRoute(
      mapRoute: mapRoute,
      coordinates: coordinates,
    );
  }

  @override
  Future<void> delete(MapRouteModel mapRoute) async {
    await _sqfliteManager.deleteRoute(mapRoute);
  }

  @override
  Future<List<MapRouteModel>> getList() async {
    return await _sqfliteManager.getListRoute();
  }

  @override
  Future<void> updateListOrder({
    required int id,
    required int newOrderIndex,
  }) async {
    await _sqfliteManager.updateMapRouteListOrder(
      id: id,
      newOrderIndex: newOrderIndex,
    );
  }
}
