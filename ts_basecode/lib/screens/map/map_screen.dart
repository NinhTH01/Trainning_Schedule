import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/providers/geolocator_provider.dart';
import 'package:ts_basecode/providers/local_notification_provider.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/map_view_model.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider = StateNotifierProvider.autoDispose<MapViewModel, MapState>(
    (ref) => MapViewModel(
          ref: ref,
          geolocatorManager: ref.watch(geolocatorProvider),
          localNotificationManager: ref.watch(localNotificationProvider),
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
    viewModel.updateMarker();
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

  MapState get state => ref.watch(_provider);

  @override
  String get screenName => MapRoute.name;

  @override
  MapViewModel get viewModel => ref.read(_provider.notifier);

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

  Future<void> _showFinishDialog({
    required Uint8List image,
    required double distance,
    required void Function() onClose,
  }) async {
    showDialog(
      barrierDismissible: false,
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
                onClose();
              },
            ),
          ],
        );
      },
    );
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
          markers: {
            Marker(
              markerId: const MarkerId('Id'),
              position: LatLng(
                state.currentPosition?.latitude ?? 0,
                state.currentPosition?.longitude ?? 0,
              ),
              icon: state.mapMarker ?? BitmapDescriptor.defaultMarker,
              rotation: state.directionAngle - 90,
              anchor: const Offset(0.5, 0.5),
            )
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
}
