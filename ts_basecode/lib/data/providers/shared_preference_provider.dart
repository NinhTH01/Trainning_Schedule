import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';

final sharedPreferenceProvider = Provider<SharedPreferencesManager>(
  (ref) => SharedPreferencesManager(),
);
