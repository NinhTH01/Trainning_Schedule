import 'package:ts_basecode/models/api/responses/onboarding_slide.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

const List<OnboardingSlide> defaultOnboardingSlideList = [
  OnboardingSlide(
    description: TextConstants.description_1,
    imageUrl: 'assets/images/onboarding1.png',
    title: TextConstants.title_1,
  ),
  OnboardingSlide(
    description: TextConstants.description_2,
    imageUrl: 'assets/images/onboarding2.png',
    title: TextConstants.title_2,
  ),
  OnboardingSlide(
    description: TextConstants.description_3,
    imageUrl: 'assets/images/onboarding3.png',
    title: TextConstants.title_3,
  ),
];
