import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_running_status_state.freezed.dart';

@freezed
class GlobalRunningStatusState with _$GlobalRunningStatusState {
  const factory GlobalRunningStatusState({
    @Default(false) bool isRunning,
    @Default(0.0) double totalDistance,
  }) = _GlobalRunningStatusState;

  const GlobalRunningStatusState._();
}
