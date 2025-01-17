import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/data/providers/event_repository_provider.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';
import 'package:ts_basecode/screens/calendar/calendar_view_model.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_month_view.dart';
import 'package:ts_basecode/screens/calendar/components/event_list_item.dart';
import 'package:ts_basecode/screens/main/models/main_tab.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
  (ref) => CalendarViewModel(
    ref: ref,
    eventRepository: ref.watch(eventRepositoryProvider),
    globalMapManager: ref.watch(globalRunningStatusManagerProvider.notifier),
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _onInitState());

    context.tabsRouter.addListener(() async {
      if (context.tabsRouter.activeIndex == MainTab.calendar.index) {
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

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  BuildContext get statusViewContext => context;

  Future<void> _onInitState() async {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    try {
      await viewModel.onInitData();
      calendarHeight = width * state.columnNum / 7;
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> _handleGoToEditEventScreen(
      {required bool isEdit, Event? event}) async {
    if (state.selectedDate != null) {
      await AutoRouter.of(context)
          .push(
        CalendarDateEventEditRoute(
          isEdit: isEdit,
          event: event,
        ),
      )
          .then((_) async {
        await viewModel.fetchData();
      });
    }
  }

  void _handleChangeHeaderMonth() async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.currentDate,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    viewModel.changeCurrentDateToPicker(date);
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
    return Column(
      children: [
        CalendarMonthView(
          eventDateList: state.eventDateList,
          columnNum: state.columnNum,
          handleChangeHeaderMonth: _handleChangeHeaderMonth,
          changeToNextMonth: viewModel.changeCurrentDateToNextMonth,
          changeToLastMonth: viewModel.changeCurrentDateToLastMonth,
          currentDate: state.currentDate ?? DateTime.now(),
          selectedDate: state.selectedDate ?? DateTime.now(),
          changeSelectedDate: (EventDateInfo date) {
            if (date.date != null) {
              viewModel.updateSelectedDate(date.date!);
            }
          },
        ),
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
                padding: const EdgeInsets.only(bottom: 80),
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
                  style: AppTextStyles.s16w700,
                ),
              ),
      ],
    );
  }
}
