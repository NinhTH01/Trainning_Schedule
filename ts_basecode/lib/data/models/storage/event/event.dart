import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

const String tableEvents = 'events';

class EventFields {
  static const String id = '_id';
  static const String distance = 'distance';
  static const String description = 'description';
  static const String time = 'time';
}

@freezed
class Event with _$Event {
  const factory Event({
    @JsonKey(name: EventFields.id) int? id,
    @JsonKey(name: EventFields.time) DateTime? createdTime,
    double? distance,
    String? description,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
