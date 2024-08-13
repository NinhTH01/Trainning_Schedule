import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';

final geolocatorProvider =
    Provider<GeolocatorManager>((ref) => GeolocatorManager());
