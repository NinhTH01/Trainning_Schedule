import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/repositories/storage/shared_preferences/shared_preferences_repository.dart';
import 'package:ts_basecode/screens/onboarding/onboarding_state.dart';

class OnboardingViewModel extends BaseViewModel<OnboardingState> {
  OnboardingViewModel({
    required this.sharedPreferencesRepository,
  }) : super(const OnboardingState());

  final SharedPreferencesRepository sharedPreferencesRepository;

  void setCurrentPageIndex(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  Future<void> setOnboardingValue(bool value) async {
    await sharedPreferencesRepository.setOnboarding(value: value);
  }
}
