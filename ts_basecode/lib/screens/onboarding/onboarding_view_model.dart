import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/screens/onboarding/onboarding_state.dart';

class OnboardingViewModel extends BaseViewModel<OnboardingState> {
  OnboardingViewModel() : super(const OnboardingState());

  void setCurrentPageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  Future<void> setOnboardingValue(bool value) async {
    await SharedPreferencesManager.setOnboarding(value: value);
  }
}
