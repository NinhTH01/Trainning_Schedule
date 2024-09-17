import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/screens/calendar/calendar_screen.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_screen.dart';
import 'package:ts_basecode/screens/main/main_screen.dart';
import 'package:ts_basecode/screens/map/map_screen.dart';
import 'package:ts_basecode/screens/map_route_edit/map_route_edit_screen.dart';
import 'package:ts_basecode/screens/map_route_list/map_route_list_screen.dart';
import 'package:ts_basecode/screens/map_route_map/map_route_map_screen.dart';
import 'package:ts_basecode/screens/race/race_screen.dart';
import 'package:ts_basecode/screens/splash/splash_screen.dart';
import 'package:ts_basecode/screens/weather/weather_screen.dart';

import '../data/models/storage/map_route/map_route_model.dart';
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
              AutoRoute(
                page: CalendarRoute.page,
                path: '',
              ),
              AutoRoute(
                page: CalendarDateEventEditRoute.page,
                path: 'dateEventEdit',
              ),
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
            ],
          ),
          AutoRoute(
            page: MapRouteTabRoute.page,
            path: 'mapRouteTab',
            children: [
              AutoRoute(
                page: MapRouteListRoute.page,
                path: '',
              ),
              AutoRoute(
                page: MapRouteEditRoute.page,
                path: 'mapRouteEdit',
              ),
              AutoRoute(
                page: MapRouteMapRoute.page,
                path: 'mapRouteMap',
              ),
              // inspection child page define here
            ],
          ),
          AutoRoute(
            page: RaceTabRoute.page,
            path: 'raceTab',
            children: [
              AutoRoute(
                page: RaceRoute.page,
                path: '',
              ),
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

@RoutePage(name: 'MapRouteTabRoute')
class MapRouteTabPage extends AutoRouter {
  const MapRouteTabPage({super.key});
}

@RoutePage(name: 'RaceTabRoute')
class RaceTabPage extends AutoRouter {
  const RaceTabPage({super.key});
}
