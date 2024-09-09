import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_dialog/native_dialog.dart';
import 'package:ts_basecode/data/providers/native_dialog_provider.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

import 'error_dialog.dart';

final dialogProvider = Provider<Dialog>(
  (ref) => Dialog(
    ref: ref,
    nativeDialog: ref.watch(nativeDialogProvider),
  ),
);

class Dialog {
  Dialog({
    required this.ref,
    required this.nativeDialog,
  });

  final Ref ref;

  final NativeDialog nativeDialog;

  int _numberOfShowedAlertDialogs = 0;

  Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    String? buttonTitle,
    VoidCallback? onClosed,
  }) async {
    while (_numberOfShowedAlertDialogs > 0) {
      _numberOfShowedAlertDialogs--;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    _numberOfShowedAlertDialogs++;
    await showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ErrorDialog(
            buttonTitle: buttonTitle,
            title: title,
            onClosed: () {
              if (onClosed != null) {
                onClosed();
              }
              Navigator.of(context).pop();
              _numberOfShowedAlertDialogs--;
            },
          );
        });
  }

  Future<void> showFinishDialog({
    required BuildContext context,
    required Uint8List image,
    required double distance,
    VoidCallback? onClosed,
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Image.memory(image)),
              Text('You have run ${distance.toStringAsFixed(2)} meters'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(TextConstants.close),
              onPressed: () {
                Navigator.of(context).pop();
                if (onClosed != null) {
                  onClosed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showAchieveDialog({
    required BuildContext context,
    required double totalDistance,
  }) {
    nativeDialog.showNativeAchievementView(
      context: context,
      totalDistance: totalDistance,
    );
  }
}
