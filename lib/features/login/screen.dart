import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/login/screen.controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = initLogger('LoginScreen');

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginScreenController());

    final _details =
        "We are very grateful that RevenueCat exists! It's now easier to integrate In-App Purchase features in our apps with minimal code and less complexity. Yes, you can use RevenueCat's Web Dashboard to see everything, but come on, an app is better on mobile. ";

    final _content = Center(
      child: Container(
        padding: EdgeInsets.all(20),
        constraints: BoxConstraints(maxWidth: kWebMaxWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/revenuecat.png', height: 130),
              const SizedBox(height: 15),
              const Text(
                'RevenueCat',
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              ExpansionTile(
                title: const Text(
                  'Why use this app? Is it safe?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                children: [
                  Text(_details, textAlign: TextAlign.center),
                ],
              ),
              const Divider(),
              TextField(
                controller: controller.emailEditingController,
                textAlign: TextAlign.center,
                enabled: !controller.busy,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: InputDecoration(hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.login(),
                onChanged: (text) => controller.ready(text.isNotEmpty),
              ),
              TextField(
                controller: controller.passwordEditingController,
                textAlign: TextAlign.center,
                enabled: !controller.busy,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: InputDecoration(hintText: 'Password'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.login(),
                onChanged: (text) => controller.ready(text.isNotEmpty),
              ),
              const SizedBox(height: 10),
              Obx(
                () => RaisedButton(
                  onPressed:
                      controller.ready() ? () => controller.login() : null,
                  child: const Text('Validate Token'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const Divider(),
              const Text(
                'This app is not endorsed nor affiliated by RevenueCat. Logo & Trademarks belongs to RevenueCat.',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Linkify(
                text:
                    'Open Source & Contributors\nhttps://github.com/nemoryoliver/revenuecat-client',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                linkStyle: TextStyle(color: Get.theme.accentColor),
                textAlign: TextAlign.center,
                onOpen: (link) => launch(link.url),
              ),
              const SizedBox(height: 10),
              Linkify(
                text: 'Developer\nhttps://nemorystudios.dev',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
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
          () => Visibility(
            visible: controller.busy,
            replacement: _content,
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
        ),
      ),
    );
  }
}
