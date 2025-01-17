import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:ts_basecode/components/dialog/dialog_provider.dart';
import 'package:ts_basecode/data/models/api/responses/base_response_error/base_response_error.dart';
import 'package:ts_basecode/data/models/exception/always_permission_exception/always_permission_exception.dart';
import 'package:ts_basecode/data/models/exception/general_exception/general_exception.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

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

  Future<void> showFinishDialog({
    required Uint8List image,
    required double distance,
    required void Function() onClose,
  }) async {
    await ref.read(dialogProvider).showFinishDialog(
          context: context,
          distance: distance,
          image: image,
          onClosed: onClose,
        );
  }

  Future<void> showAchievementDialog({
    required BuildContext context,
    required double totalDistance,
  }) async {
    ref.read(dialogProvider).showAchieveDialog(
          context: context,
          totalDistance: totalDistance,
        );
  }

  Future<void> handleError(
    Object error, {
    void Function()? onButtonTapped,
  }) async {
    if (error is DioException) {
      String? errorMessage;
      final response = error.response;

      if (response != null) {
        try {
          if (response.data is Map<String, dynamic>) {
            errorMessage = response.data['message'];
          } else {
            final errorJson = jsonDecode(response.data);
            errorMessage = BaseResponseError.fromJson(errorJson).message;
          }
        } catch (_) {
          errorMessage = error.response?.statusMessage;
        }
        if (errorMessage != null && mounted) {
          await ref.read(dialogProvider).showAlertDialog(
                context: context,
                title: errorMessage,
                onClosed: onButtonTapped,
              );
        }
      }
      return;
    }

    if (error is AlwaysPermissionException) {
      await ref.read(dialogProvider).showAlertDialog(
            context: context,
            buttonTitle: TextConstants.goToSetting,
            title: error.message,
            onClosed: Geolocator.openLocationSettings,
          );
      return;
    }

    if (error is TimeoutException && mounted) {
      await ref.read(dialogProvider).showAlertDialog(
            context: context,
            title: TextConstants.timeOut,
            onClosed: onButtonTapped,
          );
      return;
    }

    if (error is GeneralException && mounted) {
      await ref.read(dialogProvider).showAlertDialog(
            context: context,
            title: error.message,
            onClosed: onButtonTapped,
          );
      return;
    }

    return;
  }
}
