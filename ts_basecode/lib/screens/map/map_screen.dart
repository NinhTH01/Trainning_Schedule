import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/providers/geolocator_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';

final _provider = StateNotifierProvider.autoDispose<MapViewModel, MapState>(
    (ref) => MapViewModel(
          ref: ref,
          geolocatorManager: ref.watch(geolocatorProvider),
        ));

@RoutePage()
class MapScreen extends BaseView {
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends BaseViewState<MapScreen, MapViewModel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.initData();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              21.028511,
              105.804817,
            ),
            zoom: 18.0,
          ),
        ),
        Positioned(
          bottom: 16,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            onPressed: () {},
            child: const Text(
              'Start',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement screenName
  String get screenName => MapRoute.name;

  @override
  // TODO: implement viewModel
  MapViewModel get viewModel => ref.read(_provider.notifier);

  MapState get state => ref.watch(_provider);
}
