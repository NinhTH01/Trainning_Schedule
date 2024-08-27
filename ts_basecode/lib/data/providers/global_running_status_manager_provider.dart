import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';

final globalRunningStatusManagerProvider =
    StateNotifierProvider<GlobalRunningStatusManager, GlobalRunningStatusState>(
        (ref) {
  return GlobalRunningStatusManager(
    ref: ref,
  );
});
