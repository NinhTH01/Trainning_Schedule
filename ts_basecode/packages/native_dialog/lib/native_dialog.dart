import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'native_dialog_platform_interface.dart';

class NativeDialog {
  Future<String?> getPlatformVersion() {
    return NativeDialogPlatform.instance.getPlatformVersion();
  }

  void showNativeAchievementView({
    required BuildContext context,
    required double totalDistance,
  }) {
    if (Platform.isIOS) {
      NativeDialogPlatform.instance
          .showAchievementIniOS(context: context, totalDistance: totalDistance);
    } else {
      NativeDialogPlatform.instance.showAchievementInAndroid(
          context: context, totalDistance: totalDistance);
    }
  }
}
