import 'package:freezed_annotation/freezed_annotation.dart';

part 'sys.freezed.dart';
part 'sys.g.dart';

@freezed
class Sys with _$Sys {
  const factory Sys({
    @JsonKey() int? type,
    @JsonKey() int? id,
    @JsonKey() String? country,
    @JsonKey() int? sunrise,
    @JsonKey() int? sunset,
  }) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}
