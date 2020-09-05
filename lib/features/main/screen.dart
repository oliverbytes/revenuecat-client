import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/general_tab_bar.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'screen.controller.dart';

final logger = initLogger('MainScreen');

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(MainScreenController());

    final _title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/revenuecat.png', height: 30),
        SizedBox(width: 10),
        Text(
          kApptitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );

    final _tabBar = GeneralTabbar();

    final _appBar = AppBar(
      centerTitle: true,
      title: _title,
      bottom: _tabBar,
      actions: [
        IconButton(
          onPressed: _uiController.about,
          icon: Icon(Entypo.dots_two_vertical),
        ),
      ],
    );

    return DefaultTabController(
      length: _uiController.screens.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: _appBar,
        body: TabBarView(children: _uiController.screens),
      ),
    );
  }
}
