import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

Widget calendarHeader({
  DateTime? currentDate,
  required void Function() changeToNextMonth,
  required void Function() changeToLastMonth,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(currentDate ?? DateTime.now()),
          style: AppTextStyles.s24b,
        ),
        Row(
          children: [
            IconButton(
              onPressed: changeToLastMonth,
              icon: const Icon(Icons.arrow_back_ios, size: 20),
            ),
            IconButton(
              onPressed: changeToNextMonth,
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
          ],
        ),
      ],
    ),
  );
}
