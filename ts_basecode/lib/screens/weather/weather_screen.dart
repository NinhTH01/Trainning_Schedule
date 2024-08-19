import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/secure_storage_provider.dart';
import 'package:ts_basecode/data/providers/session_repository_provider.dart';
import 'package:ts_basecode/data/providers/weather_repository.provider.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_screen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/screens/weather/components/weather_forecast_container.dart';
import 'package:ts_basecode/screens/weather/components/weather_status_container.dart';
import 'package:ts_basecode/screens/weather/components/weather_wind_container.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';
import 'package:ts_basecode/screens/weather/weather_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';
import 'package:ts_basecode/utilities/helper/string.dart';

import 'models/weather_container.dart';

final _provider =
    StateNotifierProvider.autoDispose<WeatherViewModel, WeatherState>(
        (ref) => WeatherViewModel(
              ref: ref,
              weatherRepository: ref.watch(weatherRepositoryProvider),
              geolocatorManager: ref.watch(geolocatorProvider),
              sessionRepository: ref.watch(sessionRepositoryProvider),
              secureStorageManager: ref.watch(secureStorageProvider),
              mapViewModel: mapProvider,
            ));

@RoutePage()
class WeatherScreen extends BaseView {
  const WeatherScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherViewState();
}

class _WeatherViewState extends BaseViewState<WeatherScreen, WeatherViewModel> {
  final ScrollController _scrollController = ScrollController();
  // Final value for animation logic
  double _maxContainerHeight = 250;
  double _maxOffsetDescription = 60;
  double _maxOffsetMinimize = 100;
  // Variables

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  void initState() {
    super.initState();
    _onInitData();
  }

  void _onScroll() {
    final containerHeight = _maxContainerHeight - _scrollController.offset;
    final height = containerHeight < _maxOffsetMinimize
        ? _maxOffsetMinimize
        : (containerHeight > _maxContainerHeight
            ? _maxContainerHeight
            : containerHeight);

    final opacity = 1.0 - (_scrollController.offset / _maxOffsetDescription);
    final descOpacity = opacity < 0 ? 0.0 : (opacity > 1 ? 1.0 : opacity);

    final minOpacity = (_scrollController.offset - _maxOffsetDescription) /
        (_maxOffsetMinimize - _maxOffsetDescription);
    final minimizeOpacity =
        minOpacity < 0 ? 0.0 : (minOpacity > 1 ? 1.0 : minOpacity);

    final scrollPadding =
        _scrollController.offset < _maxContainerHeight - _maxOffsetMinimize
            ? _scrollController.offset
            : _maxContainerHeight - _maxOffsetMinimize;

    viewModel.updateAnimatedState(
      containerHeight: height,
      descriptionOpacity: descOpacity,
      scrollPadding: scrollPadding,
      minimizeOpacity: minimizeOpacity,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  Color? get backgroundColor => ColorName.transparent;

  MapState get mapState => ref.watch(mapProvider);

  MapViewModel get mapViewModel => ref.read(viewModel.mapViewModel.notifier);

  WeatherState get state => ref.watch(_provider);

  @override
  String get screenName => WeatherRoute.name;

  @override
  WeatherViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
    Object? error;

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set final value based on screen height
      var size = MediaQuery.of(context).size;
      var height = size.height;
      _maxContainerHeight = height * 0.3;
      _maxOffsetDescription = height * 0.07;
      _maxOffsetMinimize = height * 0.11;
    });

    try {
      await viewModel.initData();
    } catch (e) {
      viewModel.handleRetryState(true);
      error = e;
    }

