import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/services/geolocator_manager/geolocator_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/resources/gen/assets.gen.dart';
import 'package:ts_basecode/screens/map_route_map/map_route_map_state.dart';

class MapRouteMapViewModel extends BaseViewModel<MapRouteMapState> {
  MapRouteMapViewModel({
    required this.globalMapManager,
    required this.geolocatorManager,
  }) : super(const MapRouteMapState());

  final GlobalRunningStatusManager globalMapManager;

  final GeolocatorManager geolocatorManager;

  GoogleMapController? _googleMapController;

  Size locationMarkersSize = const Size(32, 40);

  void onInitMap(GoogleMapController controller) {
    _googleMapController = controller;
  }

  Future<void> updateData(List<LatLng> markerLocationList) async {
    LatLng currentLocation = await _getCurrentLocation();

    _moveCamera(currentLocation);

    state = state.copyWith(
      currentLocation: currentLocation,
    );

    _updateMarkerOnMap(markerLocationList: markerLocationList);
  }

  Future<LatLng> _getCurrentLocation() async {
    await geolocatorManager.checkPermissionWithoutAlwaysRequired();
    Position currentLocation = await geolocatorManager.getCurrentLocation();

    return LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );
  }

  void _moveCamera(LatLng currentLocation) {
    if (_googleMapController != null) {
      _googleMapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation.latitude,
              currentLocation.longitude,
            ),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  Future<Set<Marker>> addMarker(
    LatLng markerLocation,
  ) async {
    List<LatLng> markerLocationList = List.from(state.markerLocationList);

    markerLocationList.add(markerLocation);

    return await _updateMarkerOnMap(markerLocationList: markerLocationList);
  }

  void _removeMarker(
    LatLng location,
  ) async {
    List<LatLng> markerLocationList = List.from(state.markerLocationList);

    markerLocationList.remove(location);

    await _updateMarkerOnMap(markerLocationList: markerLocationList);
  }

  void removeAllMarkers() async {
    await _updateMarkerOnMap(markerLocationList: []);
  }

  Future<Set<Marker>> _updateMarkerOnMap({
    required List<LatLng> markerLocationList,
  }) async {
    Set<Marker> markers = {};
    for (LatLng location in markerLocationList) {
      Marker marker = Marker(
          markerId: MarkerId(location.longitude.toString()),
          position: LatLng(location.latitude, location.longitude),
          icon: await BitmapDescriptor.asset(
              ImageConfiguration(size: locationMarkersSize),
              Assets.images.locationMarker.path),
          onTap: () {
            _removeMarker(
              location,
            );
          });
      markers.add(marker);
    }

    state = state.copyWith(
      markers: markers,
      markerLocationList: markerLocationList,
    );

    return markers;
  }
}
