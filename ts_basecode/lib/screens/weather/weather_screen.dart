import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/global_map_manager_provider.dart';
import 'package:ts_basecode/data/providers/secure_storage_provider.dart';
import 'package:ts_basecode/data/providers/session_repository_provider.dart';
import 'package:ts_basecode/data/providers/weather_repository.provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_map_manager_state.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/weather/components/weather_forecast_container.dart';
import 'package:ts_basecode/screens/weather/components/weather_status_container.dart';
import 'package:ts_basecode/screens/weather/components/weather_wind_container.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';
import 'package:ts_basecode/screens/weather/weather_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';
import 'package:ts_basecode/utilities/extensions/string_extension.dart';

import 'models/weather_container.dart';

final _provider =
    StateNotifierProvider.autoDispose<WeatherViewModel, WeatherState>(
        (ref) => WeatherViewModel(
              ref: ref,
              weatherRepository: ref.watch(weatherRepositoryProvider),
              geolocatorManager: ref.watch(geolocatorProvider),
              sessionRepository: ref.watch(sessionRepositoryProvider),
              secureStorageManager: ref.watch(secureStorageProvider),
              globalMapManager: ref.watch(globalMapManagerProvider.notifier),
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
  Brightness? get statusBarBrightness => Brightness.dark;

  @override
  Brightness? get statusBarIconBrightness => Brightness.light;

  @override
  void onInitState() {
    super.onInitState();
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

  GlobalMapManagerState get globalMapState =>
      ref.watch(globalMapManagerProvider);

  WeatherState get state => ref.watch(_provider);

  @override
  String get screenName => WeatherRoute.name;

  @override
  WeatherViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
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
      handleError(e);
    }
  }

  dynamic _getBackgroundImagePath(String? weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return Assets.images.normal.path;
      case WeatherCondition.cloud:
        return Assets.images.cloud.path;
      case WeatherCondition.drizzle:
        return Assets.images.drizzle.path;
      case WeatherCondition.rain:
        return Assets.images.rain.path;
      case WeatherCondition.thunderstorm:
        return Assets.images.lightning.path;
      default:
        return Assets.images.clear.path;
    }
  }

  Widget _buildWeatherDetail() {
    return SizedBox(
      height: state.containerHeight,
      child: Column(
        children: [
          Text(state.currentWeather!.name!,
              style: AppTextStyles.s30w700.copyWith(
                color: ColorName.white,
              )),
          state.containerHeight > _maxContainerHeight - _maxOffsetDescription
              ? Opacity(
                  opacity: state.descriptionOpacity,
                  child: Column(
                    children: [
                      Text(
                        '${state.currentWeather?.main?.temp?.round()}°',
                        style: AppTextStyles.s60w700.copyWith(
                          color: ColorName.white,
                        ),
                      ),
                      Text(
                        state.currentWeather!.weather![0].description!
                            .capitalizeFirstLetter(),
                        style: AppTextStyles.s20w600.copyWith(
                          color: ColorName.white,
                        ),
                      ),
                      Text(
                        'H:${state.currentWeather?.main?.tempMax?.round()}  L:${state.currentWeather?.main?.tempMin?.round()}',
                        style: AppTextStyles.s20w600.copyWith(
                          color: ColorName.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Opacity(
                  opacity: state.minimizeOpacity,
                  child: Text(
                    '${state.currentWeather?.main?.temp?.round()}° | ${state.currentWeather?.weather![0].description!.capitalizeFirstLetter()}',
                    style: AppTextStyles.s16w600.copyWith(
                      color: ColorName.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildGridViewWeatherStatus() {
    return GridView(
      padding: const EdgeInsets.all(16.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 24.0,
        childAspectRatio: 1, // Width / Height ratio
      ),
      children: [
        WeatherStatusContainer(
          title: TextConstants.humidityTitle,
          value: state.currentWeather?.main?.humidity == null
              ? null
              : '${state.currentWeather?.main?.humidity}%',
          backgroundColor: state.backgroundColor!,
        ),
        WeatherStatusContainer(
          title: TextConstants.feelslikeTitle,
          value: '${state.currentWeather?.main?.feelsLike?.round()}°',
          backgroundColor: state.backgroundColor!,
        ),
        WeatherStatusContainer(
          title: TextConstants.sunsetTitle,
          value: WeatherHelper.unixToHHmm(state.currentWeather!.sys!.sunset!),
          backgroundColor: state.backgroundColor!,
        ),
        WeatherStatusContainer(
          title: TextConstants.sunriseTitle,
          value: WeatherHelper.unixToHHmm(state.currentWeather!.sys!.sunrise!),
          backgroundColor: state.backgroundColor!,
        ),
        WeatherStatusContainer(
          title: TextConstants.pressureTitle,
          value: '${state.currentWeather?.main?.pressure}\nhPa',
          backgroundColor: state.backgroundColor!,
        ),
        WeatherStatusContainer(
          title: TextConstants.visibilityTitle,
          value: state.currentWeather?.visibility == null
              ? null
              : '${state.currentWeather!.visibility! / 1000} km',
          backgroundColor: state.backgroundColor!,
        ),
      ],
    );
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
                      _buildWeatherDetail(),
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
                              _buildGridViewWeatherStatus()
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
        StatusView(
          isVisible: globalMapState.isRunning,
          distance: globalMapState.totalDistance,
          onPress: () {
            context.tabsRouter.setActiveIndex(1);
            viewModel.globalMapManager.toggleRunning();
          },
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        )
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
