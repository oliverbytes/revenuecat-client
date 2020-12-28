import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/account.controller.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/general_tab_bar.dart';
import 'package:app/features/overview/screen.controller.dart';
import 'package:app/features/overview_day/screen.controller.dart';
import 'package:app/features/transactions/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import 'screen.controller.dart';

final logger = initLogger('MainScreen');

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GeneralAPI());
    Get.put(AccountController());
    Get.put(OverviewScreenController());
    Get.put(OverviewDayScreenController());
    Get.put(TransactionsScreenController());
    Get.put(MainScreenController());
  }
}

class MainScreen extends GetView<MainScreenController> {
  @override
  Widget build(BuildContext context) {
    final _title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/revenuecat.png', height: 30),
        const SizedBox(width: 10),
        Text(
          kApptitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );

    final _appBar = AppBar(
      centerTitle: true,
      title: _title,
      bottom: const GeneralTabbar(),
      actions: [
        IconButton(
          onPressed: controller.about,
          icon: const Icon(Entypo.dots_two_vertical),
        ),
      ],
    );

    return DefaultTabController(
      length: controller.screens.length,
      child: Scaffold(
        appBar: _appBar,
        body: TabBarView(children: controller.screens),
      ),
    );
  }
}
