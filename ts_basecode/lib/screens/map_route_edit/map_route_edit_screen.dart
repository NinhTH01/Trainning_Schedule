import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/components/screen_header/screen_header.dart';
import 'package:ts_basecode/data/models/storage/map_route/map_route_model.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/map_route_repository_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/map_route_edit/components/route_item.dart';
import 'package:ts_basecode/screens/map_route_edit/map_route_edit_state.dart';
import 'package:ts_basecode/screens/map_route_edit/map_route_edit_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

final _provider =
    StateNotifierProvider.autoDispose<MapRouteEditViewModel, MapRouteEditState>(
  (ref) => MapRouteEditViewModel(
    globalMapManager: ref.watch(globalRunningStatusManagerProvider.notifier),
    mapRouteRepository: ref.watch(mapRouteRepositoryProvider),
  ),
);

@RoutePage()
class MapRouteEditScreen extends BaseView {
  const MapRouteEditScreen({
    super.key,
    required this.isEdit,
    required this.mapRoute,
  });

  final bool isEdit;

  final MapRouteModel? mapRoute;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapRouteEditScreen();
}

class _MapRouteEditScreen
    extends BaseViewState<MapRouteEditScreen, MapRouteEditViewModel> {
  @override
  void onInitState() async {
    super.onInitState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onInitState();
    });
  }

  Future<void> _onInitState() async {
    try {
      await viewModel.initData(
        mapRoute: widget.mapRoute,
      );
    } catch (e) {
      handleError(e);
    }
  }

  void handleGoToMapScreen() async {
    await AutoRouter.of(context)
        .push(MapRouteMapRoute(
      markerLocationList: state.markerLocationList,
    ))
        .then((value) {
      viewModel.updateMarkerLocation(value);
    });
  }

  @override
  BuildContext get statusViewContext => context;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  MapRouteEditState get state => ref.watch(_provider);

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => MapRouteEditRoute.name;

  @override
  MapRouteEditViewModel get viewModel => ref.read(_provider.notifier);

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext modalContext) => CupertinoActionSheet(
        title: const Text(TextConstants.deleteEvent),
        message: const Text(TextConstants.confirmToProceed),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              await viewModel.handleDeleteDatabase(
                isEdit: widget.isEdit,
                editMapRoute: widget.mapRoute,
              );
              if (context.mounted) {
                Navigator.pop(modalContext);
                Navigator.pop(context);
              }
            },
            child: const Text(TextConstants.confirm),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(modalContext);
            },
            child: const Text(TextConstants.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return widget.isEdit
        ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorName.red,
            ),
            child: IconButton(
              onPressed: () {
                _showActionSheet(context);
              },
              icon: const Icon(Icons.delete_outline_outlined),
              color: ColorName.white,
            ),
          )
        : const SizedBox();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        ScreenHeader(
          title: widget.isEdit
              ? TextConstants.mapRouteEdit
              : TextConstants.mapRouteCreate,
          onBack: () {
            Navigator.pop(context);
          },
          rightWidget: TextButton(
              onPressed: () async {
                await viewModel.handleUpdateDatabase(
                  isEdit: widget.isEdit,
                  editMapRoute: widget.mapRoute,
                  context: context,
                );
              },
              child: Text(
                widget.isEdit ? TextConstants.edit : TextConstants.save,
                style: AppTextStyles.s16w500,
              )),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: viewModel.nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: TextConstants.name,
                    errorText: state.emptyNameValidate
                        ? TextConstants.emptyNameValidate
                        : null,
                  ),
                  onChanged: ((_) {
                    if (viewModel.nameController.text.isNotEmpty) {
                      viewModel.updateEmptyNameValidate(false);
                    }
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: viewModel.descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: TextConstants.description,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        TextConstants.route,
                        style: AppTextStyles.s16w500,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        handleGoToMapScreen();
                      },
                      icon: const Icon(Icons.add_circle_outline_outlined),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.5,
                color: ColorName.black,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: state.markerLocationList.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (BuildContext context, int index) {
                    return RouteItem(
                      key: Key('$index'),
                      name: index + 1,
                      location: state.markerLocationList[index],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
