import 'package:flutter/material.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

enum MainTab {
  calendar,
  map,
  weather,
  special,
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
      case MainTab.special:
        return TextConstants.special;
    }
  }

  Icon get icon {
    switch (this) {
      case MainTab.calendar:
        return const Icon(Icons.calendar_month);
      case MainTab.map:
        return const Icon(Icons.map);
      case MainTab.weather:
        return const Icon(Icons.cloud);
      case MainTab.special:
        return const Icon(Icons.star);
    }
  }
}
