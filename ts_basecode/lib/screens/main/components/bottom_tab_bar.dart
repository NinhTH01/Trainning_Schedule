import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/screens/main/components/tab_bar_item.dart';
import 'package:ts_basecode/screens/main/models/main_tab.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    required this.tabsRouter,
    super.key,
  });

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: ColorName.grayFFFAFAFA,
      child: Row(
        children: [
          MainTab.calendar,
          MainTab.map,
          MainTab.weather,
          MainTab.special,
        ].map((tab) {
          return TabBarItem(
            mainTab: tab,
            isActive: tab.index == tabsRouter.activeIndex,
            onTap: () => tabsRouter.setActiveIndex(tab.index),
          );
        }).toList(),
      ),
    );
  }
}
