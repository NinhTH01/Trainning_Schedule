import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';

part 'calendar_date_event_list_state.freezed.dart';

@freezed
class CalendarDateEventListState with _$CalendarDateEventListState {
  const factory CalendarDateEventListState({
    @Default([]) List<Event> eventList,
  }) = _CalendarDateEventListState;

  const CalendarDateEventListState._();
}
