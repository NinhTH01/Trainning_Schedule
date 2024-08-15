import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_dialog.dart';

final alertDialogProvider = Provider<AlertDialog>((ref) => AlertDialog(ref));

class AlertDialog {
  AlertDialog(this.ref);

  final Ref ref;

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
}
