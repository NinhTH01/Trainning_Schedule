import 'package:flutter/cupertino.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_dialog_method_channel.dart';

abstract class NativeDialogPlatform extends PlatformInterface {
  /// Constructs a NativeDialogPlatform.
  NativeDialogPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeDialogPlatform _instance = MethodChannelNativeDialog();

  /// The default instance of [NativeDialogPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeDialog].
  static NativeDialogPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeDialogPlatform] when
  /// they register themselves.
  static set instance(NativeDialogPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void showAchievementIniOS({
    required BuildContext context,
    required double totalDistance,
  }) {
    throw UnimplementedError('showAchievementIniOS has not been implemented.');
  }

  void showAchievementInAndroid({
    required BuildContext context,
    required double totalDistance,
  }) {
    throw UnimplementedError(
        'showAchievementInAndroid has not been implemented.');
  }
}
