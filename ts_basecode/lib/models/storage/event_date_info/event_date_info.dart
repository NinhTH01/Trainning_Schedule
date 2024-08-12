import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_date_info.freezed.dart';

@freezed
class EventDateInfo with _$EventDateInfo {
  const factory EventDateInfo({
    @Default(false) bool hasEvent,
    @Default(null) DateTime? date,
  }) = _EventDateInfo;

  const EventDateInfo._();
}
