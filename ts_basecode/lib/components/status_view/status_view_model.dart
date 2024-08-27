import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a state notifier for managing the position
class DraggablePositionNotifier extends StateNotifier<Offset> {
  DraggablePositionNotifier() : super(Offset.zero);

  void updatePosition({
    required Offset newPosition,
    required double screenWidth,
    required double screenHeight,
    required double viewSize,
    required double topInset,
  }) {
    double x = newPosition.dx;
    double y = newPosition.dy;

    // Clamp position within screen boundaries, considering the top inset
    x = x.clamp(0.0, screenWidth - viewSize);
    y = y.clamp(0, screenHeight - viewSize - 50);

    state = Offset(x, y);
  }

  void snapToEdge({
    required Offset position,
    required double screenWidth,
    required double screenHeight,
    required double viewSize,
    required double topInset,
  }) {
    const double snapThreshold = 20.0;

    double x = position.dx;
    double y = position.dy;

    if (x <= snapThreshold) {
      x = 0;
    } else if (x >= screenWidth - viewSize - snapThreshold) {
      x = screenWidth - viewSize;
    }

    if (y <= snapThreshold + topInset) {
      y = 0;
    } else if (y >= screenHeight - viewSize - snapThreshold - topInset) {
      y = screenHeight - viewSize - topInset;
    }

    state = Offset(x, y);
  }
}

// Create a provider for the position notifier
final draggablePositionProvider =
    StateNotifierProvider<DraggablePositionNotifier, Offset>((ref) {
  return DraggablePositionNotifier();
});
