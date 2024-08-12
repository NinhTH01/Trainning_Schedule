import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/providers/geolocator_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

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
    super.initState();
    _onInitState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapState get state => ref.watch(_provider);

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          onMapCreated: viewModel.setupGoogleMapController,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              state.currentPosition.latitude,
              state.currentPosition.longitude,
            ),
            zoom: 18.0,
          ),
          markers: {
            Marker(
                markerId: const MarkerId('Id'),
                position: LatLng(
                  state.currentPosition.latitude,
                  state.currentPosition.longitude,
                )),
          },
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
              viewModel.toggleRunning(_showFinishDialog);
            },
            child: Text(
              state.isRunning ? TextConstants.mapStop : TextConstants.mapStart,
              style: const TextStyle(
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
  String get screenName => MapRoute.name;

  @override
  MapViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _onInitState() async {
    Object? error;

    try {
      viewModel.getLocationUpdate();
    } catch (e) {
      error = e;
    }

    if (error != null) {
      handleError(error);
    }
  }

  void _showFinishDialog(
    Uint8List image,
    double distance,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.memory(image)),
              Text('You have run ${distance.toStringAsFixed(2)} meters'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(TextConstants.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
