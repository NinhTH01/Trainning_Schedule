import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/models/storage/event/event.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';

class CalendarViewModel extends BaseViewModel<CalendarState> {
  CalendarViewModel({
    required this.ref,
    required this.sqfliteManager,
  }) : super(const CalendarState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  Future<void> onInitData() async {
    state = state.copyWith(currentDate: DateTime.now());
    await getDefaultDateList();
    fetchEventDateList();
  }

  void changeCurrentDateToNextMonth() {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month + 1,
      ));
      fetchEventDateList();
    }
  }

  void changeCurrentDateToLastMonth() {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month - 1,
      ));
      fetchEventDateList();
    }
  }

  Future<void> getDefaultDateList() async {
    if (state.currentDate != null) {
      var firstDayOfMonth =
          DateTime(state.currentDate!.year, state.currentDate!.month, 1);
      var weekday = firstDayOfMonth.weekday;
      var previousSunday =
          firstDayOfMonth.subtract(Duration(days: weekday - 1));

      var defaultDateInfoList = <EventDateInfo>[];
      for (var i = 0; i < 35; i++) {
        defaultDateInfoList.add(
          EventDateInfo(
            date: previousSunday.add(Duration(days: i)),
            hasEvent: false,
          ),
        );
      }

      state = state.copyWith(defaultDateList: defaultDateInfoList);
    }
  }

  Future<void> fetchEventDateList() async {
    if (state.defaultDateList.isNotEmpty) {
      final eventList = await sqfliteManager.getList();

      final eventDateInfoList = <EventDateInfo>[];

      for (EventDateInfo date in state.defaultDateList) {
        bool hasEvent = false;
        for (Event event in eventList) {
          if (_isSameDay(date.date, event.createdTime)) {
            hasEvent = true;
            break;
          }
        }
        eventDateInfoList
            .add(EventDateInfo(hasEvent: hasEvent, date: date.date));
      }

      state = state.copyWith(eventDateList: eventDateInfoList);
    }
  }

  bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 != null && date2 != null) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    } else {
      return false;
    }
  }
}
