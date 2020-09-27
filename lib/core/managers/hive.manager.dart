import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

final logger = initLogger("HiveManager");

class HiveManager {
  // VARIABLES
  static Box _persistence;
  static ValueListenable persistenceListenable;

  // GETTERS
  static Box get persistence => _persistence;

  static String get cookies =>
      _persistence.get(kCookiesPersistence, defaultValue: '');

  // FUNCTIONS
  static Future<void> setCookie(String cookie) async {
    await _persistence.put(kCookiesPersistence, cookie);
  }

  static Future<void> setAppImageUrl(String appId, String imageUrl) async {
    await _persistence.put('${appId}_image_url', imageUrl);
  }

  static String getAppImageUrl(String appId) {
    return _persistence.get('${appId}_image_url',
        defaultValue: 'https://i.imgur.com/qWD7i5x.png');
  }

  static Future<void> init() async {
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init("${dir.path}/hive/");
    }

    _persistence = await Hive.openBox('persistence');
    persistenceListenable = Hive.box('persistence').listenable();

    if (cookies.isNotEmpty) logger.w('Cookies: $cookies');

    logger.w("init");
  }
}
