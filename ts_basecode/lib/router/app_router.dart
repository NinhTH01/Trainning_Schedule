import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar/calendar_screen.dart';
import 'package:ts_basecode/screens/main/main_screen.dart';
import 'package:ts_basecode/screens/map/map_screen.dart';
import 'package:ts_basecode/screens/splash/splash_screen.dart';
import 'package:ts_basecode/screens/weather/weather_screen.dart';

import '../screens/calendar_date_event_list/calendar_date_event_list_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: "/", initial: true),
        AutoRoute(page: OnboardingRoute.page, path: "/onboarding"),
        AutoRoute(page: MainRoute.page, path: "/main", children: [
          AutoRoute(
            page: CalendarTabRoute.page,
            path: 'calendarTab',
            children: [
              AutoRoute(page: CalendarRoute.page, path: ''),
              AutoRoute(
                  page: CalendarDateEventListRoute.page, path: 'dateEventList')
            ],
          ),
          AutoRoute(
            page: MapTabRoute.page,
            path: 'mapTab',
            children: [
              AutoRoute(
                page: MapRoute.page,
                path: '',
              ),
              // inspection child page define here
            ],
          ),
          AutoRoute(
            page: WeatherTabRoute.page,
            path: 'weatherTab',
            children: [
              AutoRoute(
                page: WeatherRoute.page,
                path: '',
              ),
              // inspection child page define here
            ],
          ),
        ]),
      ];
}

@RoutePage(name: 'CalendarTabRoute')
class CalendarTabPage extends AutoRouter {
  const CalendarTabPage({super.key});
}

@RoutePage(name: 'MapTabRoute')
class MapTabPage extends AutoRouter {
  const MapTabPage({super.key});
}

@RoutePage(name: 'WeatherTabRoute')
class WeatherTabPage extends AutoRouter {
  const WeatherTabPage({super.key});
}
