import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/screen_header/screen_header.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map_route_list/components/map_route_item.dart';
import 'package:ts_basecode/screens/map_route_list/map_route_state.dart';
import 'package:ts_basecode/screens/map_route_list/map_route_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<MapRouteViewModel, MapRouteState>(
  (ref) => MapRouteViewModel(
    globalMapManager: ref.watch(globalRunningStatusManagerProvider.notifier),
    sqfliteManager: ref.watch(sqfliteProvider),
  ),
);

@RoutePage()
class MapRouteListScreen extends BaseView {
  const MapRouteListScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapRouteListScreen();
}

class _MapRouteListScreen
    extends BaseViewState<MapRouteListScreen, MapRouteViewModel> {
  @override
  void onInitState() async {
    super.onInitState();
    _onInitState();
  }

  Future<void> _onInitState() async {
    try {
      await viewModel.getMapRouteList();
    } catch (e) {
      handleError(e);
    }
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapRouteState get state => ref.watch(_provider);

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => MapRouteListRoute.name;

  @override
  MapRouteViewModel get viewModel => ref.read(_provider.notifier);

  Future<void> _handleGoToMapRouteEditScreen({
    required bool isEdit,
    MapRouteModel? mapRoute,
  }) async {
    await AutoRouter.of(context)
        .push(MapRouteEditRoute(
      isEdit: isEdit,
      mapRoute: mapRoute,
    ))
        .then((_) {
      viewModel.getMapRouteList();
    });
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorName.red,
      ),
      child: IconButton(
        onPressed: () {
          _handleGoToMapRouteEditScreen(isEdit: false);
        },
        icon: const Icon(Icons.add),
        color: ColorName.white,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ScreenHeader(
              hasBackIcon: false,
              title: TextConstants.mapRouteList,
              onBack: () {
                Navigator.pop(context);
              },
              rightWidget: TextButton(
                onPressed: () {
                  viewModel.handleEdit();
                },
                child: Text(
                  state.isEditing ? TextConstants.save : TextConstants.edit,
                  style: AppTextStyles.s14w400,
                ),
              ),
            ),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(_provider);
                await viewModel.getMapRouteList();
              },
              child: ReorderableListView.builder(
                buildDefaultDragHandles: state.isEditing,
                itemCount: state.mapRouteList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MapRouteItem(
                    key: Key('$index'),
                    mapRoute: state.mapRouteList[index],
                    onPress: () {
                      _handleGoToMapRouteEditScreen(
                        isEdit: true,
                        mapRoute: state.mapRouteList[index],
                      );
                    },
                    isEditing: state.isEditing,
                  );
                },
                onReorder: viewModel.handleReorder,
              ),
            )),
          ],
        ),
        StatusView(
          isVisible: globalMapState.isRunning,
          distance: globalMapState.totalDistance,
          onPress: () async {
            context.tabsRouter.setActiveIndex(1);
            viewModel.globalMapManager.toggleRunning();
          },
        ),
      ],
    );
  }
}
