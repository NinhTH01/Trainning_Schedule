import 'dart:async';
import 'dart:math' as math;

import 'package:background_location/background_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/exception/general_exception/general_exception.dart';
import 'package:ts_basecode/data/models/storage/event/event.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/local_notification_manager/local_notification_manager.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/map/map_state.dart';
import 'package:ts_basecode/screens/map/models/marker_type.dart';
import 'package:ts_basecode/screens/map/models/zoom_mode.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class MapViewModel extends BaseViewModel<MapState> {
  MapViewModel({
    required this.ref,
    required this.geolocatorManager,
    required this.localNotificationManager,
    required this.sqfliteManager,
    required this.sharedPreferencesManager,
    required this.globalMapManager,
  }) : super(const MapState());

  final Ref ref;

  final GeolocatorManager geolocatorManager;

  final LocalNotificationManager localNotificationManager;

  final SqfliteManager sqfliteManager;

  final SharedPreferencesManager sharedPreferencesManager;

  final GlobalRunningStatusManager globalMapManager;

  final double distanceThreshold = 100.0;

  final double distanceMarkerThreshold = 10.0;

  final Size locationMarkersSize = const Size(32, 40);

  final Size currentLocationMarkerSize = const Size(24, 24);

  final double defaultCameraZoom = 16.0;

  final double cameraPadding = 50.0;

  GoogleMapController? _googleMapController;

  StreamSubscription<Position>? _positionStreamSubscription;

  List<MapRouteModel> mapRouteList = [];

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void setupRunningStatusInGlobal(bool runningStatus) {
    globalMapManager.handleUpdateState(isRunning: runningStatus);
  }

  void setupGoogleMapController(GoogleMapController mapController) async {
    _googleMapController = mapController;
  }

  Future<void> checkAlwaysPermission() async {
    await geolocatorManager.checkAlwaysPermission();
  }

  Future<void> getRouteMapList() async {
    mapRouteList = await sqfliteManager.getListRoute();
  }

  Future<void> getLocationUpdate() async {
    if (state.currentPosition == null) {
      _configureBackgroundLocation();

      await geolocatorManager.checkPermissionForMap();

      final currentLocation = await geolocatorManager.getCurrentLocation();

      _googleMapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation.latitude,
              currentLocation.longitude,
            ),
            zoom: defaultCameraZoom,
          ),
        ),
      );

      Stream<Position> activeCurrentLocationStream =
          await geolocatorManager.getActiveCurrentLocationStream();

      _positionStreamSubscription =
          activeCurrentLocationStream.listen((Position? position) async {
        if (position == null || state.isTakingScreenshot) {
          return;
        }

        final updatedLocation = LatLng(
          position.latitude,
          position.longitude,
        );

        state = state.copyWith(
          lastCurrentPosition: state.currentPosition,
          currentPosition: updatedLocation,
        );

        await _handleIconLogic();

        // await _handleMarkerOutsideCamera();

        if (state.isRunning) {
          _handleRunningLogic(updatedLocation);
        }
      });
    }
  }

  Future<void> _handleIconLogic() async {
    _calculateBearing(
      state.lastCurrentPosition,
      state.currentPosition,
    );

    await _updateCurrentLocationMarkerIcon();

    var (finishMarkerList, unfinishedMarkerList) =
        await _updateMarkerToFinish();

    await _updateMarkersForMap(
      finishMarkersCoordinateList: finishMarkerList,
      unfinishedMarkersCoordinateList: unfinishedMarkerList,
    );
  }

  Future<void> _handleRunningLogic(updatedLocation) async {
    _calculateNewDistance(updatedLocation);

    _showNotification();

    _addLocationToPolyline(updatedLocation);
  }

  Future<void> _configureBackgroundLocation() async {
    await BackgroundLocation.setAndroidNotification(
      title: TextConstants.appName,
      message: TextConstants.trackingLocation,
      icon: "@mipmap/ic_launcher",
    );

    // Set the location update interval to 5 seconds
    BackgroundLocation.setAndroidConfiguration(5000);
    BackgroundLocation.stopLocationService();
    //To ensure that previously started services have been stopped, if desired
    BackgroundLocation.startLocationService();
  }

  /// Action handle
  Future<void> toggleRunning() async {
    final isRunning = state.isRunning;

    if (isRunning) {
      state = state.copyWith(
        polylines: {},
        polylineCoordinateList: [],
        totalDistance: 0.0,
        distanceCoveredSinceLastNotification: 0.0,
        distanceThresholdPassCounter: 1,
      );

      globalMapManager.handleUpdateState(
        totalDistance: 0,
      );
    } else {
      globalMapManager.handleUpdateState(
        isRunning: true,
      );

      final currentLocation = await geolocatorManager.getCurrentLocation();

      _handleRunningLogic(
        LatLng(
          currentLocation.latitude,
          currentLocation.longitude,
        ),
      );
    }
    state = state.copyWith(isRunning: !state.isRunning);
  }

  Future<void> addEventToDatabase() async {
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

  void _addLocationToPolyline(LatLng updatedLocation) {
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

  Future<(Uint8List image, double distance, void Function() onClose)>
      takeScreenshot() async {
    state = state.copyWith(isTakingScreenshot: true);
    if (_googleMapController != null) {
      await _setCameraToPolylineBounds();
      await Future.delayed(const Duration(seconds: 1));
      final image = await _googleMapController!.takeSnapshot();
      if (image != null) {
        return (
          image,
          state.totalDistance,
          () {
            state = state.copyWith(isTakingScreenshot: false);
            _moveCamera();
          }
        );
      }
      throw GeneralException("Can't get the image.");
    }
    throw GeneralException("Can't get map controller.");
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

  LatLngBounds? _calculateBoundsForMarkers() {
    var markers = state.locationMarkers;

    if (state.locationMarkers.isNotEmpty) {
      var southWestLat = markers.first.position.latitude;
      var southWestLng = markers.first.position.longitude;
      var northEastLat = markers.first.position.latitude;
      var northEastLng = markers.first.position.longitude;

      for (var marker in markers) {
        if (marker.position.latitude < southWestLat) {
          southWestLat = marker.position.latitude;
        }
        if (marker.position.longitude < southWestLng) {
          southWestLng = marker.position.longitude;
        }
        if (marker.position.latitude > northEastLat) {
          northEastLat = marker.position.latitude;
        }
        if (marker.position.longitude > northEastLng) {
          northEastLng = marker.position.longitude;
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
    if (_googleMapController != null) {
      var bounds = _calculateBoundsForPolylines(state.polylineCoordinateList);

      if (bounds != null) {
        var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, cameraPadding);
        await _googleMapController!.animateCamera(cameraUpdate);
      }
    } else {
      throw GeneralException('Controller is null in set camera to polyline.');
    }
  }

  void _moveCamera() {
    if (_googleMapController != null && state.currentPosition != null) {
      _googleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.currentPosition!,
            zoom: state.zoomValue,
          ),
        ),
      );
    } else {
      throw GeneralException('Controller is null in camera move.');
    }
  }

  void animatedCamera() {
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.currentPosition!,
            zoom: state.zoomValue,
          ),
        ),
      );
    } else {
      throw GeneralException('Controller is null in camera move.');
    }
  }

  void updateZoomMode() async {
    ZoomMode newZoomMode;
    double newZoomValue = state.zoomValue;

    switch (state.zoomMode) {
      case ZoomMode.polyline:
        newZoomMode = ZoomMode.normal;

        state = state.copyWith(
          zoomValue: defaultCameraZoom,
          zoomMode: newZoomMode,
        );
        _moveCamera();

      case ZoomMode.normal:
        newZoomMode = ZoomMode.marker;

        if (state.locationMarkers.length > 1) {
          var bounds = _calculateBoundsForMarkers();

          if (bounds != null) {
            var cameraUpdate =
                CameraUpdate.newLatLngBounds(bounds, cameraPadding);
            _googleMapController!.moveCamera(cameraUpdate).then((_) async {
              newZoomValue = await _googleMapController!.getZoomLevel();
              state = state.copyWith(
                zoomValue: newZoomValue,
                zoomMode: newZoomMode,
              );
            });
          }
        } else {
          state = state.copyWith(
            zoomMode: newZoomMode,
          );
        }

      case ZoomMode.marker:
        if (state.isRunning) {
          newZoomMode = ZoomMode.polyline;

          var bounds =
              _calculateBoundsForPolylines(state.polylineCoordinateList);

          if (bounds != null) {
            var cameraUpdate =
                CameraUpdate.newLatLngBounds(bounds, cameraPadding);
            _googleMapController!.moveCamera(cameraUpdate).then((_) async {
              newZoomValue = await _googleMapController!.getZoomLevel();
              state = state.copyWith(
                zoomValue: newZoomValue,
                zoomMode: newZoomMode,
              );
            });
          }
        } else {
          newZoomMode = ZoomMode.normal;
          state = state.copyWith(
            zoomValue: defaultCameraZoom,
            zoomMode: newZoomMode,
          );
          _moveCamera();
        }
    }
  }

  // Future<void> _handleMarkerOutsideCamera() async {
  //   if (_googleMapController == null) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     _handleMarkerOutsideCamera();
  //   }
  //   final bounds = await _googleMapController!.getVisibleRegion();
  //   final isInside =
  //       bounds.northeast.latitude >= state.currentPosition!.latitude &&
  //           bounds.southwest.latitude <= state.currentPosition!.latitude &&
  //           bounds.northeast.longitude >= state.currentPosition!.longitude &&
  //           bounds.southwest.longitude <= state.currentPosition!.longitude;
  //   if (isInside == false) {
  //     _moveCamera();
  //   }
  // }

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
      globalMapManager.handleUpdateState(
        totalDistance: state.totalDistance,
      );
    }
  }

  Future<(bool achieved, double totalDistance)>
      checkAndCalculateToShowAchievement() async {
    List<Event> eventList = await sqfliteManager.getList();

    double totalDistance = 0.0;

    for (var item in eventList) {
      totalDistance += item.distance ?? 0;
    }

    final hasAchieved = await sharedPreferencesManager.getAchievement();
    if (!hasAchieved && totalDistance > 100.0) {
      await sharedPreferencesManager.setAchievement(value: true);
      return (true, totalDistance);
    }
    return (false, 0.0);
  }

  /// Angle Direction handle
  void _calculateBearing(LatLng? startPoint, LatLng? endPoint) {
    if (startPoint == null || endPoint == null) {
      return;
    }

    final double startLat = _toRadians(startPoint.latitude);
    final double startLng = _toRadians(startPoint.longitude);
    final double endLat = _toRadians(endPoint.latitude);
    final double endLng = _toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);

    state = state.copyWith(directionAngle: (_toDegrees(bearing) + 360) % 360);

    return;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  double _toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  /// Marker handle

  Future<void> _updateCurrentLocationMarkerIcon() async {
    String path;
    if (state.directionAngle > 0 && state.directionAngle < 180) {
      path = Assets.images.markerRight.path;
    } else {
      path = Assets.images.markerLeft.path;
    }
    state = state.copyWith(
        iconCurrentLocationMarker: await BitmapDescriptor.asset(
      ImageConfiguration(size: currentLocationMarkerSize),
      path,
    ));
  }

  Future<void> _updateMarkersForMap({
    required List<LatLng> unfinishedMarkersCoordinateList,
    required List<LatLng> finishMarkersCoordinateList,
  }) async {
    Set<Marker> markers = {};

    /// Unfinished Markers
    for (LatLng location in unfinishedMarkersCoordinateList) {
      Marker marker = Marker(
          markerId: MarkerId(location.longitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: await BitmapDescriptor.asset(
              ImageConfiguration(size: locationMarkersSize),
              Assets.images.locationMarker.path),
          onTap: () {
            _removeMarker(
              location: location,
              markerType: MarkerType.schedule,
            );
          });
      markers.add(marker);
    }

    /// Finish Markers
    for (LatLng location in finishMarkersCoordinateList) {
      Marker marker = Marker(
          markerId: MarkerId(location.longitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: await BitmapDescriptor.asset(
              ImageConfiguration(size: locationMarkersSize),
              Assets.images.finishMarker.path),
          onTap: () {
            _removeMarker(
              location: location,
              markerType: MarkerType.finish,
            );
          });
      markers.add(marker);
    }

    /// Current Location Marker
    Marker currentMarker = Marker(
      markerId: const MarkerId('Id'),
      position: LatLng(
        state.currentPosition!.latitude,
        state.currentPosition!.longitude,
      ),
      icon: state.iconCurrentLocationMarker ?? BitmapDescriptor.defaultMarker,
      rotation: state.directionAngle - 90,
      anchor: const Offset(0.5, 0.5),
    );
    markers.add(currentMarker);

    state = state.copyWith(
        locationMarkers: markers,
        finishMarkersCoordinateList: finishMarkersCoordinateList,
        unfinishedMarkersCoordinateList: unfinishedMarkersCoordinateList);
  }

  Future<(List<LatLng>, List<LatLng>)> _updateMarkerToFinish() async {
    List<LatLng> finishMarkerList =
        List.from(state.finishMarkersCoordinateList);
    List<LatLng> unfinishedMarkerList =
        List.from(state.unfinishedMarkersCoordinateList);

    if (state.isRunning) {
      for (LatLng location in state.unfinishedMarkersCoordinateList) {
        double distanceInMeters = Geolocator.distanceBetween(
          state.currentPosition!.latitude,
          state.currentPosition!.longitude,
          location.latitude,
          location.longitude,
        );
        if (distanceInMeters < distanceMarkerThreshold) {
          finishMarkerList.add(location);
          unfinishedMarkerList.remove(location);
        }
      }
    }

    return (finishMarkerList, unfinishedMarkerList);
  }

  void createUnfinishedMarker(LatLng location) {
    var unfinishedMarkerList = List.from(state.unfinishedMarkersCoordinateList);

    _updateMarkersForMap(
        unfinishedMarkersCoordinateList: [...unfinishedMarkerList, location],
        finishMarkersCoordinateList: state.finishMarkersCoordinateList);
  }

  void createUnfinishedMarkerFromMapRoute(MapRouteModel mapRoute) {
    List<LatLng> markerLocationList = mapRoute.markerLocations!.map((location) {
      return LatLng(
        location.latitude,
        location.longitude,
      );
    }).toList();

    _updateMarkersForMap(
        unfinishedMarkersCoordinateList: markerLocationList,
        finishMarkersCoordinateList: []);
  }

  void _removeMarker({
    required LatLng location,
    required MarkerType markerType,
  }) {
    List<LatLng> finishMarkerList =
        List.from(state.finishMarkersCoordinateList);
    List<LatLng> unfinishedMarkerList =
        List.from(state.unfinishedMarkersCoordinateList);

    if (markerType == MarkerType.schedule) {
      unfinishedMarkerList.remove(location);
    }

    if (markerType == MarkerType.finish) {
      finishMarkerList.remove(location);
    }

    _updateMarkersForMap(
      unfinishedMarkersCoordinateList: unfinishedMarkerList,
      finishMarkersCoordinateList: finishMarkerList,
    );
  }
}
