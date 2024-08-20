import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

Widget calendarWeekBar({
  required double screenWidth,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        TextConstants.weekday_1,
        TextConstants.weekday_2,
        TextConstants.weekday_3,
        TextConstants.weekday_4,
        TextConstants.weekday_5,
        TextConstants.weekday_6,
        TextConstants.weekday_7,
      ].map((text) {
        return Expanded(
          child: _buildWeekDay(text),
        );
      }).toList(),
    ),
  );
}

Widget _buildWeekDay(String day) {
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
