import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/storage/onboarding_slide/onboarding_slide.dart';
import 'package:ts_basecode/screens/onboarding/data/onboarding_slide_list.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(defaultOnboardingSlideList)
    List<OnboardingSlide> onboardingSlideList,
    @Default(0) int currentPageIndex,
  }) = _OnboardingState;

  const OnboardingState._();
}
