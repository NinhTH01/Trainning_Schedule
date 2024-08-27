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
    CalendarDateEventEditRoute.name: (routeData) {
      final args = routeData.argsAs<CalendarDateEventEditRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CalendarDateEventEditScreen(
          key: args.key,
          isEdit: args.isEdit,
          event: args.event,
        ),
      );
    },
    CalendarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarScreen(),
      );
    },
    CalendarSpecialEventListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CalendarSpecialEventListScreen(),
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
    SpecialTabRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SpecialTabPage(),
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
/// [CalendarDateEventEditScreen]
class CalendarDateEventEditRoute
    extends PageRouteInfo<CalendarDateEventEditRouteArgs> {
  CalendarDateEventEditRoute({
    Key? key,
    required bool isEdit,
    Event? event,
    List<PageRouteInfo>? children,
  }) : super(
          CalendarDateEventEditRoute.name,
          args: CalendarDateEventEditRouteArgs(
            key: key,
            isEdit: isEdit,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'CalendarDateEventEditRoute';

  static const PageInfo<CalendarDateEventEditRouteArgs> page =
      PageInfo<CalendarDateEventEditRouteArgs>(name);
}

class CalendarDateEventEditRouteArgs {
  const CalendarDateEventEditRouteArgs({
    this.key,
    required this.isEdit,
    this.event,
  });

  final Key? key;

  final bool isEdit;

  final Event? event;

  @override
  String toString() {
    return 'CalendarDateEventEditRouteArgs{key: $key, isEdit: $isEdit, event: $event}';
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
/// [CalendarSpecialEventListScreen]
class CalendarSpecialEventListRoute extends PageRouteInfo<void> {
  const CalendarSpecialEventListRoute({List<PageRouteInfo>? children})
      : super(
          CalendarSpecialEventListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CalendarSpecialEventListRoute';

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
/// [SpecialTabPage]
class SpecialTabRoute extends PageRouteInfo<void> {
  const SpecialTabRoute({List<PageRouteInfo>? children})
      : super(
          SpecialTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'SpecialTabRoute';

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
