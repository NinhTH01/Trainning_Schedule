import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/repositories/storage/shared_preferences/shared_preferences_repository.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';

final _sharedPreferenceProvider = Provider<SharedPreferencesManager>(
  (ref) => SharedPreferencesManager(),
);

final sharedPreferencesRepositoryProvider =
    Provider<SharedPreferencesRepository>(
  (ref) => SharedPreferencesRepositoryImpl(
    ref.watch(_sharedPreferenceProvider),
  ),
);
