import 'package:auto_route/auto_route.dart';
import 'package:ts_basecode/screens/home/home_screen.dart';
import 'package:ts_basecode/screens/splash/splash_screen.dart';

import '../screens/onboarding/onboarding_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: "/", initial: true),
        AutoRoute(page: OnboardingRoute.page, path: "/onboarding"),
        AutoRoute(page: HomeRoute.page, path: "/home"),
      ];
}
