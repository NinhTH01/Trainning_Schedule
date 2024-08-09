import 'package:flutter/material.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

enum MainTab { calender, map, weather }

extension MainTabExtension on MainTab {
  String getLabel(BuildContext context) {
    switch (this) {
      case MainTab.calender:
        return TextConstants.calendar;
      case MainTab.map:
        return TextConstants.map;
      case MainTab.weather:
        return TextConstants.weather;
    }
  }

  Icon getIcon(BuildContext context) {
    switch (this) {
      case MainTab.calender:
        return const Icon(Icons.calendar_month);
      case MainTab.map:
        return const Icon(Icons.map);
      case MainTab.weather:
        return const Icon(Icons.cloud);
    }
  }
}
