import 'package:auto_route/auto_route.dart';
import 'package:ts_basecode/screens/home/home_screen.dart';

import '../screens/onboarding/onboarding_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: OnboardingRoute.page, path: "/", initial: true),
        AutoRoute(page: HomeRoute.page, path: "/home"),
      ];
}
