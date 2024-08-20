import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';
import 'package:ts_basecode/screens/calendar/calendar_view_model.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_header.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_week_bar.dart';
import 'package:ts_basecode/screens/calendar/components/event_list_item.dart';
import 'package:ts_basecode/screens/map/map_screen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

import 'components/calendar_body.dart';

final _provider =
    StateNotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
  (ref) => CalendarViewModel(
    ref: ref,
    sqfliteManager: ref.watch(sqfliteProvider),
    mapViewModel: mapProvider,
  ),
);

@RoutePage()
class CalendarScreen extends BaseView {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState
    extends BaseViewState<CalendarScreen, CalendarViewModel> {
  late final double calendarHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set final value based on screen height
      var size = MediaQuery.of(context).size;
      var width = size.width;
      calendarHeight = width * 5 / 7;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _onInitState());

    context.tabsRouter.addListener(() async {
      if (context.tabsRouter.activeIndex == 0) {
        await viewModel.fetchData();
      }
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  CalendarState get state => ref.watch(_provider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => CalendarRoute.name;

  @override
  CalendarViewModel get viewModel => ref.read(_provider.notifier);

  MapState get mapState => ref.watch(mapProvider);

  MapViewModel get mapViewModel => ref.read(viewModel.mapViewModel.notifier);

  Future<void> _onInitState() async {
    Object? error;

    try {
      await viewModel.onInitData();
    } catch (e) {
      error = e;
    }

    if (error != null) {
      handleError(error);
    }
  }

  Future<void> _handleGoToEditEventScreen(
      {required bool isEdit, Event? event}) async {
    if (state.selectedDate != null) {
      await AutoRouter.of(context)
          .push(
        CalendarDateEventEditRoute(
          calendarDate: state.selectedDate!,
          isEdit: isEdit,
          event: event,
        ),
      )
          .then((_) async {
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
          _handleGoToEditEventScreen(isEdit: false).then((_) async {
            await viewModel.fetchData();
          });
        },
        icon: const Icon(Icons.add),
        color: ColorName.white,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Column(
          children: [
            calendarHeader(
              currentDate: state.currentDate,
              changeToLastMonth: viewModel.changeCurrentDateToLastMonth,
              changeToNextMonth: viewModel.changeCurrentDateToNextMonth,
            ),
            calendarWeekBar(screenWidth: screenWidth),
            const SizedBox(height: 24),
            state.eventDateList.isNotEmpty
                ? SizedBox(
                    height: calendarHeight,
                    child: calendarBody(
                        dateList: state.eventDateList,
                        selectedDate: state.selectedDate ?? DateTime.now(),
                        currentDate: state.currentDate ?? DateTime.now(),
                        changeToLastMonth:
                            viewModel.changeCurrentDateToLastMonth,
                        changeToNextMonth:
                            viewModel.changeCurrentDateToNextMonth,
                        changeSelectedDate: (date) {
                          viewModel.updateSelectedDate(date.date!);
                        }),
                  )
                : const Center(child: CircularProgressIndicator()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Expanded(
                  child: Divider(
                    color: ColorName.black,
                    thickness: 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    viewModel.isSameDay(DateTime.now(), state.selectedDate)
                        ? TextConstants.today
                        : DateFormat(AppConstants.mmmmddFormat)
                            .format(state.selectedDate ?? DateTime.now()),
                    style: AppTextStyles.s16w600,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: ColorName.black,
                    thickness: 0.5,
                  ),
                ),
              ],
            ),
            state.eventList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return EventListItem(
                        event: state.eventList[index],
                        onTap: _handleGoToEditEventScreen,
                      );
                    },
                    itemCount: state.eventList.length,
                  ))
                : Center(
                    child: Text(
                      TextConstants.noEvent,
                      style: AppTextStyles.s16w400,
                    ),
                  ),
          ],
        ),
        mapState.isRunning
            ? StatusView(
                distance: mapState.totalDistance,
                onPress: () {
                  context.tabsRouter.setActiveIndex(1);
                  mapViewModel.toggleRunning(
                      onScreenshotCaptured: showFinishDialog,
                      onFinishAchievement: () {
                        showAchievementDialog(context: context);
                      });
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              )
            : const SizedBox(),
      ],
    );
  }
}
