import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'screen.controller.dart';

final logger = initLogger('OverviewScreen');

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final OverviewScreenController _uiController = Get.find();

    final _content = Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: kWebMaxWidth),
        padding: EdgeInsets.only(top: 20),
        child: EasyRefresh(
          header: MaterialHeader(),
          onRefresh: _uiController.fetch,
          controller: _uiController.refreshController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  title: Text('Active Trials'),
                  subtitle: Text('active trials',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(_uiController.trials,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Active Subscriptions'),
                  subtitle: Text('active subscribers',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(_uiController.subscribers,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('MRR'),
                  subtitle: Text('monthly recurring revenue',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(
                      _uiController.mrr,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                              .copyWith(color: Colors.lightGreen),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Revenue'),
                  subtitle: Text('last 28 days',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(
                      _uiController.revenue,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                              .copyWith(color: Colors.lightGreen),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('Installs'),
                  subtitle: Text('last 28 days',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(_uiController.installs,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Active Users'),
                  subtitle: Text('last 28 days',
                      style: TextStyle(color: Colors.grey)),
                  trailing: Obx(
                    () => Text(_uiController.users,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
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
        visible: _uiController.busy,
        replacement: Visibility(
          visible: _uiController.error,
          child: EmptyPlaceholder(
            iconData: Icons.error_outline,
            message: _uiController.message.value,
            child: OutlineButton(
              child: Text('Refresh'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: _uiController.fetch,
            ),
          ),
          replacement: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _uiController.fetch,
              child: Icon(Icons.refresh),
            ),
            body: _content,
          ),
        ),
        child: kIsWeb
            ? Opacity(opacity: 0.5, child: _content)
            : Center(
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
