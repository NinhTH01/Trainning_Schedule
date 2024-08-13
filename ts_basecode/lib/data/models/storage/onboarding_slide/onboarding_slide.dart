import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_slide.freezed.dart';
part 'onboarding_slide.g.dart';

@freezed
class OnboardingSlide with _$OnboardingSlide {
  const factory OnboardingSlide({
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'title') String? title,
  }) = _OnboardingSlide;

  factory OnboardingSlide.fromJson(Map<String, dynamic> json) =>
      _$OnboardingSlideFromJson(json);
}
