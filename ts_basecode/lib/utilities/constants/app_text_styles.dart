import 'package:flutter/cupertino.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/resources/gen/fonts.gen.dart';

class AppTextStyles {
  AppTextStyles._();

  /// Splash Screen
  static const appNameStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24);

  /// Map Screen
  static const startButtonStyle = TextStyle(
    color: ColorName.black,
    fontWeight: FontWeight.w500,
  );

  /// Calendar Screen
  static const calendarTitleCurrentDateStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static const calendarWeekStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0);

  static const isTodayContainerStyle =
      TextStyle(fontWeight: FontWeight.w500, color: ColorName.white);

  static const otherMonthContainerStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: ColorName.greyFF757575,
  );

  static const redTextStyle = TextStyle(color: ColorName.red);
  static const blackTextStyle = TextStyle(color: ColorName.black);

  static const defaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.black,
  );

  static final s16w700 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s12w500 = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final s16w400 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final w500 = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final w600 = defaultStyle.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final s16b = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final s12b = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final s16w500 = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final s24b =
      defaultStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold);

  static final s18b =
      defaultStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold);

  static final s16w600 =
      defaultStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600);
}
