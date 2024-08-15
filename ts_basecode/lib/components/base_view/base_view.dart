import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:ts_basecode/components/dialog/dialog_provider.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';

import 'base_view_mixin.dart';
import 'base_view_model.dart';

abstract class BaseView extends ConsumerStatefulWidget {
  const BaseView({
    super.key,
  });
}

abstract class BaseViewState<View extends BaseView,
        ViewModel extends BaseViewModel> extends ConsumerState<View>
    with BaseViewMixin {
  ViewModel get viewModel;

  final logger = Logger();

  @mustCallSuper
  void onInitState() {
    logger.d('Init State: $runtimeType');
  }

  @mustCallSuper
  void onDispose() {
    logger.d('Dispose: $runtimeType');
  }

  @override
  void initState() {
    onInitState();
    super.initState();
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView(context);

  void nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  Future<void> handleError(
    dynamic error, {
    void Function()? onButtonTapped,
  }) async {
    String? errorMessage;

    if (error is DioException) {
      final response = error.response;

      if (response != null) {
        try {
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'];
          } else {
            // final errorJson = jsonDecode(response.data);
            // errorMessage = BaseResponseError.fromJson(errorJson).message;
          }
        } catch (_) {
          errorMessage = error.response?.statusMessage;
        }
      }
    } else if (error is AlwaysPermissionException) {
      await ref.read(alertDialogProvider).showAlertDialog(
            context: context,
            buttonTitle: 'Go to Setting',
            title: error.message,
            onClosed: Geolocator.openLocationSettings,
          );
    }

    if (errorMessage != null) {
      // await ref.read(alertDialogProvider).showAlertDialog(
      //       context: context,
      //       title: errorMessage,
      //       onClosed: onButtonTapped,
      //     );
    }
  }
}
