import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_state.dart';

class CalendarDateEventEditViewModel
    extends BaseViewModel<CalendarDateEventEditState> {
  CalendarDateEventEditViewModel({
    required this.ref,
    required this.sqfliteManager,
    required this.globalMapManager,
  }) : super(const CalendarDateEventEditState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  final GlobalRunningStatusManager globalMapManager;

  TextEditingController textController = TextEditingController();

  void initData(Event? event) {
    state = state.copyWith(
      eventTime: TimeOfDay.fromDateTime(event?.createdTime ?? DateTime.now()),
      eventDate: event?.createdTime ?? DateTime.now(),
    );
    textController = TextEditingController(text: event?.description);
  }

  void updateEmptyDescriptionValidate(bool value) {
    state = state.copyWith(
      emptyDescriptionValidate: value,
    );
  }

  void updateEventTime(TimeOfDay timeOfDay) {
    state = state.copyWith(
      eventTime: timeOfDay,
    );
  }

  void updateEventDate(DateTime dateTime) {
    state = state.copyWith(
      eventDate: dateTime,
    );
  }

  Future<void> updateEvent({
    required bool isEdit,
    Event? eventInfo,
  }) async {
    if (eventInfo == null || state.eventDate == null) {
      return;
    }

    final selectedTime = state.eventTime;
    final description = textController.text;

    final event = eventInfo.copyWith(
      createdTime: DateTime(
        state.eventDate!.year,
        state.eventDate!.month,
        state.eventDate!.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      description: description,
    );
    await sqfliteManager.updateEvent(event);
  }

  Future<void> addEvent() async {
    if (state.eventDate == null) {
      return;
    }

    final selectedTime = state.eventTime;
    final description = textController.text;

    final event = Event(
      createdTime: DateTime(
        state.eventDate!.year,
        state.eventDate!.month,
        state.eventDate!.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      distance: 0,
      description: description,
    );
    await sqfliteManager.insertEvent(event);
  }

  Future<void> deleteEvent({
    required Event? eventInfo,
    required Function() goBack,
  }) async {
    if (eventInfo != null) {
      await sqfliteManager.deleteEvent(eventInfo);
      goBack();
    }
  }
}
