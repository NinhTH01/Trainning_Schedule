import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/models/storage/event/event.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar_date_event_list/calendar_date_event_list_state.dart';

class CalendarDateEventListViewModel
    extends BaseViewModel<CalendarDateEventListState> {
  CalendarDateEventListViewModel({
    required this.ref,
    required this.sqfliteManager,
  }) : super(const CalendarDateEventListState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  Future<void> getCurrentDateEventList(EventDateInfo calendarDate) async {
    if (calendarDate.date != null) {
      List<Event> eventList =
          await sqfliteManager.getListOnDate(calendarDate.date!);
      state = state.copyWith(eventList: eventList);
    }
  }
}
