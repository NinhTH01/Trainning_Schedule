import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/providers/sqflite_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar/calendar_state.dart';
import 'package:ts_basecode/screens/calendar/calendar_view_model.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_header.dart';
import 'package:ts_basecode/screens/calendar/components/calendar_week_bar.dart';

import 'components/calendar_body.dart';

final _provider =
    StateNotifierProvider.autoDispose<CalendarViewModel, CalendarState>(
  (ref) => CalendarViewModel(
    ref: ref,
    sqfliteManager: ref.watch(sqfliteProvider),
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onInitState());

    context.tabsRouter.addListener(() {
      if (context.tabsRouter.activeIndex == 0) {
        viewModel.fetchEventDateList();
      }
    });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        calendarHeader(
          currentDate: state.currentDate,
          changeToLastMonth: viewModel.changeCurrentDateToLastMonth,
          changeToNextMonth: viewModel.changeCurrentDateToNextMonth,
        ),
        calendarWeekBar(),
        const SizedBox(height: 24),
        state.eventDateList.isNotEmpty
            ? Expanded(
                child: calendarBody(
                    dateList: state.eventDateList,
                    currentDate: state.currentDate ?? DateTime.now(),
                    changeToLastMonth: viewModel.changeCurrentDateToLastMonth,
                    changeToNextMonth: viewModel.changeCurrentDateToNextMonth,
                    goToEventListScreen: (date) {
                      context.router
                          .push(CalendarDateEventListRoute(
                        calendarDate: date,
                      ))
                          .then((_) {
                        viewModel.fetchEventDateList();
                      });
                    }),
              )
            : const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  CalendarState get state => ref.watch(_provider);

  @override
  String get screenName => CalendarRoute.name;

  @override
  CalendarViewModel get viewModel => ref.read(_provider.notifier);

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
}
