import 'package:app/core/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'screen.controller.dart';

final logger = initLogger('OverviewScreen');

class OverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(OverviewScreenController());

    final _content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.access_alarm),
          title: Text('Active Trials'),
          subtitle: Text('active trials', style: TextStyle(color: Colors.grey)),
          trailing: Obx(
            () => Text(_uiController.trials,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.refresh),
          title: Text('Active Subscriptions'),
          subtitle:
              Text('active subscribers', style: TextStyle(color: Colors.grey)),
          trailing: Obx(
            () => Text(_uiController.subscribers,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                  .copyWith(color: Colors.lightGreen),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text('Revenue'),
          subtitle: Text('last 28 days', style: TextStyle(color: Colors.grey)),
          trailing: Obx(
            () => Text(
              _uiController.revenue,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
                  .copyWith(color: Colors.lightGreen),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.phone_android),
          title: Text('Installs'),
          subtitle: Text('last 28 days', style: TextStyle(color: Colors.grey)),
          trailing: Obx(
            () => Text(_uiController.installs,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Active Users'),
          subtitle: Text('last 28 days', style: TextStyle(color: Colors.grey)),
          trailing: Obx(
            () => Text(_uiController.users,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );

    return SizedBox(
      height: Get.mediaQuery.size.height,
      width: Get.mediaQuery.size.height,
      child: Obx(
        () => Visibility(
          visible: _uiController.busy,
          replacement: _content,
          child: Shimmer.fromColors(
            child: _content,
            baseColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
