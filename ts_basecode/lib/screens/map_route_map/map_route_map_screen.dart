import 'dart:io' show Platform;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/providers/geolocator_provider.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map_route_map/map_route_map_state.dart';
import 'package:ts_basecode/screens/map_route_map/map_route_map_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<MapRouteMapViewModel, MapRouteMapState>(
  (ref) => MapRouteMapViewModel(
    globalMapManager: ref.watch(globalRunningStatusManagerProvider.notifier),
    geolocatorManager: ref.watch(geolocatorProvider),
  ),
);

@RoutePage()
class MapRouteMapScreen extends BaseView {
  const MapRouteMapScreen({
    super.key,
    required this.markerLocationList,
  });

  final List<LatLng> markerLocationList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapRouteListScreen();
}

class _MapRouteListScreen
    extends BaseViewState<MapRouteMapScreen, MapRouteMapViewModel> {
  @override
  void onInitState() async {
    super.onInitState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onInitState());
  }

  Future<void> _onInitState() async {
    try {
      await viewModel.updateData(widget.markerLocationList);
    } catch (e) {
      handleError(e);
    }
  }

  @override
  BuildContext get statusViewContext => context;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapRouteMapState get state => ref.watch(_provider);

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => MapRouteMapRoute.name;

  @override
  MapRouteMapViewModel get viewModel => ref.read(_provider.notifier);

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: viewModel.onInitMap,
          initialCameraPosition: CameraPosition(
            target: state.currentLocation ?? const LatLng(0, 0),
            zoom: 16.0,
          ),
          myLocationEnabled: true,
          onTap: viewModel.addMarker,
          markers: state.markers,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
        ),
        Positioned(
          right: 10,
          top: Platform.isAndroid ? 50 : 10,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, state.markerLocationList);
                },
                child: Text(
                  TextConstants.save,
                  style: AppTextStyles.s14w600,
                ),
              ),
              ElevatedButton(
                onPressed: viewModel.removeAllMarkers,
                child: const Icon(
                  Icons.delete_outline_outlined,
                  color: ColorName.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
