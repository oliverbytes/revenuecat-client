import 'package:app/core/controllers/account.controller.dart';
import 'package:app/core/managers/hive.manager.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/apps/screen.dart';
import 'package:app/features/authentication/screen.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:app/features/overview/screen.controller.dart';
import 'package:app/features/overview/screen.dart';
import 'package:app/features/overview_day/screen.controller.dart';
import 'package:app/features/overview_day/screen.dart';
import 'package:app/features/transactions/screen.controller.dart';
import 'package:app/features/transactions/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = initLogger("MainScreenController");

class MainScreenController extends GetxController {
  static MainScreenController get to => Get.find();

  // VARIABLES
  final pageController = PageController();

  final List<Widget> screens = [
    OverviewScreen(),
    OverviewDayScreen(),
    TransactionsScreen(),
    AppsScreen(),
  ];

  // PROPERTIES
  final pageIndex = 0.obs;

  // GETTERS

  // INIT
  @override
  void onInit() {
    Get.put(AccountController());
    Get.put(OverviewScreenController());
    Get.put(OverviewDayScreenController());
    Get.put(TransactionsScreenController());

    if (HiveManager.clientToken.isNotEmpty) refresh();
    logger.w('onInit');
    super.onInit();
  }

  @override
  void onReady() {
    if (HiveManager.clientToken.isEmpty) Get.to(AuthScreen());
    logger.w('onReady');
    super.onInit();
  }

  // FUNCTIONS
  void refresh() {
    AccountController.to.fetch();
    OverviewScreenController.to.fetch();
    OverviewDayScreenController.to.fetch();
    TransactionsScreenController.to.fetch();

    logger.w('refresh');
  }

  void logOut() {
    Get.generalDialog(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => CustomDialog(
        'Logout?',
        'Are you sure you want to logout?',
        image: Icon(Icons.exit_to_app, size: 100),
        button: 'Log Out',
        pressed: () {
          HiveManager.setClientToken('');
          Get.to(AuthScreen());
        },
      ),
    );
  }

  void about() async {
    String version = "";

    if (!kIsWeb) {
      final packageInfo = await PackageInfo.fromPlatform();
      version = "v${packageInfo.version}+${packageInfo.buildNumber}";
    }

    Get.generalDialog(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => CustomDialog(
        'RevenueCat',
        'An unonofficial client for RevenueCat.\nNot endorsed or affiliated at all.\n$version\n\nOpen Source Project\n$kGithubProjectUrl',
        image: Image.asset('assets/images/revenuecat.png', height: 50),
        child: Column(
          children: [
            const Divider(height: 50),
            Image.asset(
              'assets/images/nemory_studios.png',
              height: 50,
            ),
            const SizedBox(height: 10),
            Linkify(
              text: 'Developer & Maintainer\nhttps://nemorystudios.dev',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              linkStyle: TextStyle(color: Get.theme.accentColor),
              textAlign: TextAlign.center,
              onOpen: (link) => launch(link.url),
            ),
            const SizedBox(height: 10),
            const Text(
              'Credits to RevenueCat for their amazing service\nand to all contributors of the project!',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            )
          ],
        ),
        button: 'Log Out',
        pressed: logOut,
      ),
    );
  }

  void pageChanged(index) {
    pageIndex.value = index;
    pageController.jumpToPage(index);
  }
}
