import 'dart:convert';

import 'package:app/core/managers/hive.manager.dart';
import 'package:app/core/utils/logger.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

final logger = initLogger('BaseAPI');

class BaseAPI extends GetxController {
  Map<String, String> get baseHeaders => {
        'Authorization': HiveManager.clientToken,
        'X-Requested-With': 'XMLHttpRequest',
      };

  Map<String, String> get baseParams => {};

  Future<Map<String, dynamic>> baseRequest({
    final String function,
    final Map<String, dynamic> params,
    final Map headers,
    final String url,
    final int timeout = 15000,
    final bool debug = false,
  }) async {
    final _dio = Dio(BaseOptions(
      headers: headers,
      method: 'GET',
      responseType: ResponseType.json,
      contentType: 'application/json',
      connectTimeout: timeout,
      receiveTimeout: timeout,
    ));

    Response<String> response;

    try {
      response = await _dio.get<String>(url, queryParameters: params);
    } on DioError catch (e) {
      logger.e('dio error. function: $function, error: ${e.error}');
      return null;
    } catch (e) {
      logger.e('network error. function: $function, error: $e');
      return null;
    }

    return json.decode(response.data);
  }

  Future<bool> validToRequest() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      logger.w(
          "It looks like you are not connected to the internet. Please check your connection.");
      return false;
    }

    if (HiveManager.clientToken.isEmpty) {
      logger.w("Please log in first");
      return false;
    }

    return true;
  }
}
