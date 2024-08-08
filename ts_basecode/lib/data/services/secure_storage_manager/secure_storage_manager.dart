import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  SecureStorageManager(this._storage);

  final FlutterSecureStorage _storage;

  static const _onboarding = 'onboarding';

  Future<dynamic> _read({
    required String key,
  }) async {
    return _storage.read(key: key);
  }

  Future<void> _delete({
    required String key,
  }) async {
    await _storage.delete(key: key);
  }

  Future<void> _write({
    required String key,
    required String? value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> writeOnboarding(bool onboarding) async {
    try {
      await _write(
        key: _onboarding,
        value: json.encode(onboarding),
      );
    } catch (_) {}
  }

  Future<bool?> readOnboarding() async {
    final result = await _read(key: _onboarding);
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
