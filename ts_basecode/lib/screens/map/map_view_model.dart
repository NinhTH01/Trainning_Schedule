import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/data/services/local_notification_manager/local_notification_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/models/marker_type.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class MapViewModel extends BaseViewModel<MapState> {
  MapViewModel({
    required this.ref,
    required this.geolocatorManager,
    required this.localNotificationManager,
    required this.sqfliteManager,
  }) : super(const MapState());

  final Ref ref;

  final GeolocatorManager geolocatorManager;

  final LocalNotificationManager localNotificationManager;

  final SqfliteManager sqfliteManager;

  final double distanceThreshold = 100.0;

  final double distanceMarkerThreshold = 10.0;

  final int markerSize = 20;

  final double defaultCameraZoom = 18.0;

  void setupGoogleMapController(GoogleMapController mapController) {
    state = state.copyWith(googleMapController: mapController);
  }

  Future<void> getLocationUpdate() async {
    try {
      if (await geolocatorManager.checkAlwaysPermission() &&
          state.currentPosition == null) {
        Stream<Position> activeCurrentLocationStream =
            await geolocatorManager.getActiveCurrentLocationStream();

        activeCurrentLocationStream.listen((Position? position) async {
          if (position != null && !state.isTakingScreenshot) {
            final updatedLocation =
                LatLng(position.latitude, position.longitude);

            state = state.copyWith(
              lastPosition: state.currentPosition,
              currentPosition: updatedLocation,
            );

            if (await _checkIfCameraIsOutsideMarker() == false) {
              _moveCamera(updatedLocation);
            }

            if (state.isRunning) {
              _drawPolyline(updatedLocation);
              updateMarkerToFinish();
            }

            if (state.lastPosition != null && state.currentPosition != null) {
              _calculateBearing(state.lastPosition!, state.currentPosition!);
            }
            updateCurrentLocationMarker();
            _createMarkersFromLocationsBasedOnAngle();
          }
        });
      }
    } on AlwaysPermissionException {
      rethrow;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Action handle

  Future<void> toggleRunning(
    Future<void>? Function({
      required Uint8List image,
      required double distance,
      required void Function() onClose,
    }) onScreenshotCaptured,
  ) async {
    final isRunning = state.isRunning;

    if (isRunning) {
      _addEventToDatabase();
      await _takeScreenshot(onScreenshotCaptured, state.totalDistance);

      state = state.copyWith(
        polylines: {},
        polylineCoordinateList: [],
        totalDistance: 0.0,
        distanceCoveredSinceLastNotification: 0.0,
        distanceThresholdPassCounter: 1,
      );
    } else {
      final currentLocation = await geolocatorManager.getCurrentLocation();

      _drawPolyline(
          LatLng(currentLocation.latitude, currentLocation.longitude));
    }
    state = state.copyWith(isRunning: !state.isRunning);
  }

  Future<void> _addEventToDatabase() async {
    var event = Event(
      createdTime: DateTime.now(),
      distance: state.totalDistance,
      description:
          'You have run ${state.totalDistance.toStringAsFixed(2)} meters.',
    );

    await sqfliteManager.insert(event);
  }

  void _showNotification() {
    if (state.distanceCoveredSinceLastNotification >= distanceThreshold) {
      localNotificationManager.showNotification(
          title: TextConstants.appName,
          description:
              'You have run ${distanceThreshold * state.distanceThresholdPassCounter}m');
      state = state.copyWith(
        distanceCoveredSinceLastNotification:
            state.distanceCoveredSinceLastNotification - distanceThreshold,
        distanceThresholdPassCounter: state.distanceThresholdPassCounter + 1,
      );
    }
  }

  void _drawPolyline(LatLng updatedLocation) {
    _calculateNewDistance(updatedLocation);
    _showNotification();
    state = state.copyWith(
      polylineCoordinateList: List.from(state.polylineCoordinateList)
        ..add(updatedLocation),
      polylines: {
        Polyline(
          polylineId: const PolylineId('polyline'),
          visible: true,
          points: List.from(state.polylineCoordinateList)..add(updatedLocation),
          color: ColorName.blue,
          width: 4,
        ),
      },
    );
  }

  Future<void> _takeScreenshot(
    Future<void>? Function({
      required Uint8List image,
      required double distance,
      required void Function() onClose,
    }) onScreenshotCaptured,
    double distance,
  ) async {
    final controller = state.googleMapController;
    state = state.copyWith(isTakingScreenshot: true);
    if (controller != null) {
      await _setCameraToPolylineBounds();
      await Future.delayed(const Duration(seconds: 1));
      final image = await controller.takeSnapshot();
      if (image != null) {
        onScreenshotCaptured(
            image: image,
            distance: distance,
            onClose: () {
              state = state.copyWith(isTakingScreenshot: false);
              _moveCamera(state.currentPosition!);
            });
      }
    }
  }

  /// Camera handle
  LatLngBounds? _calculateBoundsForPolylines(List<LatLng> points) {
    if (points.isNotEmpty) {
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
    return null;
  }

  Future<void> _setCameraToPolylineBounds() async {
    final controller = state.googleMapController;
    if (controller != null) {
      var bounds = _calculateBoundsForPolylines(state.polylineCoordinateList);

      if (bounds != null) {
        var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
        await controller.animateCamera(cameraUpdate);
      }
    }
  }

  Future<bool> _checkIfCameraIsOutsideMarker() async {
    if (state.googleMapController == null) {
      await Future.delayed(const Duration(seconds: 1));
      return _checkIfCameraIsOutsideMarker();
    }
    final bounds = await state.googleMapController!.getVisibleRegion();
    final isInside =
        bounds.northeast.latitude >= state.currentPosition!.latitude &&
            bounds.southwest.latitude <= state.currentPosition!.latitude &&
            bounds.northeast.longitude >= state.currentPosition!.longitude &&
            bounds.southwest.longitude <= state.currentPosition!.longitude;
    return isInside;
  }

  void _moveCamera(LatLng updatedLocation) {
    final controller = state.googleMapController;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: updatedLocation,
            zoom: defaultCameraZoom,
          ),
        ),
      );
    }
  }

  /// Distance handle
  void _calculateNewDistance(newCoordinate) {
    LatLng? lastCoordinate = state.polylineCoordinateList.lastOrNull;

    if (lastCoordinate != null) {
      var distance = Geolocator.distanceBetween(
        newCoordinate!.latitude,
        newCoordinate.longitude,
        lastCoordinate.latitude,
        lastCoordinate.longitude,
      );
      state = state.copyWith(
        totalDistance: state.totalDistance + distance,
        distanceCoveredSinceLastNotification:
            state.distanceCoveredSinceLastNotification + distance,
      );
    }
  }

  Future<double> getTotalDistance() async {
    List<Event> eventList = await sqfliteManager.getList();

    double totalDistance = 0.0;

    for (var item in eventList) {
      totalDistance += item.distance ?? 0;
    }

    return totalDistance;
  }

  /// Angle Direction handle
  void _calculateBearing(LatLng startPoint, LatLng endPoint) {
    final double startLat = toRadians(startPoint.latitude);
    final double startLng = toRadians(startPoint.longitude);
    final double endLat = toRadians(endPoint.latitude);
    final double endLng = toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);

    state = state.copyWith(directionAngle: (toDegrees(bearing) + 360) % 360);
  }

  double toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  double toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  /// Marker handle
  Future<void> updateCurrentLocationMarker() async {
    Uint8List? byteAssets;
    if (state.directionAngle > 0 && state.directionAngle < 180) {
      byteAssets = await getBytesFromAsset(
          path: 'assets/images/marker_right.png', size: markerSize);
    } else {
      byteAssets = await getBytesFromAsset(
          path: 'assets/images/marker_left.png', size: markerSize);
    }
    state = state.copyWith(mapMarker: BitmapDescriptor.bytes(byteAssets!));
  }

  Future<Uint8List?> getBytesFromAsset({
    required String path,
    required int size,
  }) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: size);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  Future<void> _createMarkersFromLocationsBasedOnAngle() async {
    Set<Marker> markers = {};

    for (LatLng location in state.locationMarkersCoordinateList) {
      Uint8List? byteAssets = await getBytesFromAsset(
          path: 'assets/images/location_marker.png', size: 40);
      Marker marker = Marker(
          markerId: MarkerId(location.longitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.bytes(byteAssets!),
          onTap: () {
            removeMarker(location: location, markerType: MarkerType.schedule);
          });
      markers.add(marker);
    }

    for (LatLng location in state.finishMarkersCoordinateList) {
      Uint8List? byteAssets = await getBytesFromAsset(
          path: 'assets/images/finish_marker.png', size: 40);
      Marker marker = Marker(
          markerId: MarkerId(location.longitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.bytes(byteAssets!),
          onTap: () {
            removeMarker(location: location, markerType: MarkerType.finish);
          });
      markers.add(marker);
    }

    Marker currentMarker = Marker(
      markerId: const MarkerId('Id'),
      position: LatLng(
        state.currentPosition?.latitude ?? 0,
        state.currentPosition?.longitude ?? 0,
      ),
      icon: state.mapMarker ?? BitmapDescriptor.defaultMarker,
      rotation: state.directionAngle - 90,
      anchor: const Offset(0.5, 0.5),
    );
    markers.add(currentMarker);

    state = state.copyWith(markers: markers);
  }

  void createScheduleMarker(LatLng location) {
    state = state.copyWith(
      locationMarkersCoordinateList:
          List.from(state.locationMarkersCoordinateList)..add(location),
    );
    _createMarkersFromLocationsBasedOnAngle();
  }

  void updateMarkerToFinish() {
    for (LatLng location in state.locationMarkersCoordinateList) {
      double distanceInMeters = Geolocator.distanceBetween(
        state.currentPosition!.latitude,
        state.currentPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      if (distanceInMeters < distanceMarkerThreshold) {
        state = state.copyWith(
          finishMarkersCoordinateList:
              List.from(state.finishMarkersCoordinateList)..add(location),
          locationMarkersCoordinateList:
              List.from(state.locationMarkersCoordinateList)..remove(location),
        );
        _createMarkersFromLocationsBasedOnAngle();
      }
    }
  }

  void removeMarker({
    required LatLng location,
    required MarkerType markerType,
  }) {
    if (markerType == MarkerType.schedule) {
      state = state.copyWith(
        locationMarkersCoordinateList:
            List.from(state.locationMarkersCoordinateList)..remove(location),
      );
    } else if (markerType == MarkerType.finish) {
      state = state.copyWith(
        finishMarkersCoordinateList:
            List.from(state.finishMarkersCoordinateList)..remove(location),
      );
    }
    _createMarkersFromLocationsBasedOnAngle();
  }
}
