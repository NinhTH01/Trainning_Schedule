import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';

class CalendarViewModel extends BaseViewModel<CalendarState> {
  CalendarViewModel({
    required this.ref,
    required this.sqfliteManager,
    required this.globalMapManager,
  }) : super(const CalendarState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  final GlobalRunningStatusManager globalMapManager;

  Future<void> onInitData() async {
    state = state.copyWith(
      currentDate: DateTime.now(),
      selectedDate: DateTime.now(),
    );
    await fetchData();
  }

  Future<void> fetchData() async {
    await getDefaultDateList();
    await _getDateEventList(state.selectedDate ?? DateTime.now());
  }

  void changeCurrentDateToNextMonth() async {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month + 1,
      ));
      await getDefaultDateList();
    }
  }

  void changeCurrentDateToLastMonth() async {
    if (state.currentDate != null) {
      state = state.copyWith(
          currentDate: DateTime(
        state.currentDate!.year,
        state.currentDate!.month - 1,
      ));
      await getDefaultDateList();
    }
  }

  void changeCurrentDateToPicker(DateTime? date) async {
    if (state.currentDate != null && date != null) {
      state = state.copyWith(
        currentDate: DateTime(
          date.year,
          date.month,
        ),
      );
      await getDefaultDateList();
      updateSelectedDate(date);
    }
  }

  Future<void> getDefaultDateList() async {
    if (state.currentDate != null) {
      var calendarColumn = 6;
      var firstDayOfMonth =
          DateTime(state.currentDate!.year, state.currentDate!.month, 1);
      var weekday = firstDayOfMonth.weekday;
      var previousSunday =
          firstDayOfMonth.subtract(Duration(days: weekday - 1));

      DateTime firstDayNextMonth;
      if (state.currentDate!.month == 12) {
        firstDayNextMonth = DateTime(state.currentDate!.year + 1, 1, 1);
      } else {
        firstDayNextMonth =
            DateTime(state.currentDate!.year, state.currentDate!.month + 1, 1);
      }

      if (weekday + firstDayNextMonth.subtract(const Duration(days: 1)).day >
          36) {
        calendarColumn = 6;
      } else {
        calendarColumn = 5;
      }

      var defaultDateInfoList = <EventDateInfo>[];
      for (var i = 0; i < calendarColumn * 7; i++) {
        defaultDateInfoList.add(
          EventDateInfo(
            date: previousSunday.add(Duration(days: i)),
            hasEvent: false,
          ),
        );
      }

      await _fetchEventDateList(
        defaultDateList: defaultDateInfoList,
        columnNum: calendarColumn,
      );
    }
  }

  Future<void> _fetchEventDateList({
    required List<EventDateInfo> defaultDateList,
    required int columnNum,
  }) async {
    if (defaultDateList.isNotEmpty) {
      final eventList = await sqfliteManager.getList();

      final eventDateInfoList = <EventDateInfo>[];

      for (EventDateInfo date in defaultDateList) {
        bool hasEvent = false;
        for (Event event in eventList) {
          if (isSameDay(date.date, event.createdTime)) {
            hasEvent = true;
            break;
          }
        }
        eventDateInfoList
            .add(EventDateInfo(hasEvent: hasEvent, date: date.date));
      }

      state = state.copyWith(
        eventDateList: eventDateInfoList,
        columnNum: columnNum,
      );
    }
  }

  bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 != null && date2 != null) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    } else {
      return false;
    }
  }

  void updateSelectedDate(DateTime date) async {
    await _getDateEventList(date);
  }

  Future<void> _getDateEventList(DateTime date) async {
    List<Event> eventList = await sqfliteManager.getListOnDate(date);
    state = state.copyWith(
      eventList: eventList,
      selectedDate: date,
    );
  }
}
