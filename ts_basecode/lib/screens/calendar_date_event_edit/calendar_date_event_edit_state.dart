import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_date_event_edit_state.freezed.dart';

@freezed
class CalendarDateEventEditState with _$CalendarDateEventEditState {
  const factory CalendarDateEventEditState({
    @Default(TimeOfDay(hour: 0, minute: 0)) TimeOfDay eventTime,
    DateTime? eventDate,
    @Default(false) bool emptyDescriptionValidate,
  }) = _CalendarDateEventEditState;

  const CalendarDateEventEditState._();
}
