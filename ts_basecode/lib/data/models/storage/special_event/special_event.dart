import 'package:freezed_annotation/freezed_annotation.dart';

part 'special_event.freezed.dart';
part 'special_event.g.dart';

const String tableSpecialEvents = 'special_events';

class SpecialEventFields {
  static const String id = '_id';
  static const String distance = 'distance';
  static const String description = 'description';
  static const String time = 'time';
  static const String orderIndex = 'orderIndex';
}

@freezed
class SpecialEvent with _$SpecialEvent {
  const factory SpecialEvent({
    @JsonKey(name: SpecialEventFields.id) int? id,
    @JsonKey(name: SpecialEventFields.time) DateTime? createdTime,
    double? distance,
    String? description,
    int? orderIndex,
  }) = _SpecialEvent;

  factory SpecialEvent.fromJson(Map<String, dynamic> json) =>
      _$SpecialEventFromJson(json);
}
