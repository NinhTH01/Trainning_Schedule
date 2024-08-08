import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/secure_storage_manager/secure_storage_manager.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/models/api/responses/onboarding_slide.dart';
import 'package:ts_basecode/screens/onboarding/onboarding_state.dart';

class OnboardingViewModel extends BaseViewModel<OnboardingState> {
  OnboardingViewModel({
    required this.secureStorageManager,
  }) : super(const OnboardingState());

  final SecureStorageManager secureStorageManager;

  void setCurrentPageIndex(num index) {
    state = state.copyWith(currentPageIndex: index);
  }

  Future<void> setOnboardingValue(bool value) async {
    await SharedPreferencesManager.setOnboarding(value: value);
  }

  Future<void> initData() async {
    await Future.wait([_getOnboardingSlide()]);
  }

  Future<void> _getOnboardingSlide() async {
    final String response =
        await rootBundle.loadString('assets/samples/onboarding_slide.json');
    List<dynamic> jsonList = json.decode(response);

    List<OnboardingSlide> onboardingSlideList =
        jsonList.map((json) => OnboardingSlide.fromJson(json)).toList();

    state = state.copyWith(onboardingSlide: onboardingSlideList);
  }
}
