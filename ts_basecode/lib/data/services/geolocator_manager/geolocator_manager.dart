import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class GeolocatorManager {
  Future<void> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      throw AlwaysPermissionException(
          TextConstants.serviceDisabledExceptionMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        throw AlwaysPermissionException(TextConstants.deniedExceptionMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw AlwaysPermissionException(TextConstants.deniedExceptionMessage);
    }
  }

  Future<bool> checkAlwaysPermission() async {
    await checkPermission();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always) {
      throw AlwaysPermissionException(TextConstants.alwaysExceptionMessage);
    }
    return true;
  }

  Future<Position> getCurrentLocation() async {
    try {
      await checkPermission();
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
        distanceFilter: 4,
      );
      final location = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);
      return location;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Stream<Position>> getActiveCurrentLocationStream() async {
    try {
      await checkPermission();
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
      );
      return Geolocator.getPositionStream(locationSettings: locationSettings);
    } on AlwaysPermissionException {
      rethrow;
    } catch (e) {
      return Future.error(e);
    }
  }
}
