import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/hive/session.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:app/features/main/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final logger = initLogger("LoginScreenController");

class LoginScreenController extends BaseController {
  // CONSTRUCTOR

  // VARIABLES
  final emailEditingController = TextEditingController(text: Session.email);
  final passwordEditingController =
      TextEditingController(text: Session.password);

  // PROPERTIES
  final ready = false.obs;

  // GETTERS

  // INIT

  // FUNCTIONS

  void login() async {
    this.busyState();
    final email = emailEditingController.text.trim();
    final password = passwordEditingController.text.trim();
    final result = await GeneralAPI.to.login(email, password);

    result.fold((error) {
      this.errorState();
      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Login Error',
          'API Error: ${error.code}!\n${error.message}',
          image: const Icon(Icons.error_outline, size: 50),
        ),
      );
    }, (session) async {
      this.idleState();
      // save session & login details
      await Session.saveSession(session, email, password);
      // refresh controllers and close login page
      MainScreenController.to.refresh();
      Get.back(result: true);
    });
  }
}
