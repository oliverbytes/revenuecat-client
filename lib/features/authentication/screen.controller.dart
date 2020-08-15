import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/core/managers/hive.manager.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:app/features/main/screen.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final logger = initLogger("AuthScreenController");

class AuthScreenController extends BaseController {
  // CONSTRUCTOR

  // VARIABLES
  final editingController = TextEditingController();

  // PROPERTIES
  final ready = false.obs;

  // GETTERS

  // INIT

  // FUNCTIONS

  void validate() async {
    this.busyState();
    final token = editingController.text.trim();
    final result = await GeneralAPI.to.isTokenValid(token);

    result.fold((error) {
      this.errorState();
      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Token Error',
          'API Error: ${error.code}!\n${error.message}',
          image: Icon(Icons.error_outline, size: 50),
        ),
      );
    }, (valid) async {
      if (valid) {
        this.idleState();
        await HiveManager.setClientToken(token);
        MainScreenController.to.refresh();
        Get.back(result: true);
      } else {
        this.errorState();
        Get.generalDialog(
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (_, __, ___) => CustomDialog(
            'Token Error',
            'Your token is invalid',
            image: Icon(Icons.error_outline, size: 50),
          ),
        );
      }
    });
  }
}
