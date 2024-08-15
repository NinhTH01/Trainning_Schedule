import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';

part 'calendar_state.freezed.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    @Default(null) DateTime? currentDate,
    @Default(null) DateTime? selectedDate,
    @Default([]) List<EventDateInfo> eventDateList,
    @Default([]) List<EventDateInfo> defaultDateList,
    @Default([]) List<Event> eventList,
  }) = _CalendarState;

  const CalendarState._();
}
