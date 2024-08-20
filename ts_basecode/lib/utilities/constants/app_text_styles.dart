import 'package:flutter/cupertino.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/resources/gen/fonts.gen.dart';

class AppTextStyles {
  AppTextStyles._();

  static const defaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.black,
  );

  static final s12w500 = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final s12w700 = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static final s14w400 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final s14w600 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final s16w400 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s16w500 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final s16w600 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final s16w700 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s20w600 = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final s24w700 = defaultStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static final s30w500 = defaultStyle.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w500,
  );

  static final s30w700 = defaultStyle.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  static final s60w700 = defaultStyle.copyWith(
    fontSize: 60,
    fontWeight: FontWeight.w700,
  );
}
