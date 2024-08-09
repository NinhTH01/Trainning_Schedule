import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/weather/weather_view_model.dart';

@RoutePage()
class WeatherScreen extends BaseView {
  const WeatherScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherViewState();
}

class _WeatherViewState extends BaseViewState<WeatherScreen, WeatherViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text("Weather"),
    );
  }

  @override
  // TODO: implement screenName
  String get screenName => WeatherRoute.name;

  @override
  // TODO: implement viewModel
  WeatherViewModel get viewModel => throw UnimplementedError();
}
