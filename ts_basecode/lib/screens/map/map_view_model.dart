import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';

class MapViewModel extends BaseViewModel<MapState> {
  MapViewModel({
    required this.ref,
    required this.geolocatorManager,
  }) : super(const MapState());

  final Ref ref;

  final GeolocatorManager geolocatorManager;

  void setupGoogleMapController(GoogleMapController mapController) {
    state = state.copyWith(googleMapController: mapController);
  }

  Future<void> toggleRunning(
    Function(Uint8List, double) onScreenshotCaptured,
  ) async {
    final isRunning = state.isRunning;
    if (isRunning) {
      final newDistance =
          calculatePolylineDistance(state.polylineCoordinateList);

      await _takeScreenshot(onScreenshotCaptured, newDistance);

      state = state.copyWith(
        polylines: {},
        polylineCoordinateList: [],
      );
    }
    state = state.copyWith(isRunning: !state.isRunning);
  }

  Future<void> getLocationUpdate() async {
    Stream<Position> activeCurrentLocationStream =
        await geolocatorManager.getActiveCurrentLocationStream();

    activeCurrentLocationStream.listen((Position? position) {
      if (position != null) {
        final updatedLocation = LatLng(position.latitude, position.longitude);

        state = state.copyWith(
          currentPosition: updatedLocation,
        );

        _moveCamera(updatedLocation);

        _drawPolyline(updatedLocation);
      }
    });
  }

  void _moveCamera(LatLng updatedLocation) {
    final controller = state.googleMapController;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: updatedLocation,
            zoom: 18.0,
          ),
        ),
      );
    }
  }

  void _drawPolyline(LatLng updatedLocation) {
    if (state.isRunning) {
      state = state.copyWith(
        polylineCoordinateList: List.from(state.polylineCoordinateList)
          ..add(updatedLocation),
        polylines: {
          Polyline(
            polylineId: const PolylineId('polyline'),
            visible: true,
            points: List.from(state.polylineCoordinateList)
              ..add(updatedLocation),
            color: ColorName.blue,
            width: 4,
          ),
        },
      );
    }
  }

  Future<void> _setCameraToPolylineBounds() async {
    final controller = state.googleMapController;
    if (controller != null) {
      var bounds = _calculateBoundsForPolylines(state.polylineCoordinateList);

      var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
      await controller.animateCamera(cameraUpdate);
    }
  }

  LatLngBounds _calculateBoundsForPolylines(List<LatLng> points) {
    var southWestLat = points[0].latitude;
    var southWestLng = points[0].longitude;
    var northEastLat = points[0].latitude;
    var northEastLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < southWestLat) {
        southWestLat = point.latitude;
      }
      if (point.longitude < southWestLng) {
        southWestLng = point.longitude;
      }
      if (point.latitude > northEastLat) {
        northEastLat = point.latitude;
      }
      if (point.longitude > northEastLng) {
        northEastLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  Future<void> _takeScreenshot(
    Function(Uint8List, double) onScreenshotCaptured,
    double distance,
  ) async {
    final controller = state.googleMapController;
    if (controller != null) {
      await _setCameraToPolylineBounds();
      await Future.delayed(const Duration(seconds: 1));
      final image = await controller.takeSnapshot();
      if (image != null) {
        onScreenshotCaptured(image, distance);
      }
    }
  }

  double calculatePolylineDistance(List<LatLng> polylinePoints) {
    var totalDistance = 0.0;

    for (var i = 0; i < polylinePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        polylinePoints[i].latitude,
        polylinePoints[i].longitude,
        polylinePoints[i + 1].latitude,
        polylinePoints[i + 1].longitude,
      );
    }

    return totalDistance;
  }
}
