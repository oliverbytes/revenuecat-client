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
        "To obtain your RevenueCat Authorization Token, fire up your development machine and open your favorite browser > Go to RevenueCat's website and make sure you're logged in already. Open the browser's Developer Console > Go to Network Tab > apply filter: api.revenuecat.com > open any logged traffic (some may not include the token, so take your time hunting) > Go to Headers Tab > then find the token in the Request Headers section.";

    final _details =
        "We are very grateful that RevenueCat exists! It's now super easy to integrate In App Purchases feature with minimal code required and no complexity. Yes, you can use the Web Dashboard to see everything, but we feel that an app is better especially on mobile. This app is Open Source, but please use at your own risk.";

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
                  Text(_instructions, textAlign: TextAlign.center),
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
                'By logging in, you agree that you will be responsible for any unfortunate circumstances our app can do to your account.\nThis app is not endorsed nor affiliated by RevenueCat. Logo belongs to RevenueCat.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Linkify(
                text: 'Developed by: Nemory Studios\nhttps://nemorystudios.dev',
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
