import 'package:flutter/material.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.rightWidget,
    this.hasBackIcon = true,
  });

  final String title;
  final VoidCallback onBack;
  final Widget rightWidget;
  final bool hasBackIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        hasBackIcon
            ? IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios),
              )
            : const SizedBox(),
        Expanded(
          child: Text(
            style: AppTextStyles.s16w700,
            maxLines: 1,
            textAlign: TextAlign.center,
            title,
          ),
        ),
        rightWidget
      ],
    );
  }
}
