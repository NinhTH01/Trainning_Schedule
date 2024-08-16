import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_screen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';
import 'package:ts_basecode/screens/weather/weather_view_model.dart';

final _provider =
    StateNotifierProvider.autoDispose<WeatherViewModel, WeatherState>(
        (ref) => WeatherViewModel(
              ref: ref,
              mapViewModel: mapProvider,
            ));

@RoutePage()
class WeatherScreen extends BaseView {
  const WeatherScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherViewState();
}

class _WeatherViewState extends BaseViewState<WeatherScreen, WeatherViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapState get mapState => ref.watch(mapProvider);

  MapViewModel get mapViewModel => ref.read(viewModel.mapViewModel.notifier);

  @override
  Widget buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      mapState.isRunning
          ? StatusView(
              distance: mapState.totalDistance,
              onPress: () {
                context.tabsRouter.setActiveIndex(1);
                mapViewModel.toggleRunning(showFinishDialog);
              },
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            )
          : const SizedBox(),
      const Center(child: Text('Weather')),
    ]);
  }

  @override
  String get screenName => WeatherRoute.name;

  @override
  WeatherViewModel get viewModel => ref.watch(_provider.notifier);
}
