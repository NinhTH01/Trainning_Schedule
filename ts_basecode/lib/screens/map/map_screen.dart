import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/local_notification_provider.dart';
import 'package:ts_basecode/data/providers/shared_preference_provider.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider<MapViewModel, MapState>((ref) => MapViewModel(
          ref: ref,
          geolocatorManager: ref.watch(geolocatorProvider),
          localNotificationManager: ref.watch(localNotificationProvider),
          sqfliteManager: ref.watch(sqfliteProvider),
          sharedPreferencesManager: ref.watch(sharedPreferenceProvider),
          globalMapManager:
              ref.watch(globalRunningStatusManagerProvider.notifier),
        ));

@RoutePage()
class MapScreen extends BaseView {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends BaseViewState<MapScreen, MapViewModel>
    with WidgetsBindingObserver {
  @override
  void onInitState() {
    super.onInitState();
    WidgetsBinding.instance.addObserver(this);
    _onInitState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      _onInitState();
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapState get state => ref.watch(_provider);

  @override
  String get screenName => MapRoute.name;

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  MapViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitState() async {
    try {
      await viewModel.getLocationUpdate();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> _handleListenProvider() async {
    try {
      if (state.isRunning) {
        await viewModel.addEventToDatabase();

        var (image, totalDistance, onClose) = await viewModel.takeScreenshot();
        showFinishDialog(
          image: image,
          distance: totalDistance,
          onClose: onClose,
        );

        var (achieved, totalDistanceFromDatabase) =
            await viewModel.checkAndCalculateToShowAchievement();

        if (mounted && achieved) {
          showAchievementDialog(
            context: context,
            totalDistance: totalDistanceFromDatabase,
          );
        }
      }
      viewModel.toggleRunning();
    } catch (e) {
      handleError(e);
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    ref.listen(
        globalRunningStatusManagerProvider.select((state) => state.isRunning),
        (prev, next) async {
      if (next == false) {
        _handleListenProvider();
      }
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          onMapCreated: viewModel.setupGoogleMapController,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              state.currentPosition?.latitude ?? 0,
              state.currentPosition?.longitude ?? 0,
            ),
            zoom: 18.0,
          ),
          onTap: viewModel.createUnfinishedMarker,
          markers: state.locationMarkers,
          polylines: state.polylines,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            onPressed: () async {
              if (state.isRunning) {
                viewModel.setupRunningStatusInGlobal(false);
              } else {
                viewModel.toggleRunning();
              }
            },
            child: Text(
              state.isRunning ? TextConstants.mapStop : TextConstants.mapStart,
              style: AppTextStyles.defaultStyle,
            ),
          ),
        ),
        StatusView(
          isVisible: globalMapState.isRunning,
          distance: globalMapState.totalDistance,
          onPress: () async {
            viewModel.globalMapManager.toggleRunning();
          },
        )
      ],
    );
  }
}
