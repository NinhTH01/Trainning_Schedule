import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/main/components/bottom_tab_bar.dart';
import 'package:ts_basecode/screens/main/main_view_model.dart';

final _provider = StateNotifierProvider.autoDispose((ref) => MainViewModel());

@RoutePage()
class MainScreen extends BaseView {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends BaseViewState<MainScreen, MainViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  bool get ignoreSafeAreaBottom => false;

  @override
  Widget buildBody(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        CalendarTabRoute(),
        MapRoute(),
        WeatherRoute(),
      ],
      resizeToAvoidBottomInset: true,
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomTabBar(tabsRouter: tabsRouter);
      },
    );
  }

  @override
  String get screenName => MainRoute.name;

  @override
  MainViewModel get viewModel => ref.read(_provider.notifier);
}
