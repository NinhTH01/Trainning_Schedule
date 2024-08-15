import 'package:flutter/material.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

Widget calendarBody({
  required List<EventDateInfo> dateList,
  required DateTime currentDate,
  required DateTime selectedDate,
  required void Function() changeToNextMonth,
  required void Function() changeToLastMonth,
  required void Function(EventDateInfo) changeSelectedDate,
}) {
  var daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
  var firstDayOfTheMonth = DateTime(currentDate.year, currentDate.month, 1);

  var weekDayOfFirstDay = firstDayOfTheMonth.weekday;

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 7,
      childAspectRatio: 1,
    ),
    itemCount: 35,
    itemBuilder: (context, index) {
      if (index < weekDayOfFirstDay - 1) {
        return buildDayInMonth(
          day: dateList[index],
          onPressed: changeToLastMonth,
          inMonth: false,
          selectedDate: selectedDate,
        );
      } else if (index > weekDayOfFirstDay + daysInMonth - 2) {
        return buildDayInMonth(
          day: dateList[index],
          onPressed: changeToNextMonth,
          inMonth: false,
          selectedDate: selectedDate,
        );
      } else {
        return buildDayInMonth(
          day: dateList[index],
          // () => goToEventListView(dateList[index]),
          onPressed: () => changeSelectedDate(dateList[index]),
          inMonth: true,
          selectedDate: selectedDate,
        );
      }
    },
  );
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

Widget buildDayInMonth({
  required EventDateInfo day,
  required onPressed,
  required inMonth,
  required DateTime selectedDate,
}) {
  // Check if this date is today or not
  final now = DateTime.now();

  var isToday = day.date?.year == now.year &&
      day.date?.month == now.month &&
      day.date?.day == now.day;

  var isSelectedDay = day.date?.year == selectedDate.year &&
      day.date?.month == selectedDate.month &&
      day.date?.day == selectedDate.day;

  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          // width: 35,
          decoration: BoxDecoration(
            color: isToday
                ? ColorName.red
                : isSelectedDay
                    ? ColorName.greyFF757575
                    : ColorName.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(day.date!.day.toString(),
                style: inMonth
                    ? isToday
                        ? AppTextStyles.whitew500
                        : isSelectedDay
                            ? AppTextStyles.whitew500
                            : AppTextStyles.w600
                    : AppTextStyles.otherMonthContainerStyle),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: day.hasEvent ? ColorName.blue : ColorName.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
}
