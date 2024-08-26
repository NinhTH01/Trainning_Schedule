import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_map_manager.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_map_manager_state.dart';

final globalMapManagerProvider =
    StateNotifierProvider<GlobalMapManager, GlobalMapManagerState>((ref) {
  return GlobalMapManager(ref: ref);
});
