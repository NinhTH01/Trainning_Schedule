import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/calendar/calendar_view_model.dart';

@RoutePage()
class CalendarScreen extends BaseView {
  const CalendarScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState
    extends BaseViewState<CalendarScreen, CalendarViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return const Center(child: Text('Calendar'));
  }

  @override
  // TODO: implement screenName
  String get screenName => CalendarRoute.name;

  @override
  // TODO: implement viewModel
  CalendarViewModel get viewModel => throw UnimplementedError();
}
