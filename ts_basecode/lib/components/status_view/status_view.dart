import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/status_view/status_view_model.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class StatusView extends ConsumerWidget {
  const StatusView({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.distance,
    required this.onPress,
  });

  final double screenWidth;
  final double screenHeight;
  final double distance;
  final Function() onPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the top inset
    final topInset = MediaQuery.of(context).padding.top;

    const double viewSize = 140;

    // Watch the position state
    final position = ref.watch(draggablePositionProvider);

    return Positioned(
      left: position.dx,
      top: position.dy + topInset, // Adjust position by top inset
      child: GestureDetector(
        onPanUpdate: (details) {
          ref.read(draggablePositionProvider.notifier).updatePosition(
                position + details.delta,
                screenWidth,
                screenHeight,
                viewSize,
                topInset,
              );
        },
        onPanEnd: (details) {
          ref.read(draggablePositionProvider.notifier).snapToEdge(
                position,
                screenWidth,
                screenHeight,
                viewSize,
                topInset,
              );
        },
        child: Container(
            width: viewSize,
            decoration: BoxDecoration(
              color: ColorName.white50,
              borderRadius: _calculateBorderRadius(
                  position, topInset, viewSize), // Adjust corner radius
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
                    onPressed: onPress,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(2.0),
                    ),
                    child: Text(
                      TextConstants.mapStop,
                      style: AppTextStyles.s12w500,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.run_circle_outlined,
                      ),
                      Text(
                        '~${formatDistance(distance)}',
                        style: AppTextStyles.s12w500,
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(1)} km";
    } else {
      return "${distanceInMeters.toStringAsFixed(0)} m";
    }
  }

  BorderRadius _calculateBorderRadius(
      Offset position, double topInset, double viewSize) {
    const double radius = 20.0;
    const double snapThreshold = 20.0;

    bool nearLeft = position.dx <= snapThreshold;
    bool nearRight = position.dx >= screenWidth - viewSize - snapThreshold;
    bool nearTop = position.dy <= snapThreshold + topInset;

    return BorderRadius.only(
      topLeft:
          nearLeft || nearTop ? Radius.zero : const Radius.circular(radius),
      topRight:
          nearRight || nearTop ? Radius.zero : const Radius.circular(radius),
      bottomLeft: nearLeft ? Radius.zero : const Radius.circular(radius),
      bottomRight: nearRight ? Radius.zero : const Radius.circular(radius),
    );
  }
}
