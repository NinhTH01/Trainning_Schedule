import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/screen_header/screen_header.dart';
import 'package:ts_basecode/models/storage/event/event.dart';
import 'package:ts_basecode/models/storage/event_date_info/event_date_info.dart';
import 'package:ts_basecode/providers/sqflite_provider.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_state.dart';
import 'package:ts_basecode/screens/calendar_date_event_edit/calendar_date_event_edit_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<
    CalendarDateEventEditViewModel, CalendarDateEventEditState>(
  (ref) => CalendarDateEventEditViewModel(
    ref: ref,
    sqfliteManager: ref.watch(sqfliteProvider),
  ),
);

@RoutePage()
class CalendarDateEventEditScreen extends BaseView {
  const CalendarDateEventEditScreen({
    super.key,
    required this.calendarDate,
    required this.isEdit,
    this.event,
  });

  final EventDateInfo calendarDate;

  final Event? event;

  final bool isEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarDateEventEditState();
}

class _CalendarDateEventEditState extends BaseViewState<
    CalendarDateEventEditScreen, CalendarDateEventEditViewModel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel.initData(
          widget.event,
        ));
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(
          title:
              widget.isEdit ? TextConstants.editEvent : TextConstants.newEvent,
          onBack: () {
            Navigator.pop(context);
          },
          rightWidget: TextButton(
            onPressed: _handleSaveOrUpdateEvent,
            child: Text(
              widget.isEdit ? TextConstants.edit : TextConstants.save,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorName.black12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: state.textEditController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: TextConstants.description,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: state.eventTime,
                    initialEntryMode: TimePickerEntryMode.input,
                  );
                  if (timeOfDay != null) {
                    viewModel.updateEventTime(timeOfDay);
                  }
                },
                child: Text(
                  state.eventTime.format(context),
                  style: AppTextStyles.blackTextStyle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        widget.isEdit
            ? TextButton(
                onPressed: () {
                  _showActionSheet(context);
                },
                child: const Text(
                  TextConstants.delete,
                  style: AppTextStyles.redTextStyle,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  CalendarDateEventEditState get state => ref.watch(_provider);

  @override
  String get screenName => CalendarDateEventEditRoute.name;

  @override
  CalendarDateEventEditViewModel get viewModel => ref.read(_provider.notifier);

  void _handleSaveOrUpdateEvent() {
    if (widget.isEdit) {
      viewModel.updateEvent(
        date: widget.calendarDate,
        isEdit: widget.isEdit,
        eventInfo: widget.event,
      );
    } else {
      viewModel.addEvent(
        date: widget.calendarDate,
        isEdit: widget.isEdit,
      );
    }
    Navigator.pop(context);
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: const Text(TextConstants.deleteEvent),
        message: const Text(TextConstants.confirmToProceed),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              viewModel.deleteEvent(
                  eventInfo: widget.event,
                  goBack: () {
                    /// Modal context to close Modal Popup and context to navigate back
                    Navigator.pop(modalContext);
                    Navigator.pop(context);
                  });
            },
            child: const Text(TextConstants.confirm),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
            },
            child: const Text(TextConstants.cancel),
          ),
        ],
      ),
    );
  }
}
