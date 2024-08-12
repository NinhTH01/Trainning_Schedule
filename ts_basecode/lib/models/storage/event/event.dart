import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'distance') double? distance,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'time') DateTime? createdTime,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
