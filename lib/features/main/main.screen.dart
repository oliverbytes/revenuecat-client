import 'package:app/core/constants.dart';
import 'package:app/core/logger.dart';
import 'package:app/features/transactions/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main_screen.controller.dart';

final logger = initLogger('MainScreen');

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(MainScreenController());

    final _subTitleStyle = TextStyle(color: Colors.grey);
    final _trailingStyle = TextStyle(fontSize: 17, fontWeight: FontWeight.bold);

    final _content = EasyRefresh(
      header: MaterialHeader(),
      onRefresh: _uiController.refresh,
      controller: _uiController.refreshController,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Obx(
                  () => IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed:
                        _uiController.busy ? null : _uiController.fetchPrevious,
                  ),
                ),
                Obx(
                  () => FlatButton.icon(
                    onPressed: () => _uiController.selectDate(context),
                    icon: Icon(Icons.date_range, size: 20),
                    label: Text(
                      _uiController.selectedDate,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: _uiController.canGoForward && !_uiController.busy
                        ? _uiController.fetchNext
                        : null,
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Revenue'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  text: 'Last: ' + _uiController.lastPurchaseDetails,
                  androidText: _uiController.revenueTodayAndroidString,
                  iosText: _uiController.revenueTodayIOSString,
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.revenueToday,
                  textColor: Colors.lightGreen,
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Renewals'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  text: 'Last: ' + _uiController.lastRenewalDate ?? '',
                  androidText:
                      _uiController.renewalsTodayAndroid.value.toString(),
                  iosText: _uiController.renewalsTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.renewalsToday.toString(),
                  textColor: _uiController.renewalsToday > 0
                      ? Colors.lightBlue
                      : Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.open_in_new),
              title: Text('Trial Conversions'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  text: 'Last: ' + _uiController.lastConversionDate ?? '',
                  androidText: _uiController.trialConversionsTodayAndroid.value
                      .toString(),
                  iosText:
                      _uiController.trialConversionsTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.trialConversionsToday.toString(),
                  textColor: _uiController.trialConversionsToday > 0
                      ? Colors.yellow
                      : Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Subscribers'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  // text: 'Last: ' + _uiController.lastConversionDate ?? '',
                  androidText:
                      _uiController.subscribersTodayAndroid.value.toString(),
                  iosText: _uiController.subscribersTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.subscribersToday.toString(),
                  textColor: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_alarm),
              title: Text('Trials'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  // text: 'Last: ' + _uiController.lastConversionDate ?? '',
                  androidText:
                      _uiController.trialsTodayAndroid.value.toString(),
                  iosText: _uiController.trialsTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.trialsToday.toString(),
                  textColor: Colors.white,
                  // androidText:
                  //     _uiController.trialsTodayAndroid.value.toString(),
                  // iosText: _uiController.trialsTodayIOS.value.toString(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.money_off),
              title: Text('Refunds'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  // text: 'Last: ' + _uiController.lastConversionDate ?? '',
                  androidText:
                      _uiController.refundsTodayAndroid.value.toString(),
                  iosText: _uiController.refundsTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.refundsToday.toString(),
                  textColor:
                      _uiController.refundsToday > 0 ? Colors.red : Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Transactions'),
              subtitle: Obx(
                () => OverviewSubtitle(
                  // text: 'Last: ' + _uiController.lastConversionDate ?? '',
                  androidText:
                      _uiController.transactionsTodayAndroid.value.toString(),
                  iosText: _uiController.transactionsTodayIOS.value.toString(),
                ),
              ),
              trailing: Obx(
                () => TrailingWidget(
                  text: _uiController.transactionsToday.toString(),
                  textColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Overview'.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 30),
            ListTile(
              leading: Icon(Icons.access_alarm),
              title: Text('Active Trials'),
              subtitle: Text('active trials', style: _subTitleStyle),
              trailing: Obx(
                () => Text(_uiController.trials, style: _trailingStyle),
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Active Subscriptions'),
              subtitle: Text('active subscribers', style: _subTitleStyle),
              trailing: Obx(
                () => Text(_uiController.subscribers, style: _trailingStyle),
              ),
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('MRR'),
              subtitle:
                  Text('monthly recurring revenue', style: _subTitleStyle),
              trailing: Obx(
                () => Text(
                  _uiController.mrr,
                  style: _trailingStyle.copyWith(color: Colors.lightGreen),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Revenue'),
              subtitle: Text('last 28 days', style: _subTitleStyle),
              trailing: Obx(
                () => Text(
                  _uiController.revenue,
                  style: _trailingStyle.copyWith(color: Colors.lightGreen),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Installs'),
              subtitle: Text('last 28 days', style: _subTitleStyle),
              trailing: Obx(
                () => Text(_uiController.installs, style: _trailingStyle),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Active Users'),
              subtitle: Text('last 28 days', style: _subTitleStyle),
              trailing: Obx(
                () => Text(_uiController.users, style: _trailingStyle),
              ),
            ),
            Divider(height: 50),
            Image.asset(
              'assets/images/nemory_studios.png',
              height: 50,
            ),
            SizedBox(height: 10),
            Linkify(
              text: 'Developed by: Nemory Studios\nhttps://nemorystudios.dev',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              linkStyle: TextStyle(color: Get.theme.accentColor),
              textAlign: TextAlign.center,
              onOpen: (link) => launch(link.url),
            ),
            SizedBox(height: 10),
            Text(
              'Credits to RevenueCat for their amazing service to app developers! Cheers!',
              style: TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );

    final _title = AppBar(
      title: Row(
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
      body: Obx(
        () => Opacity(opacity: _uiController.busy ? 0.5 : 1.0, child: _content),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: _uiController.busy,
          child: LinearProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(TransactionsScreen()),
        child: Icon(Icons.payment),
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
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
        SizedBox(height: 3),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.android, size: 12, color: Colors.grey),
        SizedBox(width: 2),
        Text(androidText, style: TextStyle(color: Colors.grey, fontSize: 12)),
        SizedBox(width: 5),
        Icon(Entypo.app_store, size: 12, color: Colors.grey),
        SizedBox(width: 2),
        Text(iosText, style: TextStyle(color: Colors.grey, fontSize: 12)),
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
