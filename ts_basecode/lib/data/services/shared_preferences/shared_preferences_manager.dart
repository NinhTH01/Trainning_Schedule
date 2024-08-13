import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const _onboarding = 'onboarding';
  static const _achievement = 'achievement';

  Future<bool> getOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    final onboarding = preferences.getBool(_onboarding) ?? false;

    return onboarding;
  }

  Future<void> setOnboarding({required bool value}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboarding, value);
  }

  Future<bool> getAchievement() async {
    final preferences = await SharedPreferences.getInstance();
    final achievement = preferences.getBool(_achievement) ?? false;

    return achievement;
  }

  Future<void> setAchievement({required bool value}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_achievement, value);
  }
}
