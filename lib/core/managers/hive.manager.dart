import 'package:app/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final logger = initLogger("HiveManager");

class HiveManager {
  // VARIABLES
  static Box _persistence;
  static ValueListenable persistenceListenable;

  // GETTERS
  static Box get persistence => _persistence;

  static String get clientToken =>
      _persistence.get('client_token', defaultValue: '');

  // FUNCTIONS
  static Future<void> setClientToken(String token) async {
    await _persistence.put('client_token', token);
  }

  static Future<void> init() async {
    _persistence = await Hive.openBox('persistence');
    persistenceListenable = Hive.box('persistence').listenable();
    logger.w("init");
  }
}
