import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/local_notification_provider.dart';
import 'package:ts_basecode/data/providers/shared_preference_provider.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final mapProvider =
    StateNotifierProvider<MapViewModel, MapState>((ref) => MapViewModel(
          ref: ref,
          geolocatorManager: ref.watch(geolocatorProvider),
          localNotificationManager: ref.watch(localNotificationProvider),
          sqfliteManager: ref.watch(sqfliteProvider),
          sharedPreferencesManager: ref.watch(sharedPreferenceProvider),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel.updateCurrentLocationMarker();
    _onInitState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onInitState();
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapState get state => ref.watch(mapProvider);

  @override
  String get screenName => MapRoute.name;

  @override
  MapViewModel get viewModel => ref.read(mapProvider.notifier);

  Future<void> _onInitState() async {
    Object? error;

    try {
      await viewModel.getLocationUpdate();
    } catch (e) {
      error = e;
    }

    if (error != null) {
      handleError(error);
    }
  }

  @override
  Widget buildBody(BuildContext context) {
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
          onTap: viewModel.createScheduleMarker,
          markers: state.markers,
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
            onPressed: () {
              viewModel.toggleRunning(
                onScreenshotCaptured: showFinishDialog,
                onFinishAchievement: () {
                  showAchievementDialog(context: context);
                },
              );
            },
            child: Text(
                state.isRunning
                    ? TextConstants.mapStop
                    : TextConstants.mapStart,
                style: AppTextStyles.w500),
          ),
        ),
      ],
    );
  }
}
