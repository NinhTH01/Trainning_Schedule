import 'package:flutter/material.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

Widget calendarBody({
  required List<EventDateInfo> dateList,
  required DateTime currentDate,
  required void Function() changeToNextMonth,
  required void Function() changeToLastMonth,
  required void Function(EventDateInfo) goToEventListScreen,
}
    // void Function(EventDateInfo) goToEventListView,
    ) {
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
        return buildDayInMonth(dateList[index], changeToLastMonth, false);
      } else if (index > weekDayOfFirstDay + daysInMonth - 2) {
        return buildDayInMonth(dateList[index], changeToNextMonth, false);
      } else {
        return buildDayInMonth(
          dateList[index],
          // () => goToEventListView(dateList[index]),
          () => goToEventListScreen(dateList[index]),
          true,
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

Widget buildDayInMonth(EventDateInfo day, onPressed, inMonth) {
  // Check if this date is today or not
  final now = DateTime.now();
  var isToday = day.date?.year == now.year &&
      day.date?.month == now.month &&
      day.date?.day == now.day;

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
            color: isToday ? ColorName.red : ColorName.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(day.date!.day.toString(),
                style: inMonth
                    ? isToday
                        ? AppTextStyles.isTodayContainerStyle
                        : AppTextStyles.notTodayContainerStyle
                    : AppTextStyles.otherMonthContainerStyle),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 4,
          width: 4,
          decoration: BoxDecoration(
            color:
                day.hasEvent ? ColorName.greyFF757575 : ColorName.transparent,
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
}
