import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/storage/special_event/special_event.dart';

part 'calendar_special_event_list_state.freezed.dart';

@freezed
class CalendarSpecialEventListState with _$CalendarSpecialEventListState {
  const factory CalendarSpecialEventListState({
    @Default([]) List<SpecialEvent> eventList,
    @Default(false) bool isEditing,
  }) = _CalendarSpecialEventListState;

  const CalendarSpecialEventListState._();
}
