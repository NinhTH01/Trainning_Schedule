import 'package:flutter/material.dart';
import 'package:ts_basecode/components/divider/divider_horizontal.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';
import 'package:ts_basecode/utilities/constants/text_constants.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    this.onClosed,
    this.buttonTitle,
    required this.title,
  });

  final String title;

  final String? buttonTitle;

  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            11,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                title,
                style: AppTextStyles.s16w700,
              ),
            ),
            const DividerHorizontal(height: 1),
            GestureDetector(
              onTap: onClosed ??
                  () {
                    Navigator.of(context).pop();
                  },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(11),
                    bottomRight: Radius.circular(11),
                  ),
                ),
                child: Text(
                  buttonTitle ?? TextConstants.close,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s16w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
