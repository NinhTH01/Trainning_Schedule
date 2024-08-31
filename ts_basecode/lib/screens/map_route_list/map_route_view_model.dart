import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';
import 'package:ts_basecode/screens/map_route_list/map_route_state.dart';

class MapRouteViewModel extends BaseViewModel<MapRouteState> {
  MapRouteViewModel({
    required this.globalMapManager,
    required this.sqfliteManager,
  }) : super(const MapRouteState());

  final GlobalRunningStatusManager globalMapManager;

  final SqfliteManager sqfliteManager;

  Future<void> getMapRouteList() async {
    List<MapRouteModel> mapRouteList = await sqfliteManager.getListRoute();

    state = state.copyWith(
      mapRouteList: mapRouteList,
    );
  }
}
