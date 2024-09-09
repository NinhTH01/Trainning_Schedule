import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/repositories/storage/map_route/map_route_repository.dart';

final mapRouteRepositoryProvider = Provider<MapRouteRepository>(
  (ref) => MapRouteRepositoryImpl(
    ref.watch(sqfliteProvider),
  ),
);
