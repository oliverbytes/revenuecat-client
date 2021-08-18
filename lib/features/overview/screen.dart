import 'package:app/core/controllers/account.controller.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'screen.controller.dart';

final logger = initLogger('OverviewScreen');

class OverviewScreen extends GetView<OverviewScreenController> {
  @override
  Widget build(BuildContext context) {
    final AccountController accountController = Get.find();

    final _content = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: kWebMaxWidth),
        padding: const EdgeInsets.only(top: 20),
        child: EasyRefresh(
          header: MaterialHeader(),
          onRefresh: controller.fetch,
          controller: controller.refreshController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.perm_identity),
                  title: Obx(() => Text(
                      '${accountController.accountName} - ${accountController.accountId}')),
                  subtitle: Obx(() => Text(
                      'Email: ${accountController.accountEmail}\nCurrent Plan: ${accountController.accountPlan}\nFirst Transaction: ${accountController.firstTransactionDate}',
                      style: const TextStyle(color: Colors.grey))),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Monthly Tracked Revenue'),
                  subtitle: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          StepProgressIndicator(
                            totalSteps: accountController.mtrLimit,
                            currentStep: accountController.currentMtr,
                            size: 5,
                            padding: 0,
                            selectedColor: Get.theme.accentColor,
                            unselectedColor: Colors.grey.withOpacity(0.5),
                            roundedEdges: Radius.circular(10),
                          ),
                          const SizedBox(height: 5),
                          Text(
                              '${accountController.currentMtrFormatted} / ${accountController.mtrLimitFormatted}'),
                        ],
                      )),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text('Active Trials'),
                  subtitle: const Text('active trials',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(controller.trials,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Active Subscriptions'),
                  subtitle: const Text('active subscribers',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(controller.subscribers,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('MRR'),
                  subtitle: const Text('monthly recurring revenue',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(
                      controller.mrr,
                      style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)
                          .copyWith(color: Colors.lightGreen),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Revenue'),
                  subtitle: const Text('last 28 days',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(
                      controller.revenue,
                      style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)
                          .copyWith(color: Colors.lightGreen),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('Installs'),
                  subtitle: const Text('last 28 days',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(controller.installs,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Active Users'),
                  subtitle: const Text('last 28 days',
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(controller.users,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );

    return Obx(
      () => Visibility(
        visible: controller.busy,
        replacement: Visibility(
          visible: controller.error,
          child: EmptyPlaceholder(
            iconData: Icons.error_outline,
            message: controller.message(),
            child: OutlinedButton(
              child: Text('Refresh'),
              onPressed: controller.fetch,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          replacement: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: controller.fetch,
              child: Icon(Icons.refresh),
            ),
            body: _content,
          ),
        ),
        child: Center(
          child: SizedBox(
            height: Get.mediaQuery.size.height,
            width: Get.mediaQuery.size.height,
            child: Shimmer.fromColors(
              child: _content,
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
