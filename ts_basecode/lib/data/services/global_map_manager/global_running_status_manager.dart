import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';

class GlobalRunningStatusManager
    extends StateNotifier<GlobalRunningStatusState> {
  GlobalRunningStatusManager({
    required this.ref,
  }) : super(const GlobalRunningStatusState());

  final Ref ref;

  void handleUpdateState({
    double? totalDistance,
    bool? isRunning,
  }) {
    state = state.copyWith(
      totalDistance: totalDistance ?? state.totalDistance,
      isRunning: isRunning ?? state.isRunning,
    );
  }

  void toggleRunning() {
    state = state.copyWith(isRunning: !state.isRunning);
  }
}
