import 'package:flutter/material.dart';

import 'native_dialog_platform_interface.dart';

class NativeDialog {
  Future<String?> getPlatformVersion() {
    return NativeDialogPlatform.instance.getPlatformVersion();
  }

  void showAchievementIniOS({
    required BuildContext context,
    required double totalDistance,
  }) {
    NativeDialogPlatform.instance
        .showAchievementIniOS(context: context, totalDistance: totalDistance);
  }

  void showAchievementInAndroid({
    required BuildContext context,
    required double totalDistance,
  }) {
    NativeDialogPlatform.instance.showAchievementInAndroid(
        context: context, totalDistance: totalDistance);
  }
}
