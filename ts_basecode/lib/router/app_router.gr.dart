// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CalendarDateEventListRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarDateEventListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarDateEventListScreen(
          key: args.key,
          calendarDate: args.calendarDate,
        ),
      );
    },
    CalendarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarScreen(),
      );
    },
    CalendarTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarTabPage(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    MapRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapScreen(),
      );
    },
    MapTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MapTabPage(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
    WeatherRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WeatherScreen(),
      );
    },
    WeatherTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WeatherTabPage(),
      );
    },
  };
}

/// generated route for
/// [CalendarDateEventListScreen]
class CalendarDateEventListRoute
    extends PageRouteInfo<CalendarDateEventListRouteArgs> {
  CalendarDateEventListRoute({
    Key? key,
    required EventDateInfo calendarDate,
    List<PageRouteInfo>? children,
  }) : super(
          CalendarDateEventListRoute.name,
          args: CalendarDateEventListRouteArgs(
            key: key,
            calendarDate: calendarDate,
          ),
          initialChildren: children,
        );

  static const String name = 'CalendarDateEventListRoute';

  static const PageInfo<CalendarDateEventListRouteArgs> page =
      PageInfo<CalendarDateEventListRouteArgs>(name);
}

class CalendarDateEventListRouteArgs {
  const CalendarDateEventListRouteArgs({
    this.key,
    required this.calendarDate,
  });

  final Key? key;

  final EventDateInfo calendarDate;

  @override
  String toString() {
    return 'CalendarDateEventListRouteArgs{key: $key, calendarDate: $calendarDate}';
  }
}

/// generated route for
/// [CalendarScreen]
class CalendarRoute extends PageRouteInfo<void> {
  const CalendarRoute({List<PageRouteInfo>? children})
      : super(
          CalendarRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CalendarTabPage]
class CalendarTabRoute extends PageRouteInfo<void> {
  const CalendarTabRoute({List<PageRouteInfo>? children})
      : super(
          CalendarTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapScreen]
class MapRoute extends PageRouteInfo<void> {
  const MapRoute({List<PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MapTabPage]
class MapTabRoute extends PageRouteInfo<void> {
  const MapTabRoute({List<PageRouteInfo>? children})
      : super(
          MapTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WeatherScreen]
class WeatherRoute extends PageRouteInfo<void> {
  const WeatherRoute({List<PageRouteInfo>? children})
      : super(
          WeatherRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeatherRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WeatherTabPage]
class WeatherTabRoute extends PageRouteInfo<void> {
  const WeatherTabRoute({List<PageRouteInfo>? children})
      : super(
          WeatherTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'WeatherTabRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
