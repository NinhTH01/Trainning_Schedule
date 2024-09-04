import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/api/responses/weather/weather.dart';
import 'package:ts_basecode/data/models/api/responses/weather_forecast/weather_forecast.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/weather_repository.provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/weather/components/weather_forecast_view.dart';
import 'package:ts_basecode/screens/weather/components/weather_status_view.dart';
import 'package:ts_basecode/screens/weather/components/weather_wind_view.dart';
import 'package:ts_basecode/screens/weather/helpers/weather_helper.dart';
import 'package:ts_basecode/screens/weather/weather_state.dart';
import 'package:ts_basecode/screens/weather/weather_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';
import 'package:ts_basecode/utilities/extensions/string_extension.dart';

final _provider =
    StateNotifierProvider.autoDispose<WeatherViewModel, WeatherState>(
        (ref) => WeatherViewModel(
              ref: ref,
              weatherRepository: ref.watch(weatherRepositoryProvider),
              geolocatorManager: ref.watch(geolocatorProvider),
              globalMapManager:
                  ref.watch(globalRunningStatusManagerProvider.notifier),
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

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  WeatherState get state => ref.watch(_provider);

  @override
  String get screenName => WeatherRoute.name;

  @override
  WeatherViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitData() async {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set final value based on screen height
      var height = MediaQuery.of(context).size.height;
      if (height > 1000) {
        _maxContainerHeight = 300;
      }
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

  dynamic _getBackgroundImagePath(WeatherStatus? weatherCondition) {
    switch (weatherCondition) {
      case WeatherStatus.clear:
        return Assets.images.normal.path;
      case WeatherStatus.cloud:
        return Assets.images.cloud.path;
      case WeatherStatus.drizzle:
        return Assets.images.drizzle.path;
      case WeatherStatus.rain:
        return Assets.images.rain.path;
      case WeatherStatus.thunderstorm:
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
          Text(
            state.currentWeather!.name!,
            style: AppTextStyles.s30w700.copyWith(
              color: ColorName.white,
            ),
          ),
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
                        state.currentWeather!.weatherDataList![0].description!
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
                    '${state.currentWeather?.main?.temp?.round()}° | ${state.currentWeather?.weatherDataList![0].description!.capitalizeFirstLetter()}',
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
        WeatherStatusView(
          title: TextConstants.humidityTitle,
          value: state.currentWeather?.main?.humidity == null
              ? null
              : '${state.currentWeather?.main?.humidity}%',
          backgroundColor: state.backgroundColor,
        ),
        WeatherStatusView(
          title: TextConstants.feelslikeTitle,
          value: '${state.currentWeather?.main?.feelsLike?.round()}°',
          backgroundColor: state.backgroundColor,
        ),
        WeatherStatusView(
          title: TextConstants.sunsetTitle,
          value: WeatherHelper.unixToHHmm(state.currentWeather!.sys!.sunset!),
          backgroundColor: state.backgroundColor,
        ),
        WeatherStatusView(
          title: TextConstants.sunriseTitle,
          value: WeatherHelper.unixToHHmm(state.currentWeather!.sys!.sunrise!),
          backgroundColor: state.backgroundColor,
        ),
        WeatherStatusView(
          title: TextConstants.pressureTitle,
          value: '${state.currentWeather?.main?.pressure}\nhPa',
          backgroundColor: state.backgroundColor,
        ),
        WeatherStatusView(
          title: TextConstants.visibilityTitle,
          value: state.currentWeather?.visibility == null
              ? null
              : '${state.currentWeather!.visibility! / 1000} km',
          backgroundColor: state.backgroundColor,
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        (state.currentWeather != null && state.weatherForecast != null)
            ? Stack(
                children: [
                  DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            _getBackgroundImagePath(state.currentWeather
                                ?.weatherDataList?[0].mainWeatherStatus),
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
                                padding:
                                    EdgeInsets.only(top: state.scrollPadding),
                                controller: _scrollController,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // First item
                                    WeatherForecastView(
                                      weather: state.currentWeather ??
                                          const Weather(),
                                      weatherForecast: state.weatherForecast ??
                                          const WeatherForecast(),
                                    ),
                                    WeatherWindView(
                                        weather: state.currentWeather!),
                                    // Grid
                                    _buildGridViewWeatherStatus()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    right: 0,
                    top: topInset,
                    child: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: ColorName.white,
                      ),
                      onPressed: () async {
                        viewModel.handleRetryState(true);
                        try {
                          await viewModel.initData();
                        } catch (e) {
                          handleError(e);
                          viewModel.handleRetryState(false);
                        }
                      },
                    ),
                  ),
                  state.needRetry
                      ? const Stack(
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: ModalBarrier(
                                color: Colors.black,
                                dismissible: false,
                              ),
                            ),
                            Center(
                                child: CircularProgressIndicator(
                              color: ColorName.white70,
                            ))
                          ],
                        )
                      : const SizedBox(),
                ],
              )
            : (Center(
                child: state.needRetry
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Text(
                              TextConstants.noWeatherData,
                              style: AppTextStyles.s16w600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                viewModel.handleRetryState(false);
                                try {
                                  await viewModel.initData();
                                } catch (e) {
                                  viewModel.handleRetryState(true);
                                }
                              },
                              child: SizedBox(
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(TextConstants.retry,
                                        style: AppTextStyles.s16w500),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      size: 20,
                                      Icons.refresh,
                                      color: (state.currentWeather != null &&
                                              state.weatherForecast != null)
                                          ? ColorName.white
                                          : ColorName.black,
                                    )
                                  ],
                                ),
                              )),
                        ],
                      )
                    : const CircularProgressIndicator())),
        StatusView(
          isVisible: globalMapState.isRunning,
          distance: globalMapState.totalDistance,
          onPress: () {
            context.tabsRouter.setActiveIndex(1);
            viewModel.globalMapManager.toggleRunning();
          },
        ),
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
