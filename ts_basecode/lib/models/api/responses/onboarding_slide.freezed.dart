// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_slide.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingSlide _$OnboardingSlideFromJson(Map<String, dynamic> json) {
  return _OnboardingSlide.fromJson(json);
}

/// @nodoc
mixin _$OnboardingSlide {
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrl')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingSlideCopyWith<OnboardingSlide> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingSlideCopyWith<$Res> {
  factory $OnboardingSlideCopyWith(
          OnboardingSlide value, $Res Function(OnboardingSlide) then) =
      _$OnboardingSlideCopyWithImpl<$Res, OnboardingSlide>;
  @useResult
  $Res call(
      {@JsonKey(name: 'description') String? description,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      @JsonKey(name: 'title') String? title});
}

/// @nodoc
class _$OnboardingSlideCopyWithImpl<$Res, $Val extends OnboardingSlide>
    implements $OnboardingSlideCopyWith<$Res> {
  _$OnboardingSlideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingSlideImplCopyWith<$Res>
    implements $OnboardingSlideCopyWith<$Res> {
  factory _$$OnboardingSlideImplCopyWith(_$OnboardingSlideImpl value,
          $Res Function(_$OnboardingSlideImpl) then) =
      __$$OnboardingSlideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'description') String? description,
      @JsonKey(name: 'imageUrl') String? imageUrl,
      @JsonKey(name: 'title') String? title});
}

/// @nodoc
class __$$OnboardingSlideImplCopyWithImpl<$Res>
    extends _$OnboardingSlideCopyWithImpl<$Res, _$OnboardingSlideImpl>
    implements _$$OnboardingSlideImplCopyWith<$Res> {
  __$$OnboardingSlideImplCopyWithImpl(
      _$OnboardingSlideImpl _value, $Res Function(_$OnboardingSlideImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? imageUrl = freezed,
    Object? title = freezed,
  }) {
    return _then(_$OnboardingSlideImpl(
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingSlideImpl implements _OnboardingSlide {
  const _$OnboardingSlideImpl(
      {@JsonKey(name: 'description') this.description,
      @JsonKey(name: 'imageUrl') this.imageUrl,
      @JsonKey(name: 'title') this.title});

  factory _$OnboardingSlideImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingSlideImplFromJson(json);

  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @override
  @JsonKey(name: 'title')
  final String? title;

  @override
  String toString() {
    return 'OnboardingSlide(description: $description, imageUrl: $imageUrl, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingSlideImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description, imageUrl, title);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingSlideImplCopyWith<_$OnboardingSlideImpl> get copyWith =>
      __$$OnboardingSlideImplCopyWithImpl<_$OnboardingSlideImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingSlideImplToJson(
      this,
    );
  }
}

abstract class _OnboardingSlide implements OnboardingSlide {
  const factory _OnboardingSlide(
      {@JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'imageUrl') final String? imageUrl,
      @JsonKey(name: 'title') final String? title}) = _$OnboardingSlideImpl;

  factory _OnboardingSlide.fromJson(Map<String, dynamic> json) =
      _$OnboardingSlideImpl.fromJson;

  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'imageUrl')
  String? get imageUrl;
  @override
  @JsonKey(name: 'title')
  String? get title;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingSlideImplCopyWith<_$OnboardingSlideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
