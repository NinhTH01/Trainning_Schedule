import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ts_basecode/data/models/storage/coordinate/coordinate.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';

class SqfliteManager {
  final _databaseName = 'events.db';
  final _databaseVersion = 4;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const notNullTextType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $tableEvents ( 
        ${EventFields.id} $idType, 
        ${EventFields.description} $textType,
        ${EventFields.distance} $doubleType,
        ${EventFields.time} $notNullTextType
      )
 ''');

    await db.execute('''
      CREATE TABLE $tableMapRoute ( 
        ${MapRouteFields.id} $idType, 
        ${MapRouteFields.name} $textType,
        ${MapRouteFields.description} $textType,
        ${MapRouteFields.markers} $textType,
        ${MapRouteFields.orderIndex} $intType
      )
 ''');
  }

  Future<void> insert(Event event) async {
    final db = await database;

    await db.insert(
      tableEvents,
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Event event) async {
    final db = await database;

    await db.update(
      tableEvents,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> delete(Event event) async {
    final db = await database;

    await db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<List<Event>> getList() async {
    final db = await database;

    const orderBy = '${EventFields.time} ASC';
    final result = await db.query(tableEvents, orderBy: orderBy);
    return result.map(Event.fromJson).toList();
  }

  Future<List<Event>> getListOnDate(
    DateTime date, {
    String orderBy = 'ASC',
  }) async {
    final db = await database;

    var startDate = DateTime(date.year, date.month, date.day);
    var endDate = DateTime(date.year, date.month, date.day + 1);

    // Format the date range
    var formattedStartDate =
        DateFormat(AppConstants.yyyyMMddHHmmssFormat).format(startDate);
    var formattedEndDate =
        DateFormat(AppConstants.yyyyMMddHHmmssFormat).format(endDate);
    final result = await db.query(
      tableEvents,
      where: 'time BETWEEN ? AND ?',
      whereArgs: [formattedStartDate, formattedEndDate],
      orderBy: '${EventFields.time} $orderBy',
    );

    return result.map(Event.fromJson).toList();
  }

  Future<void> insertRoute({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  }) async {
    final db = await database;

    var list = await getListRoute();

    String serializedCoordinates =
        jsonEncode(coordinates.map((e) => e.toJson()).toList());

    await db.insert(
      tableMapRoute,
      {
        ...mapRoute.toJson(),
        MapRouteFields.orderIndex:
            list.isNotEmpty ? list[0].orderIndex! + 1 : list.length,
        MapRouteFields.markers: serializedCoordinates,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRoute({
    required MapRouteModel mapRoute,
    required List<Coordinate> coordinates,
  }) async {
    final db = await database;

    String serializedCoordinates =
        jsonEncode(coordinates.map((e) => e.toJson()).toList());

    await db.update(
      tableMapRoute,
      {
        ...mapRoute.toJson(),
        MapRouteFields.markers: serializedCoordinates,
      },
      where: '${MapRouteFields.id} = ?',
      whereArgs: [mapRoute.id],
    );
  }

  Future<void> deleteRoute(MapRouteModel mapRoute) async {
    final db = await database;

    await db.delete(
      tableMapRoute,
      where: '${MapRouteFields.id} = ?',
      whereArgs: [mapRoute.id],
    );
  }

  Future<List<MapRouteModel>> getListRoute() async {
    final db = await database;

    const orderBy = '${MapRouteFields.orderIndex} DESC';
    final result = await db.query(tableMapRoute, orderBy: orderBy);

    if (result.isNotEmpty) {
      return List<MapRouteModel>.from(
        result.map(
          (map) => MapRouteModel(
            id: map[MapRouteFields.id] as int,
            name: map[MapRouteFields.name] as String,
            description: map[MapRouteFields.description] as String,
            orderIndex: map[MapRouteFields.orderIndex] as int,
            markerLocations: (jsonDecode(map[MapRouteFields.markers] as String)
                    as List<dynamic>)
                .map(
                    (json) => Coordinate.fromJson(json as Map<String, dynamic>))
                .toList(),
          ),
        ),
      );
    }

    return [];
  }

  Future<void> updateMapRouteListOrder({
    required int id,
    required int newOrderIndex,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableMapRoute,
      where: '${MapRouteFields.id} = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      MapRouteModel item = result
          .map(
            (map) => MapRouteModel(
              id: map[MapRouteFields.id] as int,
              name: map[MapRouteFields.name] as String,
              description: map[MapRouteFields.description] as String,
              orderIndex: map[MapRouteFields.orderIndex] as int,
              markerLocations:
                  (jsonDecode(map[MapRouteFields.markers] as String)
                          as List<dynamic>)
                      .map((json) =>
                          Coordinate.fromJson(json as Map<String, dynamic>))
                      .toList(),
            ),
          )
          .toList()[0];

      String serializedCoordinates =
          jsonEncode(item.markerLocations?.map((e) => e.toJson()).toList());

      MapRouteModel insertEvent = MapRouteModel(
        id: item.id,
        name: item.name,
        description: item.description,
        orderIndex: newOrderIndex,
      );

      await db.update(
        tableMapRoute,
        {
          ...insertEvent.toJson(),
          MapRouteFields.markers: serializedCoordinates,
        },
        where: '${MapRouteFields.id} = ?',
        whereArgs: [item.id],
      );
    }
  }
}
