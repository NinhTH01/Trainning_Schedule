import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_map_manager_state.freezed.dart';

@freezed
class GlobalMapManagerState with _$GlobalMapManagerState {
  const factory GlobalMapManagerState({
    @Default(false) bool isRunning,
    @Default(0.0) double totalDistance,
  }) = _GlobalMapManagerState;

  const GlobalMapManagerState._();
}
