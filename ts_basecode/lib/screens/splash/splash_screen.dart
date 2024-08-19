import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/providers/local_notification_provider.dart';
import 'package:ts_basecode/data/providers/shared_preference_provider.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/splash/splash_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(
    sharedPreferencesManager: ref.watch(sharedPreferenceProvider),
    localNotificationManager: ref.watch(localNotificationProvider),
  ),
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
    viewModel.askNotificationPermission();
    viewModel.handleNavigate(context);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  SplashViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => SplashRoute.name;

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
}
