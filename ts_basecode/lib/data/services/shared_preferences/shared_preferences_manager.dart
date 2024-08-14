import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  final _onboarding = 'onboarding';

  Future<bool> getOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    final onboarding = preferences.getBool(_onboarding) ?? false;

    return onboarding;
  }

  Future<void> setOnboarding({required bool value}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboarding, value);
  }
}
