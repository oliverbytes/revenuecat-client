import 'package:app/core/logger.dart';
import 'package:app/features/authentication/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = initLogger('AuthScreen');

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(AuthScreenController());

    final _instructions =
        "Please view the README file for instructions: https://github.com/nemoryoliver/revenuecat-client/blob/master/README.md#installation";

    final _details =
        "We are very grateful that RevenueCat exists! It's now easier to integrate In-App Purchase features in our apps with minimal code and less complexity. Yes, you can use RevenueCat's Web Dashboard to see everything, but come on, an app is better on mobile. ";

    final _content = Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/revenuecat.png', height: 130),
              SizedBox(height: 15),
              Text(
                'RevenueCat',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              ExpansionTile(
                title: Text(
                  'How to obtain the Authorization Token?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                children: [
                  Linkify(
                    text: _instructions,
                    textAlign: TextAlign.center,
                    onOpen: (link) => launch(link.url),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Why use this app? Is it safe?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                children: [
                  Text(_details, textAlign: TextAlign.center),
                ],
              ),
              Divider(),
              TextField(
                controller: _uiController.editingController,
                minLines: 2,
                maxLines: 10,
                textAlign: TextAlign.center,
                enabled: !_uiController.busy,
                style: const TextStyle(fontWeight: FontWeight.w700),
                onSubmitted: (_) => _uiController.validate(),
                onChanged: (text) =>
                    _uiController.ready.value = text.isNotEmpty,
                decoration: InputDecoration(hintText: 'Basic bLaBlaTokenHere'),
              ),
              SizedBox(height: 10),
              Obx(
                () => RaisedButton(
                  onPressed: _uiController.ready.value
                      ? () => _uiController.validate()
                      : null,
                  child: Text('Validate Token'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Divider(),
              Text(
                'This app is not endorsed nor affiliated by RevenueCat. Logo & Trademarks belongs to RevenueCat.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Linkify(
                text:
                    'Open Source & Contributors\nhttps://github.com/nemoryoliver/revenuecat-client',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                linkStyle: TextStyle(color: Get.theme.accentColor),
                textAlign: TextAlign.center,
                onOpen: (link) => launch(link.url),
              ),
              SizedBox(height: 10),
              Linkify(
                text: 'Developer\nhttps://nemorystudios.dev',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                linkStyle: TextStyle(color: Get.theme.accentColor),
                textAlign: TextAlign.center,
                onOpen: (link) => launch(link.url),
              ),
            ],
          ),
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Obx(
          () =>
              Opacity(opacity: _uiController.busy ? 0.5 : 1.0, child: _content),
        ),
        bottomNavigationBar: Obx(
          () => Visibility(
            visible: _uiController.busy,
            child: LinearProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
