import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';

abstract class SharedPreferencesRepository {
  Future<bool> getOnboarding();

  Future<void> setOnboarding({required bool value});

  Future<bool> getAchievement();

  Future<void> setAchievement({required bool value});

  Future<String> getUsername();

  Future<void> setUsername({required String value});
}

class SharedPreferencesRepositoryImpl implements SharedPreferencesRepository {
  SharedPreferencesRepositoryImpl(
    this.sharedPreferencesManager,
  );

  final SharedPreferencesManager sharedPreferencesManager;

  @override
  Future<bool> getAchievement() async {
    return await sharedPreferencesManager.getAchievement();
  }

  @override
  Future<bool> getOnboarding() async {
    return await sharedPreferencesManager.getOnboarding();
  }

  @override
  Future<String> getUsername() async {
    return await sharedPreferencesManager.getUsername();
  }

  @override
  Future<void> setAchievement({required bool value}) async {
    await sharedPreferencesManager.setAchievement(value: value);
  }

  @override
  Future<void> setOnboarding({required bool value}) async {
    await sharedPreferencesManager.setOnboarding(value: value);
  }

  @override
  Future<void> setUsername({required String value}) async {
    await sharedPreferencesManager.setUsername(value: value);
  }
}
