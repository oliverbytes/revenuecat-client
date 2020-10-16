import 'package:app/core/apis/general.api.dart';
import 'package:app/core/managers/hive.manager.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:app/features/main/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'session.model.g.dart';

final logger = initLogger('Session');

@HiveType(typeId: 0)
class Session extends HiveObject {
  @HiveField(0)
  String authenticationToken;
  @HiveField(1)
  DateTime authenticationTokenExpiration;

  Session({
    this.authenticationToken,
    this.authenticationTokenExpiration,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        authenticationToken: json["authentication_token"] == null
            ? null
            : json["authentication_token"],
        authenticationTokenExpiration:
            json["authentication_token_expiration"] == null
                ? null
                : DateTime.parse(json["authentication_token_expiration"]),
      );

  Map<String, dynamic> toJson() => {
        "authentication_token":
            authenticationToken == null ? null : authenticationToken,
        "authentication_token_expiration": authenticationTokenExpiration == null
            ? null
            : authenticationTokenExpiration.toIso8601String(),
      };

  static Session current;

  static bool get authenticated => current != null;
  static bool get expired =>
      current.authenticationTokenExpiration.isBefore(DateTime.now());

  static String get token => current?.authenticationToken ?? '';
  static String get email => HiveManager.email;
  static String get password => HiveManager.password;

  static Future<void> init() async {
    current = HiveManager.currentSession;

    if (authenticated) {
      logger.w(
          'Token: ${current.authenticationToken}, Expires: ${current.authenticationTokenExpiration}');
    }
  }

  static Future<void> saveSession(
      Session session, String email, String password) async {
    await HiveManager.saveSession(session, email, password);
    current = session;
  }

  static void logout() async => await HiveManager.logout();

  static Future<void> relogin() async {
    final result = await GeneralAPI.to.login(email, password);

    result.fold((error) {
      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Login Error',
          'API Error: ${error.code}!\n${error.message}',
          image: const Icon(Icons.error_outline, size: 50),
        ),
      );
    }, (session) async {
      // save session & login details
      await saveSession(session, email, password);
      // refresh controllers
      MainScreenController.to.refresh();
    });
  }
}
