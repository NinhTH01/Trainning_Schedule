import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';

class CalendarViewModel extends BaseViewModel<CalendarState> {
  CalendarViewModel({
    required this.ref,
  }) : super(const CalendarState());

  final Ref ref;

  Future<void> onInitData() async {
    state = state.copyWith(currentDate: DateTime.now());
    getThisMonthDateList();
  }

  void changeCurrentDateToNextMonth() {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month + 1,
      ));
      getThisMonthDateList();
    }
  }

  void changeCurrentDateToLastMonth() {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month - 1,
      ));
      getThisMonthDateList();
    }
  }

  Future<void> getThisMonthDateList() async {
    if (state.currentDate != null) {
      var firstDayOfMonth =
          DateTime(state.currentDate!.year, state.currentDate!.month, 1);
      var weekday = firstDayOfMonth.weekday;
      var previousSunday =
          firstDayOfMonth.subtract(Duration(days: weekday - 1));

      var eventDateInfoList = <EventDateInfo>[];
      for (var i = 0; i < 35; i++) {
        eventDateInfoList.add(
          EventDateInfo(
            date: previousSunday.add(Duration(days: i)),
            hasEvent: false,
          ),
        );
      }

      state = state.copyWith(eventDateList: eventDateInfoList);
    }

    // return eventDateInfoList;
  }
}
