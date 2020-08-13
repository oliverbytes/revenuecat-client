import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class BusyIndicator extends StatelessWidget {
  final String message;
  final Color color;

  const BusyIndicator({Key key, this.message, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingCube(
              color: Get.theme.accentColor,
              size: 35,
              duration: const Duration(milliseconds: 2000),
            ),
            if (message != null) ...[const SizedBox(height: 20), Text(message)]
          ],
        ),
      ),
    );
  }
}
