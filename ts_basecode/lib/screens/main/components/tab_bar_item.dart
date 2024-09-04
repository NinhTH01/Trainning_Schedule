import 'package:flutter/material.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/main/models/main_tab.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

class TabBarItem extends StatelessWidget {
  const TabBarItem({
    required this.mainTab,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final MainTab mainTab;

  final bool isActive;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isActive ? ColorName.blue : ColorName.grayFFFAFAFA,
              width: isActive ? 2 : 0,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isActive ? mainTab.activeIcon : mainTab.icon,
            const SizedBox(height: 5),
            Text(mainTab.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: isActive
                    ? AppTextStyles.s12w500.copyWith(color: ColorName.blue)
                    : AppTextStyles.s12w500),
          ],
        ),
      ),
    );
  }
}
