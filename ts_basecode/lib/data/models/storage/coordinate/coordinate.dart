import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinate.freezed.dart';
part 'coordinate.g.dart';

class CoordinateFields {
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
}

@freezed
class Coordinate with _$Coordinate {
  const factory Coordinate({
    double? latitude,
    double? longitude,
  }) = _Coordinate;

  factory Coordinate.fromJson(Map<String, dynamic> json) =>
      _$CoordinateFromJson(json);
}
