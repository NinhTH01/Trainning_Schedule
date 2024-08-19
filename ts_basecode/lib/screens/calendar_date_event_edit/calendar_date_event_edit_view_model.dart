import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_state.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';

class CalendarDateEventEditViewModel
    extends BaseViewModel<CalendarDateEventEditState> {
  CalendarDateEventEditViewModel({
    required this.ref,
    required this.sqfliteManager,
    required this.mapViewModel,
  }) : super(const CalendarDateEventEditState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  final StateNotifierProvider<MapViewModel, MapState> mapViewModel;

  void initData(Event? event) {
    state = state.copyWith(
      textEditController: TextEditingController(text: event?.description ?? ''),
      eventTime: TimeOfDay.fromDateTime(event?.createdTime ?? DateTime.now()),
      eventDate: event?.createdTime ?? DateTime.now(),
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
    final selectedTime = state.eventTime;
    final description = state.textEditController!.text;

    final event = eventInfo!.copyWith(
      createdTime: DateTime(
        state.eventDate!.year,
        state.eventDate!.month,
        state.eventDate!.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
      description: description,
    );
    await sqfliteManager.update(event);
  }

  Future<void> addEvent() async {
    final selectedTime = state.eventTime;
    final description = state.textEditController!.text;

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
