import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class GeneralTabbar extends StatelessWidget with PreferredSizeWidget {
  const GeneralTabbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: TabBar(
        tabs: [
          Tab(text: 'OVERVIEW'),
          Tab(text: 'DAY'),
          Tab(text: 'TRANSACTIONS'),
        ],
        isScrollable: true,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BubbleTabIndicator(
          indicatorHeight: 25.0,
          tabBarIndicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Get.theme.accentColor,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);
}
