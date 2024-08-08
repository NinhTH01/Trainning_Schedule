import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferencesManager() {
    getInstance();
  }

  static SharedPreferences? preferences;

  static const _onboarding = 'onboarding';

  Future<void> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    preferences = prefs;
  }

  static Future<bool> getOnboarding() async {
    final onboarding = preferences?.getBool(_onboarding) ?? false;

    return onboarding;
  }

  static Future<void> setOnboarding({required bool value}) async {
    await preferences?.setBool(_onboarding, value);
  }
}
