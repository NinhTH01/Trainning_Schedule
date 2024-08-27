import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

const String tableEvents = 'events';

class EventFields {
  static final List<String> values = [id, description, distance, time];

  static const String id = '_id';
  static const String distance = 'distance';
  static const String description = 'description';
  static const String time = 'time';
  static const String isSpecial = 'isSpecial';
}

@freezed
class Event with _$Event {
  const factory Event({
    @JsonKey(name: EventFields.id) int? id,
    @JsonKey(name: EventFields.distance) double? distance,
    @JsonKey(name: EventFields.description) String? description,
    @JsonKey(name: EventFields.time) DateTime? createdTime,
    @JsonKey(name: EventFields.isSpecial) int? isSpecial,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
