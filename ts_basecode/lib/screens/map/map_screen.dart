import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/local_notification_provider.dart';
import 'package:ts_basecode/data/providers/shared_preference_provider.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/screens/map/models/zoom_mode.dart';
import 'package:ts_basecode/screens/map_route_list/components/map_route_item.dart';
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
    context.tabsRouter.addListener(() async {
      if (context.tabsRouter.activeIndex == 1) {
        await viewModel.getRouteMapList();
        try {
          await viewModel.checkAlwaysPermission();
        } catch (e) {
          handleError(e);
        }
      }
    });

    _onInitState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    Future.delayed(Duration.zero, () async {
      if (appState == AppLifecycleState.resumed) {
        try {
          PermissionStatus status =
              await viewModel.geolocatorManager.getInUsePermission();
          if (status == PermissionStatus.granted) {
            await viewModel.checkAlwaysPermission();
            await _onInitState();
          } else {
            handleError(AlwaysPermissionException(
                TextConstants.alwaysExceptionMessage));
          }
        } catch (e) {
          handleError(e);
        }
      }
    });
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
      await viewModel.getRouteMapList();
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

  void _showModal(BuildContext context) {
    final double modalHeight = MediaQuery.of(context).size.height * 0.6;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: modalHeight,
          decoration: const BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                  left: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TextConstants.mapRouteList,
                      style: AppTextStyles.s16w700,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                      },
                      child: Text(
                        TextConstants.close,
                        style: AppTextStyles.s14w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.mapRouteList.length,
                  itemBuilder: (context, index) {
                    return MapRouteItem(
                      mapRoute: viewModel.mapRouteList[index],
                      isEditing: false,
                      onPress: () {
                        _showActionSheet(
                          context: context,
                          mapRoute: viewModel.mapRouteList[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showActionSheet({
    required BuildContext context,
    required MapRouteModel mapRoute,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: const Text(TextConstants.addRoute),
        message: const Text(TextConstants.confirmToAddRoute),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              viewModel.createUnfinishedMarkerFromMapRoute(mapRoute);
              if (context.mounted) {
                Navigator.pop(modalContext);
                Navigator.pop(context);
              }
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

  IconData _buildZoomIcon() {
    switch (state.zoomMode) {
      case ZoomMode.polyline:
        return Icons.route_outlined;

      case ZoomMode.normal:
        return Icons.near_me_rounded;

      case ZoomMode.marker:
        return Icons.location_on_rounded;
    }
  }

  Widget _buildBottomRowButtons() {
    return Positioned(
      bottom: 24,
      left: 10,
      right: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            onPressed: () {
              viewModel.updateZoomMode();
            },
            child: Icon(
              _buildZoomIcon(),
              size: 20,
              color: ColorName.black,
            ),
          ),
          ElevatedButton(
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
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              onPressed: () async {
                viewModel.animatedCamera();
              },
              child: const Icon(
                Icons.my_location_outlined,
                size: 20,
                color: ColorName.black,
              )),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

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
            zoom: 16.0,
          ),
          onTap: viewModel.createUnfinishedMarker,
          markers: state.locationMarkers,
          polylines: state.polylines,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
        _buildBottomRowButtons(),
        Positioned(
          right: 10,
          top: topInset,
          child: ElevatedButton(
            onPressed: () {
              _showModal(context);
            },
            child: Text(
              TextConstants.addRoute,
              style: AppTextStyles.s12w500,
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
