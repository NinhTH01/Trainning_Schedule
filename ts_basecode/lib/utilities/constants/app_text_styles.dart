import 'package:flutter/cupertino.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/resources/gen/fonts.gen.dart';

class AppTextStyles {
  AppTextStyles._();

  static const defaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.black,
  );

  static final s16w700 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s16w400 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  /// Splash Screen
  static const appNameStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);
}
