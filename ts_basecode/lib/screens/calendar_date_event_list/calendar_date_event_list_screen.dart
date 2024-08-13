import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/screen_header/screen_header.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar_date_event_list/calendar_date_event_list_state.dart';
import 'package:ts_basecode/screens/calendar_date_event_list/calendar_date_event_list_view_model.dart';
import 'package:ts_basecode/screens/calendar_date_event_list/components/event_list_item.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<
    CalendarDateEventListViewModel, CalendarDateEventListState>(
  (ref) => CalendarDateEventListViewModel(
    ref: ref,
    sqfliteManager: ref.watch(sqfliteProvider),
  ),
);

@RoutePage()
class CalendarDateEventListScreen extends BaseView {
  const CalendarDateEventListScreen({super.key, required this.calendarDate});

  final EventDateInfo calendarDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarDateEventListState();
}

class _CalendarDateEventListState extends BaseViewState<
    CalendarDateEventListScreen, CalendarDateEventListViewModel> {
  @override
  void initState() {
    super.initState();
    viewModel.getCurrentDateEventList(widget.calendarDate);
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(
          title: DateFormat('dd MMMM yyyy').format(widget.calendarDate.date!),
          onBack: () {
            Navigator.pop(context);
          },
          rightWidget: IconButton(
            onPressed: () {
              _handleGoToEditEventScreen(isEdit: false);
            },
            icon: const Icon(Icons.add),
          ),
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
            : const Center(
                child: Text(TextConstants.noEvent),
              ),
      ],
    );
  }

  CalendarDateEventListState get state => ref.watch(_provider);

  @override
  String get screenName => CalendarDateEventListRoute.name;

  @override
  CalendarDateEventListViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _handleGoToEditEventScreen(
      {required bool isEdit, Event? event}) async {
    await AutoRouter.of(context)
        .push(
      CalendarDateEventEditRoute(
        calendarDate: widget.calendarDate,
        isEdit: isEdit,
        event: event,
      ),
    )
        .then((_) {
      viewModel.getCurrentDateEventList(widget.calendarDate);
    });
  }
}
