import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

const tabBarHeight = 80;

class DraggablePositionNotifier extends StateNotifier<Offset> {
  DraggablePositionNotifier() : super(Offset.zero);

  void updatePosition({
    required Offset newPosition,
    required double screenWidth,
    required double screenHeight,
    required double viewWidth,
    required double viewHeight,
    required double topInset,
    required double bottomInset,
  }) {
    double x = newPosition.dx;
    double y = newPosition.dy;

    x = x.clamp(
      0.0,
      screenWidth - viewWidth,
    );
    y = y.clamp(
      0.0,
      screenHeight - topInset - viewHeight - bottomInset - tabBarHeight,
    );

    state = Offset(x, y);
  }

  void snapToEdge({
    required Offset position,
    required double screenWidth,
    required double screenHeight,
    required double viewWidth,
    required double viewHeight,
    required double topInset,
    required double bottomInset,
  }) {
    const double snapThreshold = 20.0;

    double x = position.dx;
    double y = position.dy;

    if (x <= snapThreshold) {
      x = 0;
    } else if (x >= screenWidth - viewWidth - snapThreshold) {
      x = screenWidth - viewWidth;
    }

    if (y <= snapThreshold) {
      y = 0;
    } else if (y >=
        screenHeight -
            viewHeight -
            tabBarHeight -
            snapThreshold -
            topInset -
            bottomInset) {
      y = screenHeight - viewHeight - tabBarHeight - topInset - bottomInset;
    }

    state = Offset(x, y);
  }
}

// Create a provider for the position notifier
final draggablePositionProvider =
    StateNotifierProvider<DraggablePositionNotifier, Offset>((ref) {
  return DraggablePositionNotifier();
});
