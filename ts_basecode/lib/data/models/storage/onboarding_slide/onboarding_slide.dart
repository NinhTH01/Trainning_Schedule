import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_slide.freezed.dart';
part 'onboarding_slide.g.dart';

@freezed
class OnboardingSlide with _$OnboardingSlide {
  const factory OnboardingSlide({
    String? description,
    String? imageUrl,
    String? title,
  }) = _OnboardingSlide;

  factory OnboardingSlide.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSlideFromJson(json);
}
