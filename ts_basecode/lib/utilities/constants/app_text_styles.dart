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

  static const blackDefaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.black,
  );

  static final s16w700 = blackDefaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final s12w500 = blackDefaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final s16w400 = blackDefaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static final w500 = blackDefaultStyle.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final w600 = blackDefaultStyle.copyWith(
    fontWeight: FontWeight.w600,
  );

  static final s16b = blackDefaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static final s12b = blackDefaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static final s16w500 = blackDefaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final s24b =
      blackDefaultStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold);

  static final s18b =
      blackDefaultStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold);

  static final s16w600 =
      blackDefaultStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

  static const whiteDefaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.white,
  );

  static final whites30b = whiteDefaultStyle.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static final whites60b = whiteDefaultStyle.copyWith(
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  static final whites20w600 = whiteDefaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static final whites16w600 = whiteDefaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final whitew500 = whiteDefaultStyle.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final whites12 = whiteDefaultStyle.copyWith(
    fontSize: 12,
  );

  static final whites12w500 = whiteDefaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static final whites32n =
      whiteDefaultStyle.copyWith(fontSize: 32, fontWeight: FontWeight.normal);

  static const white70DefaultStyle = TextStyle(
    fontFamily: FontFamily.notoSans,
    color: ColorName.white70,
  );

  static final white70s16b =
      white70DefaultStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold);

  static final white70s16 = white70DefaultStyle.copyWith(fontSize: 16);

  static final white70s12w500 = white70DefaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
