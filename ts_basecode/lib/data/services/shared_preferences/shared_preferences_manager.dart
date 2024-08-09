import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const _onboarding = 'onboarding';

  static Future<bool> getOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    final onboarding = preferences.getBool(_onboarding) ?? false;

    return onboarding;
  }

  static Future<void> setOnboarding({required bool value}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboarding, value);
  }
}
