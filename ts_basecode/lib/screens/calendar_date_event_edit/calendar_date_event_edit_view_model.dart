import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/models/storage/event/event.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_state.dart';

class CalendarDateEventEditViewModel
    extends BaseViewModel<CalendarDateEventEditState> {
  CalendarDateEventEditViewModel({
    required this.ref,
    required this.sqfliteManager,
  }) : super(const CalendarDateEventEditState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  void initData(Event? event) {
    state = state.copyWith(
      textEditController: TextEditingController(text: event?.description ?? ''),
      eventTime: TimeOfDay.fromDateTime(event?.createdTime ?? DateTime.now()),
    );
  }

  void updateEventTime(TimeOfDay timeOfDay) {
    state = state.copyWith(
      eventTime: timeOfDay,
    );
  }

  Future<void> updateEvent({
    required EventDateInfo date,
    required bool isEdit,
    Event? eventInfo,
  }) async {
    final selectedTime = state.eventTime;
    final description = state.textEditController!.text;

    final event = eventInfo!.copyWith(
      createdTime: DateTime(
        date.date!.year,
        date.date!.month,
        date.date!.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      description: description,
    );
    await sqfliteManager.update(event);
  }

  Future<void> addEvent({
    required EventDateInfo date,
    required bool isEdit,
  }) async {
    final selectedTime = state.eventTime;
    final description = state.textEditController!.text;

    final event = Event(
      createdTime: DateTime(
        date.date!.year,
        date.date!.month,
        date.date!.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      distance: 0,
      description: description,
    );
    await sqfliteManager.insert(event);
  }

  Future<void> deleteEvent({
    required Event? eventInfo,
    required Function() goBack,
  }) async {
    if (eventInfo != null) {
      await sqfliteManager.delete(eventInfo.id);
      goBack();
    }
  }
}
