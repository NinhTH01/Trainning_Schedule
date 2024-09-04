import 'package:flutter/material.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class WeatherStatusView extends StatelessWidget {
  const WeatherStatusView({
    super.key,
    required this.title,
    this.value,
    required this.backgroundColor,
  });

  final String title;

  final String? value;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.s16w700.copyWith(
              color: ColorName.white70,
            ),
          ),
          Text(
            value ?? '_',
            style: AppTextStyles.s30w500.copyWith(
              color: ColorName.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
