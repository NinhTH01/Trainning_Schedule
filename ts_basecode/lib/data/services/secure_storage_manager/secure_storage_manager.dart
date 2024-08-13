import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _event = 'event';

  Future<dynamic> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  Future<void> _write({
    required String key,
    required String? value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> writeEventList(List<Event> eventList) async {
    try {
      await _write(
        key: _event,
        value: json.encode(eventList),
      );
    } catch (_) {}
  }

  Future<List<Event>?> readEventList() async {
    final result = await _read(key: _event);
    if (result == null) {
      return null;
    } else {
      try {
        return result;
      } catch (_) {
        return null;
      }
    }
  }
}
