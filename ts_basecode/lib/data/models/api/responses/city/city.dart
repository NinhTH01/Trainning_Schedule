import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ts_basecode/data/models/api/responses/coord/coord.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  const factory City({
    @JsonKey() int? id,
    @JsonKey() String? name,
    @JsonKey() Coord? coord,
    @JsonKey() String? country,
    @JsonKey() int? population,
    @JsonKey() int? timezone,
    @JsonKey() int? sunrise,
    @JsonKey() int? sunset,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
