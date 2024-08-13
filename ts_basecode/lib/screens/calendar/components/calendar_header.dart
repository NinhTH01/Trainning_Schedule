import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

Widget calendarHeader({
  DateTime? currentDate,
  required void Function() changeToNextMonth,
  required void Function() changeToLastMonth,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: changeToLastMonth,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          DateFormat('MMMM').format(currentDate ?? DateTime.now()),
          style: AppTextStyles.s18b,
        ),
        IconButton(
          onPressed: changeToNextMonth,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    ),
  );
}
