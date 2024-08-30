import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';
import 'package:ts_basecode/data/models/exception/general_exception/general_exception.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class GeolocatorManager {
  Future<void> checkPermissionForMap() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      PermissionStatus status = await Permission.locationAlways.request();
      if (status == PermissionStatus.permanentlyDenied) {
        throw (AlwaysPermissionException(TextConstants.alwaysExceptionMessage));
      }
    }
    return;
  }

  Future<void> checkAlwaysPermission() async {
    PermissionStatus status = await Permission.locationAlways.request();
    if (status == PermissionStatus.permanentlyDenied) {
      throw (AlwaysPermissionException(TextConstants.alwaysExceptionMessage));
    }
  }

  Future<void> checkPermissionForWeather() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status.isGranted) {
      return;
    } else {
      throw (GeneralException(TextConstants.deniedExceptionMessage));
    }
  }

  Future<Position> getCurrentLocation() async {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
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
