import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/status_view/status_view_model.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/main/models/main_tab.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class StatusView extends ConsumerWidget {
  const StatusView({
    super.key,
    required this.screenContext,
    this.viewHasSafeArea = false,
  });

  final BuildContext? screenContext;
  final bool viewHasSafeArea;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (screenContext == null) {
      return const SizedBox();
    }

    final topInset = MediaQuery.of(screenContext!).padding.top;
    final botInset = MediaQuery.of(screenContext!).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const double viewWidth = 140;
    const double viewHeight = 60;

    final position = ref.watch(draggablePositionProvider);
    final globalRunningStatusState =
        ref.watch(globalRunningStatusManagerProvider);
    final globalRunningStatusManager =
        ref.watch(globalRunningStatusManagerProvider.notifier);

    if (globalRunningStatusState.isRunning == false) {
      return const SizedBox();
    } else {
      return Positioned(
        left: position.dx,
        top: viewHasSafeArea ? position.dy + topInset : position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            ref.read(draggablePositionProvider.notifier).updatePosition(
                  newPosition: position + details.delta,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  viewWidth: viewWidth,
                  viewHeight: viewHeight,
                  topInset: topInset,
                  bottomInset: botInset,
                );
          },
          onPanEnd: (details) {
            ref.read(draggablePositionProvider.notifier).snapToEdge(
                  position: position,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  viewWidth: viewWidth,
                  viewHeight: viewHeight,
                  topInset: topInset,
                  bottomInset: botInset,
                );
          },
          child: Container(
              height: viewHeight,
              width: viewWidth,
              decoration: BoxDecoration(
                color: ColorName.white,
                borderRadius: _calculateBorderRadius(
                  position: position,
                  topInset: topInset,
                  viewWidth: viewWidth,
                  viewHeight: viewHeight,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ), // Adjust corner radius
                border: Border.all(color: ColorName.black, width: 0.4),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (screenContext?.tabsRouter.activeIndex !=
                            MainTab.map.index) {
                          screenContext?.tabsRouter
                              .setActiveIndex(MainTab.map.index);
                        }
                        globalRunningStatusManager.toggleRunning();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(2.0),
                      ),
                      child: Text(
                        TextConstants.mapStop,
                        style: AppTextStyles.s12w500,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.run_circle_outlined,
                          ),
                          Text(
                            '~${formatDistance(globalRunningStatusState.totalDistance)}',
                            style: AppTextStyles.s12w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    }
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(1)} km";
    } else {
      return "${distanceInMeters.toStringAsFixed(0)} m";
    }
  }

  BorderRadius _calculateBorderRadius({
    required Offset position,
    required double topInset,
    required double viewWidth,
    required double viewHeight,
    required double screenWidth,
    required double screenHeight,
  }) {
    const double radius = 20.0;
    const double snapThreshold = 20.0;

    bool nearLeft = position.dx <= snapThreshold;
    bool nearRight = position.dx >= screenWidth - viewWidth - snapThreshold;
    bool nearTop = position.dy <= snapThreshold;
    bool nearBottom = position.dy >=
        screenHeight - snapThreshold - topInset - tabBarHeight - viewHeight;

    return BorderRadius.only(
      topLeft:
          nearLeft || nearTop ? Radius.zero : const Radius.circular(radius),
      topRight:
          nearRight || nearTop ? Radius.zero : const Radius.circular(radius),
      bottomLeft:
          nearLeft || nearBottom ? Radius.zero : const Radius.circular(radius),
      bottomRight:
          nearRight || nearBottom ? Radius.zero : const Radius.circular(radius),
    );
  }
}
