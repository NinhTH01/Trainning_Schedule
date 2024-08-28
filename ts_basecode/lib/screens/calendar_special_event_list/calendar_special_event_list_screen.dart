import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/screen_header/screen_header.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/special_event/special_event.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar_special_event_list/calendar_special_event_list_state.dart';
import 'package:ts_basecode/screens/calendar_special_event_list/calendar_special_event_list_view_model.dart';
import 'package:ts_basecode/screens/calendar_special_event_list/components/special_event_item.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<
    CalendarSpecialEventListViewModel, CalendarSpecialEventListState>(
  (ref) => CalendarSpecialEventListViewModel(
    ref: ref,
    sqfliteManager: ref.watch(sqfliteProvider),
    globalMapManager: ref.watch(globalRunningStatusManagerProvider.notifier),
  ),
);

@RoutePage()
class CalendarSpecialEventListScreen extends BaseView {
  const CalendarSpecialEventListScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarSpecialEventListState();
}

class _CalendarSpecialEventListState extends BaseViewState<
    CalendarSpecialEventListScreen, CalendarSpecialEventListViewModel> {
  @override
  void onInitState() async {
    super.onInitState();
    _onInitState();
    context.tabsRouter.addListener(() async {
      if (context.tabsRouter.activeIndex == 3) {
        await viewModel.fetchData();
      }
    });
  }

  Future<void> _onInitState() async {
    try {
      await viewModel.fetchData();
    } catch (e) {
      handleError(e);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  CalendarSpecialEventListState get state => ref.watch(_provider);

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => CalendarSpecialEventListRoute.name;

  @override
  CalendarSpecialEventListViewModel get viewModel =>
      ref.read(_provider.notifier);

  Future<void> _handleGoToEditEventScreen(
      {required bool isEdit, SpecialEvent? event}) async {
    if (event != null) {
      Event currentEvent = Event(
          description: event.description,
          distance: event.distance,
          isSpecial: 1,
          id: event.id,
          createdTime: event.createdTime);
      await AutoRouter.of(context)
          .push(
        CalendarDateEventEditRoute(
          isEdit: isEdit,
          event: currentEvent,
        ),
      )
          .then((_) async {
        ref.invalidate(_provider);
        await viewModel.fetchData();
      });
    } else {
      await AutoRouter.of(context)
          .push(
        CalendarDateEventEditRoute(
          isEdit: isEdit,
        ),
      )
          .then((_) async {
        ref.invalidate(_provider);
        await viewModel.fetchData();
      });
    }
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorName.red,
      ),
      child: IconButton(
        onPressed: () {
          _handleGoToEditEventScreen(isEdit: false);
        },
        icon: const Icon(Icons.add),
        color: ColorName.white,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ScreenHeader(
              title: TextConstants.specialEvent,
              onBack: () {
                Navigator.pop(context);
              },
              rightWidget: TextButton(
                onPressed: viewModel.toggleEditing,
                child: Text(
                  state.isEditing ? TextConstants.save : TextConstants.edit,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(_provider);
                  await viewModel.fetchData();
                },
                child: ReorderableListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return SpecialEventItem(
                      key: Key('$index'),
                      isEditing: state.isEditing,
                      event: state.eventList[index],
                      onTap: _handleGoToEditEventScreen,
                    );
                  },
                  itemCount: state.eventList.length,
                  buildDefaultDragHandles: state.isEditing,
                  onReorder: (int oldIndex, int newIndex) {
                    viewModel.handleReorder(
                        oldIndex: oldIndex, newIndex: newIndex);
                  },
                ),
              ),
            )
          ],
        ),
        StatusView(
          isVisible: globalMapState.isRunning,
          distance: globalMapState.totalDistance,
          onPress: () async {
            context.tabsRouter.setActiveIndex(1);
            viewModel.globalMapManager.toggleRunning();
          },
        ),
      ],
    );
  }
}
