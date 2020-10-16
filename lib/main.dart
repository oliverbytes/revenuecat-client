import 'package:app/features/main/screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/managers/hive.manager.dart';
import 'core/utils/constants.dart';

void main() => _init();

void _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await HiveManager.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: kApptitle,
      home: MainScreen(),
      initialBinding: MainScreenBinding(),
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
