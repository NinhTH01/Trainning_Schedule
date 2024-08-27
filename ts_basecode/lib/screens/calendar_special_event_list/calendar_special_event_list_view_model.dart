import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/special_event/special_event.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/screens/calendar_special_event_list/calendar_special_event_list_state.dart';

class CalendarSpecialEventListViewModel
    extends BaseViewModel<CalendarSpecialEventListState> {
  CalendarSpecialEventListViewModel({
    required this.ref,
    required this.sqfliteManager,
    required this.globalMapManager,
  }) : super(const CalendarSpecialEventListState());

  final Ref ref;

  final SqfliteManager sqfliteManager;

  final GlobalRunningStatusManager globalMapManager;

  Future<void> fetchData() async {
    List<SpecialEvent> eventList = await sqfliteManager.getSpecialEvents();
    state = state.copyWith(
      eventList: eventList,
      isEditing: false,
    );
  }

  Future<void> toggleEditing() async {
    if (state.isEditing) {
      await _updateDatabaseOrder();
    }
    state = state.copyWith(
      isEditing: !state.isEditing,
    );
  }

  Future<void> deleteSpecialEvent(Event event) async {
    final updatedEvent = Event(
      createdTime: event.createdTime,
      distance: event.distance,
      description: event.description,
      isSpecial: 0,
    );
    await sqfliteManager.update(updatedEvent);
  }

  void handleReorder({
    required int oldIndex,
    required int newIndex,
  }) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final List<SpecialEvent> specialEventList = [...state.eventList];
    final item = specialEventList.removeAt(oldIndex);
    specialEventList.insert(newIndex, item);
    state = state.copyWith(eventList: specialEventList);
  }

  Future<void> _updateDatabaseOrder() async {
    for (var i = 0; i < state.eventList.length; i++) {
      SpecialEvent orderedItem = state.eventList[i];

      if (orderedItem.id != null) {
        await sqfliteManager.updateSpecialEventListOrder(
            newOrderIndex: state.eventList.length - i - 1, id: orderedItem.id!);
      }
    }
  }

  Future<void> deleteFromDatabase(int index) async {
    final List<SpecialEvent> specialEventList = [...state.eventList];
    final item = specialEventList.removeAt(index);
    print(specialEventList);
    state = state.copyWith(eventList: specialEventList);
  }
}
