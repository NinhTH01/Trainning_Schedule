import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

Widget calendarWeekBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Expanded(
          child: buildWeekDay(TextConstants.weekday_1),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_2),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_3),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_4),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_5),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_6),
        ),
        Expanded(
          child: buildWeekDay(TextConstants.weekday_7),
        ),
      ],
    ),
  );
}

Widget buildWeekDay(String day) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Center(
      child: Text(
        day,
        style: AppTextStyles.s16w600,
      ),
    ),
  );
}
