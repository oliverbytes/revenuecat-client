import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'screen.controller.dart';

final logger = initLogger('OverviewDayScreen');

class OverviewDayScreen extends GetView<OverviewDayScreenController> {
  @override
  Widget build(BuildContext context) {
    final _content = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: kWebMaxWidth),
        padding: EdgeInsets.only(top: 20),
        child: EasyRefresh(
          header: MaterialHeader(),
          onRefresh: controller.fetch,
          controller: controller.refreshController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: controller.canGoPrevious && controller.busy
                              ? null
                              : controller.fetchPrevious,
                        ),
                      ),
                      Obx(
                        () => TextButton.icon(
                          onPressed: () => controller.selectDate(context),
                          icon: const Icon(Icons.date_range, size: 20),
                          label: Text(
                            controller.selectedDate,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: controller.canGoNext && !controller.busy
                              ? controller.fetchNext
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Revenue'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      text: 'Last: ' +
                          controller.lastPurchaseDetails +
                          '\nPurchases: ' +
                          controller.purchasesCount.toString(),
                      androidText: controller.revenueAndroidString +
                          ' - ' +
                          controller.purchasesAndroid().toString(),
                      iosText: controller.revenueIOSString +
                          ' - ' +
                          controller.purchasesIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.revenueTotal,
                      textColor: Colors.lightGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Renewals'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      text: 'Last: ' + controller.lastRenewalDate,
                      androidText: controller.renewalsAndroid().toString(),
                      iosText: controller.renewalsIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.renewalsCount.toString(),
                      textColor: controller.renewalsCount > 0
                          ? Colors.lightBlue
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('Trial Conversions'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      text: 'Last: ' + controller.lastConversionDate,
                      androidText:
                          controller.trialConversionsAndroid().toString(),
                      iosText: controller.trialConversionsIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.trialConversionsCount.toString(),
                      textColor: controller.trialConversionsCount > 0
                          ? Colors.yellow
                          : Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Subscribers'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      androidText: controller.subscribersAndroid().toString(),
                      iosText: controller.subscribersIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.subscribersCount.toString(),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.access_alarm),
                  title: const Text('Trials'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      androidText: controller.trialsAndroid().toString(),
                      iosText: controller.trialsIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.trialsCount.toString(),
                      textColor: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.money_off),
                  title: const Text('Refunds'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      androidText: controller.refundsAndroid().toString(),
                      iosText: controller.refundsIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.refundsCount.toString(),
                      textColor: controller.refundsCount > 0
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Transactions'),
                  subtitle: Obx(
                    () => OverviewSubtitle(
                      // text: 'Last: ' + controller.lastConversionDate ?? '',
                      androidText: controller.transactionsAndroid().toString(),
                      iosText: controller.transactionsIOS().toString(),
                    ),
                  ),
                  trailing: Obx(
                    () => TrailingWidget(
                      text: controller.transactionsCount.toString(),
                      textColor: Colors.white,
                    ),
                  ),
                ),
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
              child: const Text('Refresh'),
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
              child: const Icon(Icons.refresh),
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

class OverviewSubtitle extends StatelessWidget {
  final String text;
  final String androidText;
  final String iosText;
  const OverviewSubtitle({Key key, this.text, this.androidText, this.iosText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text != null) ...[
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
        const SizedBox(height: 3),
        PlatformComparison(androidText: androidText, iosText: iosText),
      ],
    );
  }
}

class PlatformComparison extends StatelessWidget {
  final String androidText;
  final String iosText;

  const PlatformComparison({Key key, this.androidText, this.iosText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.android, size: 12, color: Colors.grey),
            const SizedBox(width: 2),
            Text(androidText,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(width: 5),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Entypo.app_store, size: 12, color: Colors.grey),
            const SizedBox(width: 2),
            Text(iosText,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class TrailingWidget extends StatelessWidget {
  final String text;
  final Color textColor;

  const TrailingWidget({Key key, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}
