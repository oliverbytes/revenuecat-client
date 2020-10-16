import 'package:app/core/models/hive/session.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final logger = initLogger("HiveManager");

class HiveManager {
  // VARIABLES
  static Box _persistence;
  static Box<Session> _session;

  // GETTERS
  static Box get persistence => _persistence;
  static Box<Session> get session => _session;

  static Session get currentSession =>
      _session.get('session', defaultValue: null);
  static String get email => _persistence.get('email', defaultValue: '');
  static String get password => _persistence.get('password', defaultValue: '');

  // FUNCTIONS

  static Future<void> saveSession(
      Session session, String email, String password) async {
    await _session.put('session', session);
    await _persistence.put('email', email);
    await _persistence.put('password', password);
  }

  static Future<void> logout() async {
    await _persistence.delete('email');
    await _persistence.delete('password');
    await _session.clear();
  }

  static Future<void> setAppImageUrl(String appId, String imageUrl) async {
    await _persistence.put('${appId}_image_url', imageUrl);
  }

  static String getAppImageUrl(String appId) => _persistence.get(
        '${appId}_image_url',
        defaultValue: 'https://i.imgur.com/qWD7i5x.png',
      );

  static Future<void> init() async {
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init("${dir.path}/hive/");
    }

    // REGISTER ADAPTERS
    Hive.registerAdapter(SessionAdapter());

    _persistence = await Hive.openBox('persistence');
    _session = await Hive.openBox('session');

    logger.w("init");
  }
}
