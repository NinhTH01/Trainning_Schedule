import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_map_manager_state.dart';

class GlobalMapManager extends StateNotifier<GlobalMapManagerState> {
  GlobalMapManager({
    required this.ref,
  }) : super(const GlobalMapManagerState());

  final Ref ref;

  void handleUpdateState({
    double? totalDistance,
    bool? isRunning,
  }) {
    state = state.copyWith(
        totalDistance: totalDistance ?? state.totalDistance,
        isRunning: isRunning ?? state.isRunning);
  }

  void toggleRunning() {
    state = state.copyWith(isRunning: !state.isRunning);
  }
}
