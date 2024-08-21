import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'native_dialog_platform_interface.dart';

/// An implementation of [NativeDialogPlatform] that uses method channels.
class MethodChannelNativeDialog extends NativeDialogPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_dialog');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void showAchievementIniOS({
    required BuildContext context,
    required double totalDistance,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: UiKitView(
                  viewType: 'native_dialog',
                  creationParams: <String, dynamic>{
                    'distance': totalDistance.toStringAsFixed(2),
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: (int id) {
                    final methodChannel = MethodChannel('native_dialog_$id');
                    methodChannel.setMethodCallHandler((call) async {
                      if (call.method == 'buttonTapped') {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void showAchievementInAndroid({
    required BuildContext context,
    required double totalDistance,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: AndroidView(
                  viewType: 'native_dialog',
                  creationParams: <String, dynamic>{
                    'distance': totalDistance.toStringAsFixed(2),
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                  onPlatformViewCreated: (int id) {
                    final methodChannel = MethodChannel('native_dialog_$id');
                    methodChannel.setMethodCallHandler((call) async {
                      if (call.method == 'buttonTapped') {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
