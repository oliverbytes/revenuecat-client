import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/segmented_switch.widget.dart';
import 'package:app/features/overview/screen.dart';
import 'package:app/features/overview_day/screen.dart';
import 'package:app/features/transactions/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'screen.controller.dart';

final logger = initLogger('MainScreen');

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(MainScreenController());

    final _content = EasyRefresh(
      header: MaterialHeader(),
      onRefresh: _uiController.refresh,
      controller: _uiController.refreshController,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SegmentedSwitch(
              fontSize: 13,
              onChanged: _uiController.segmentedChanged,
              tabs: [
                Tab(text: 'OVERVIEW'),
                Tab(text: 'DAY'),
              ],
            ),
            Divider(height: 0),
            Obx(
              () => Visibility(
                visible: _uiController.segmentedIndex.value == 0,
                child: OverviewScreen(),
                replacement: OverviewDayScreen(),
              ),
            ),
          ],
        ),
      ),
    );

    final _title = AppBar(
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/revenuecat.png',
            height: 30,
          ),
          SizedBox(width: 10),
          Text(
            kApptitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _uiController.logOut,
          icon: Icon(Icons.exit_to_app),
        ),
      ],
    );

    return Scaffold(
      appBar: _title,
      body: _content,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(TransactionsScreen()),
        child: Icon(Icons.payment),
      ),
    );
  }
}
