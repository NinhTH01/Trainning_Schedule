import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/models/api/responses/onboarding_slide.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default([]) List<OnboardingSlide> onboardingSlide,
    @Default(0) num currentPageIndex,
  }) = _OnboardingState;

  const OnboardingState._();
}
