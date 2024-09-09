import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/repositories/storage/shared_preferences/shared_preferences_repository.dart';
import 'package:ts_basecode/data/services/local_notification_manager/local_notification_manager.dart';
import 'package:ts_basecode/router/app_router.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel({
    required this.sharedPreferencesRepository,
    required this.localNotificationManager,
  }) : super(null);

  final SharedPreferencesRepository sharedPreferencesRepository;

  final LocalNotificationManager localNotificationManager;

  Future<void> handleNavigate(BuildContext context) async {
    final onboarding = await sharedPreferencesRepository.getOnboarding();
    Future.delayed(const Duration(seconds: 1), () async {
      if (onboarding) {
        await AutoRouter.of(context).push(const MainRoute());
      } else {
        await AutoRouter.of(context).push(const OnboardingRoute());
      }
    });
  }

  void askNotificationPermission() {
    localNotificationManager.askPermission();
  }
}
