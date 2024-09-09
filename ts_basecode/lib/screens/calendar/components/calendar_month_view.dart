import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_body.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({
    super.key,
    required this.eventDateList,
    required this.columnNum,
    required this.handleChangeHeaderMonth,
    required this.changeToNextMonth,
    required this.changeToLastMonth,
    required this.currentDate,
    required this.selectedDate,
    required this.changeSelectedDate,
  });

  final List<EventDateInfo> eventDateList;

  final int columnNum;

  final DateTime currentDate;

  final DateTime selectedDate;

  final VoidCallback handleChangeHeaderMonth;

  final VoidCallback changeToLastMonth;

  final VoidCallback changeToNextMonth;

  final Function(EventDateInfo date) changeSelectedDate;

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: handleChangeHeaderMonth,
            child: Text(
              DateFormat(AppConstants.mmmmyyyyFormat).format(currentDate),
              style: AppTextStyles.s24w700,
            ),
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

  Widget _buildCalendarWeekBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            child: _buildWeekDay(text, screenWidth),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeekDay(String day, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Text(
          day,
          style:
              screenWidth < 400 ? AppTextStyles.s12w700 : AppTextStyles.s16w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildCalendarWeekBar(context),
        const SizedBox(height: 24),
        eventDateList.isNotEmpty
            ? SizedBox(
                height: width * columnNum / 7 - 10,
                child: calendarBody(
                  numOfCalendarColumn: columnNum,
                  dateList: eventDateList,
                  selectedDate: selectedDate,
                  currentDate: currentDate,
                  changeToLastMonth: changeToLastMonth,
                  changeToNextMonth: changeToNextMonth,
                  changeSelectedDate: changeSelectedDate,
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
