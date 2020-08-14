import 'package:app/features/main/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/apis/general.api.dart';
import 'core/managers/hive.manager.dart';
import 'core/utils/constants.dart';

void main() {
  _init();
}

void _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveManager.init();
  Get.put(GeneralAPI());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: kApptitle,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.grey.withOpacity(0.1)),
      ),
    );
  }
}
