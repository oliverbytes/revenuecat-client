import 'package:app/features/main/main.screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'apis/general.api.dart';
import 'constants.dart';
import 'managers/hive.manager.dart';

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
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
    );
  }
}
