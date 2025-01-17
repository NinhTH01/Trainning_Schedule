import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/providers/shared_preferences_repository_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/onboarding/onboarding_state.dart';
import 'package:ts_basecode/screens/onboarding/onboarding_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<OnboardingViewModel, OnboardingState>(
  (ref) => OnboardingViewModel(
      sharedPreferencesRepository:
          ref.watch(sharedPreferencesRepositoryProvider)),
);

/// Screen code: A_01
@RoutePage()
class OnboardingScreen extends BaseView {
  const OnboardingScreen({super.key});

  @override
  BaseViewState<OnboardingScreen, OnboardingViewModel> createState() =>
      _OnboardingViewState();
}

class _OnboardingViewState
    extends BaseViewState<OnboardingScreen, OnboardingViewModel> {
  final _pageController = PageController();

  OnboardingState get state => ref.watch(_provider);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  OnboardingViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => OnboardingRoute.name;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: state.onboardingSlideList.length,
              onPageChanged: (page) {
                viewModel.setCurrentPageIndex(page);
              },
              itemBuilder: (context, index) {
                final onboardingSlide = state.onboardingSlideList[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingSlide.imageUrl ?? ''),
                    const SizedBox(height: 15),
                    Text(
                      onboardingSlide.title ?? '',
                      style: const TextStyle(
                        fontSize: 31,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      onboardingSlide.description ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                );
              },
            ),
          ),

          // const SizedBox(height: 150),
          state.onboardingSlideList.isNotEmpty
              ? SmoothPageIndicator(
                  controller: _pageController,
                  count: state.onboardingSlideList.length,
                  effect: const WormEffect(
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                    spacing: 8.0,
                    radius: 8.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                  ),
                )
              : const SizedBox(),

          const SizedBox(height: 15),
          SizedBox(
            width: 150,
            child: OutlinedButton(
              onPressed: () async {
                if (state.currentPageIndex <
                    state.onboardingSlideList.length - 1) {
                  await _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  await viewModel.setOnboardingValue(true);
                  Future.delayed(Duration.zero, () async {
                    await AutoRouter.of(context).push(const MainRoute());
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                state.currentPageIndex == state.onboardingSlideList.length - 1
                    ? TextConstants.started
                    : TextConstants.next,
                style: AppTextStyles.s14w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
