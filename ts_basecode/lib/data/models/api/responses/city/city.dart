import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/coord/coord.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  const factory City({
    int? id,
    String? name,
    Coord? coord,
    String? country,
    int? population,
    int? timezone,
    int? sunrise,
    int? sunset,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
