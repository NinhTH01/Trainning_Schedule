import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/splash/splash_view_model.dart';
import 'package:ts_basecode/utilities/app_text_styles.dart';
import 'package:ts_basecode/utilities/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(),
);

/// Screen code: A_01
@RoutePage()
class SplashScreen extends BaseView {
  const SplashScreen({super.key});

  @override
  BaseViewState<SplashScreen, SplashViewModel> createState() =>
      _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashScreen, SplashViewModel> {
  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.icon.image(
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
          const Text(
            TextConstants.appName,
            style: AppTextStyles.appNameStyle,
          ),
          const SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }

  @override
  SplashViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => SplashRoute.name;

  Future<void> _initState() async {
    final onboarding = await SharedPreferencesManager.getOnboarding();
    Future.delayed(const Duration(seconds: 1), () async {
      if (onboarding) {
        await AutoRouter.of(context).push(const MainRoute());
      } else {
        await AutoRouter.of(context).push(const OnboardingRoute());
      }
    });
  }
}
