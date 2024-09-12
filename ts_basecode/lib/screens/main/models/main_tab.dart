import 'package:flutter/material.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

enum MainTab {
  calendar,
  map,
  weather,
  route,
  name,
}

extension MainTabExtension on MainTab {
  String get label {
    switch (this) {
      case MainTab.calendar:
        return TextConstants.calendar;
      case MainTab.map:
        return TextConstants.map;
      case MainTab.weather:
        return TextConstants.weather;
      case MainTab.route:
        return TextConstants.route;
      case MainTab.name:
        return TextConstants.name;
    }
  }

  Icon get icon {
    switch (this) {
      case MainTab.calendar:
        return const Icon(Icons.calendar_month_outlined);
      case MainTab.map:
        return const Icon(Icons.map_outlined);
      case MainTab.weather:
        return const Icon(Icons.cloud_outlined);
      case MainTab.route:
        return const Icon(Icons.route_outlined);
      case MainTab.name:
        return const Icon(Icons.person_outlined);
    }
  }

  Icon get activeIcon {
    switch (this) {
      case MainTab.calendar:
        return const Icon(
          Icons.calendar_month,
          color: ColorName.blue,
        );
      case MainTab.map:
        return const Icon(
          Icons.map,
          color: ColorName.blue,
        );
      case MainTab.weather:
        return const Icon(
          Icons.cloud,
          color: ColorName.blue,
        );
      case MainTab.route:
        return const Icon(
          Icons.route,
          color: ColorName.blue,
        );
      case MainTab.name:
        return const Icon(
          Icons.person,
          color: ColorName.blue,
        );
    }
  }
}
