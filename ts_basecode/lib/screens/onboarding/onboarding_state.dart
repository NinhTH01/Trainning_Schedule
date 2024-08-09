import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/models/api/responses/onboarding_slide.dart';

part 'onboarding_state.freezed.dart';

const List<OnboardingSlide> defaultOnboardingSlideList = [
  OnboardingSlide(
    description:
        'Monitor your performance with detailed running stats. Track your distance, pace, and progress over time to achieve your fitness goals.',
    imageUrl: 'assets/images/onboarding1.png',
    title: 'Track Your Run',
  ),
  OnboardingSlide(
    description:
        'Stay prepared with accurate weather forecasts. Get real-time updates on temperature, humidity, and precipitation to plan your runs around the best conditions.',
    imageUrl: 'assets/images/onboarding2.png',
    title: 'Weather Forecast',
  ),
  OnboardingSlide(
    description:
        'Plan your perfect run with our interactive map feature. Explore new routes, track your favorite paths, and never get lost with real-time navigation descriptions',
    imageUrl: 'assets/images/onboarding3.png',
    title: 'Map Your Route',
  ),
];

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(defaultOnboardingSlideList) List<OnboardingSlide> onboardingSlide,
    @Default(0) num currentPageIndex,
  }) = _OnboardingState;

  const OnboardingState._();
}
