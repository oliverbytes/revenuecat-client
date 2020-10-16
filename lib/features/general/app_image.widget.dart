import 'package:app/core/managers/hive.manager.dart';
import 'package:app/core/models/app.model.dart';
import 'package:app/core/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_dialog.widget.dart';

class AppImage extends StatelessWidget {
  final App app;
  final double size;
  const AppImage({Key key, @required this.app, this.size = 40.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = HiveManager.getAppImageUrl(app.id);
    final editingController = TextEditingController(text: imageUrl);

    void _updateAppImageUrl() {
      void _update() async {
        if (editingController.text.isNotEmpty) {
          await HiveManager.setAppImageUrl(app.id, editingController.text);

          Utils.showSnackBar(
              title: 'App Image Set Successfully',
              message: 'Refresh to take effect.');
        } else {
          Utils.showSnackBar(
              title: 'App Image Set Error',
              message: 'Please enter a valid image url.');
        }
      }

      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Update App Image',
          "Grab ${app.name}'s image url and paste it below",
          image:
              CachedNetworkImage(imageUrl: imageUrl, width: 100, height: 100),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            controller: editingController,
            decoration:
                InputDecoration(hintText: 'https://appimage.url/here.png'),
            textInputAction: TextInputAction.done,
            validator: (text) =>
                text.isEmpty ? 'Please enter a valid image url.' : '',
            textAlign: TextAlign.center,
          ),
          button: 'Update',
          pressed: _update,
        ),
      );
    }

    return InkWell(
      child: CachedNetworkImage(imageUrl: imageUrl, width: size, height: size),
      onTap: _updateAppImageUrl,
    );
  }
}
