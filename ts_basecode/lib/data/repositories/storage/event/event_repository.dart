import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';

abstract class EventRepository {
  Future<void> insert(Event event);

  Future<void> update(Event event);

  Future<void> delete(Event event);

  Future<List<Event>> getList();

  Future<List<Event>> getListOnDate(
    DateTime date, {
    String orderBy = 'ASC',
  });
}

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl(
    this._sqfliteManager,
  );

  final SqfliteManager _sqfliteManager;

  @override
  Future<void> delete(Event event) async {
    await _sqfliteManager.deleteEvent(event);
  }

  @override
  Future<List<Event>> getList() async {
    return await _sqfliteManager.getListEvent();
  }

  @override
  Future<List<Event>> getListOnDate(DateTime date,
      {String orderBy = 'ASC'}) async {
    return await _sqfliteManager.getListEventOnDate(
      date,
      orderBy: orderBy,
    );
  }

  @override
  Future<void> insert(Event event) async {
    return await _sqfliteManager.insertEvent(event);
  }

  @override
  Future<void> update(Event event) async {
    return await _sqfliteManager.updateEvent(event);
  }
}