    if (error != null) {
      handleError(error);
    }
  }

  dynamic _getBackgroundImagePath(String? weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return 'assets/images/normal.jpg';
      case WeatherCondition.cloud:
        return 'assets/images/cloud.jpg';
      case WeatherCondition.drizzle:
        return 'assets/images/drizzle.jpg';
      case WeatherCondition.rain:
        return 'assets/images/rain.jpg';
      case WeatherCondition.thunderstorm:
        return 'assets/images/lightning.jpg';
      default:
        return 'assets/images/clear.jpg';
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        (state.currentWeather != null && state.weatherForecast != null)
            ? DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      _getBackgroundImagePath(
                          state.currentWeather?.weather?[0].main),
                    ),
                    fit: BoxFit
                        .cover, // Adjust the fit property to control how the image is resized to cover the container
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Start: Weather Detail
                      SizedBox(
                        height: state.containerHeight,
                        child: Column(
                          children: [
                            Text(state.currentWeather!.name!,
                                style: AppTextStyles.whites30b),
                            state.containerHeight >
                                    _maxContainerHeight - _maxOffsetDescription
                                ? Opacity(
                                    opacity: state.descriptionOpacity,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${state.currentWeather?.main?.temp?.round()}°',
                                          style: AppTextStyles.whites60b,
                                        ),
                                        Text(
                                          state.currentWeather!.weather![0]
                                              .description!
                                              .capitalizeFirstLetter(),
                                          style: AppTextStyles.whites20w600,
                                        ),
                                        Text(
                                          'H:${state.currentWeather?.main?.tempMax?.round()}  L:${state.currentWeather?.main?.tempMin?.round()}',
                                          style: AppTextStyles.whites20w600,
                                        ),
                                      ],
                                    ),
                                  )
                                : Opacity(
                                    opacity: state.minimizeOpacity,
                                    child: Text(
                                      '${state.currentWeather?.main?.temp?.round()}° | ${state.currentWeather?.weather![0].description!.capitalizeFirstLetter()}',
                                      style: AppTextStyles.whites16w600,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      // End: header Detail
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const _NoBounceScrollPhysics(),
                          padding: EdgeInsets.only(top: state.scrollPadding),
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // First item
                              WeatherForecastContainer(
                                weather:
                                    state.currentWeather ?? const Weather(),
                                weatherForecast: state.weatherForecast ??
                                    const WeatherForecast(),
                              ),
                              WeatherWindContainer(
                                  weather: state.currentWeather!),
                              // Grid
                              GridView(
                                padding: const EdgeInsets.all(16.0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing: 20.0,
                                  mainAxisSpacing: 24.0,
                                  childAspectRatio: 1, // Width / Height ratio
                                ),
                                children: [
                                  WeatherStatusContainer(
                                    title: TextConstants.humidityTitle,
                                    value: state.currentWeather?.main
                                                ?.humidity ==
                                            null
                                        ? null
                                        : '${state.currentWeather?.main?.humidity}%',
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                  WeatherStatusContainer(
                                    title: TextConstants.feelslikeTitle,
                                    value:
                                        '${state.currentWeather?.main?.feelsLike?.round()}°',
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                  WeatherStatusContainer(
                                    title: TextConstants.sunsetTitle,
                                    value: WeatherHelper.unixToHHmm(
                                        state.currentWeather!.sys!.sunset!),
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                  WeatherStatusContainer(
                                    title: TextConstants.sunriseTitle,
                                    value: WeatherHelper.unixToHHmm(
                                        state.currentWeather!.sys!.sunrise!),
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                  WeatherStatusContainer(
                                    title: TextConstants.pressureTitle,
                                    value:
                                        '${state.currentWeather?.main?.pressure}\nhPa',
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                  WeatherStatusContainer(
                                    title: TextConstants.visibilityTitle,
                                    value: state.currentWeather?.visibility ==
                                            null
                                        ? null
                                        : '${state.currentWeather!.visibility! / 1000} km',
                                    backgroundColor: state.backgroundColor!,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            : (Center(
                child: state.needRetry
                    ? TextButton(
                        onPressed: () async {
                          viewModel.handleRetryState(false);
                          try {
                            await viewModel.initData();
                          } catch (e) {
                            viewModel.handleRetryState(true);
                          }
                        },
                        child: const Text(TextConstants.retry),
                      )
                    : const CircularProgressIndicator())),
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

class _NoBounceScrollPhysics extends ClampingScrollPhysics {
  const _NoBounceScrollPhysics({super.parent});

  @override
  _NoBounceScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _NoBounceScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= 0.0) {
      // Prevent scrolling up when already at the top
      return value - position.pixels;
    } else {
      return super.applyBoundaryConditions(position, value);
    }
  }
}
