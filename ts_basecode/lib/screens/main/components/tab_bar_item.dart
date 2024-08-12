import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/main/models/main_tab.dart';

class TabBarItem extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width / 3,
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
            mainTab.getIcon(context),
            const SizedBox(height: 5),
            Text(
              mainTab.getLabel(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
