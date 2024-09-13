import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_state.freezed.dart';

@freezed
class RaceState with _$RaceState {
  const factory RaceState({
    @Default('') String? username,
    @Default(false) bool? isLoading,
  }) = _RaceState;

  const RaceState._();
}
