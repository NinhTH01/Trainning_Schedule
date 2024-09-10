import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/coordinate/coordinate.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/repositories/storage/map_route/map_route_repository.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/screens/map_route_edit/map_route_edit_state.dart';

class MapRouteEditViewModel extends BaseViewModel<MapRouteEditState> {
  MapRouteEditViewModel({
    required this.globalMapManager,
    required this.mapRouteRepository,
  }) : super(const MapRouteEditState());

  final GlobalRunningStatusManager globalMapManager;

  final MapRouteRepository mapRouteRepository;

  final double defaultCameraZoom = 16.0;

  final Size locationMarkersSize = const Size(32, 40);

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  Future<void> initData({
    required MapRouteModel? mapRoute,
  }) async {
    if (mapRoute == null) {
      return;
    }
    List<LatLng>? markerLocationList = mapRoute.markerLocations?.map((item) {
      return LatLng(
        item.latitude!,
        item.longitude!,
      );
    }).toList();

    state = state.copyWith(
      markerLocationList: markerLocationList ?? [],
    );
    nameController = TextEditingController(text: mapRoute.name);
    descriptionController = TextEditingController(text: mapRoute.description);
  }

  void updateMarkerLocation(markerLocationList) async {
    state = state.copyWith(
      markerLocationList: markerLocationList,
    );
  }

  void updateEmptyNameValidate(bool value) {
    state = state.copyWith(
      emptyNameValidate: value,
    );
  }

  Future<void> handleUpdateDatabase({
    required bool isEdit,
    required MapRouteModel? editMapRoute,
    required BuildContext context,
  }) async {
    if (nameController.text.isEmpty) {
      updateEmptyNameValidate(true);
      return;
    } else {
      MapRouteModel mapRoute = MapRouteModel(
        id: editMapRoute?.id,
        name: nameController.text,
        description: descriptionController.text,
        markerLocations: [],
        orderIndex: 0,
      );

      List<Coordinate> list = state.markerLocationList.map((value) {
        return Coordinate(
          latitude: value.latitude,
          longitude: value.longitude,
        );
      }).toList();

      if (isEdit) {
        await mapRouteRepository.update(
          coordinates: list,
          mapRoute: mapRoute,
        );
      } else {
        await mapRouteRepository.insert(
          coordinates: list,
          mapRoute: mapRoute,
        );
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> handleDeleteDatabase({
    required bool isEdit,
    required MapRouteModel? editMapRoute,
  }) async {
    if (editMapRoute == null) {
      return;
    }

    if (isEdit) {
      MapRouteModel mapRoute = MapRouteModel(
        id: editMapRoute.id,
      );
      await mapRouteRepository.delete(
        mapRoute,
      );
    }
  }
}
