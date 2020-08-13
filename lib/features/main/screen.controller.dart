import 'package:app/core/utils/logger.dart';
import 'package:app/core/managers/hive.manager.dart';
import 'package:app/features/authentication/screen.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:app/features/overview/screen.controller.dart';
import 'package:app/features/overview_day/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

final logger = initLogger("MainScreenController");

class MainScreenController extends GetxController {
  static MainScreenController get to => Get.find();

  // VARIABLES
  final refreshController = EasyRefreshController();

  // PROPERTIES
  final segmentedIndex = 0.obs;

  // GETTERS

  // INIT
  @override
  void onInit() {
    Get.put(OverviewScreenController());
    Get.put(OverviewDayScreenController());

    if (HiveManager.clientToken.isNotEmpty) refresh();
    super.onInit();
  }

  @override
  void onReady() {
    if (HiveManager.clientToken.isEmpty) Get.to(AuthScreen());
    super.onInit();
  }

  // FUNCTIONS

  Future<void> refresh() async {
    await OverviewScreenController.to.fetch();
    await OverviewDayScreenController.to.fetch();
    refreshController.finishRefresh();
  }

  void logOut() {
    Get.generalDialog(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => CustomDialog(
        'Logout?',
        'Are you sure you want to logout?',
        image: Image.asset('assets/images/revenuecat.png', height: 100),
        button: 'Log Out',
        pressed: () {
          HiveManager.setClientToken('');
          Get.to(AuthScreen());
        },
      ),
    );
  }

  void segmentedChanged(int index) => segmentedIndex.value = index;
}
