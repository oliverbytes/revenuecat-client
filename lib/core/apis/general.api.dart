import 'package:app/core/apis/base.api.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final logger = initLogger('GeneralAPI');

class GeneralAPI extends BaseAPI {
  static GeneralAPI get to => Get.find();

  Future<bool> isTokenValid(String token) async {
    Response<String> response;

    final options = BaseOptions(
      headers: {
        'Authorization': token,
        'X-Requested-With': 'XMLHttpRequest',
      },
      method: 'GET',
      responseType: ResponseType.json,
      contentType: 'application/json',
      connectTimeout: 15000,
      receiveTimeout: 15000,
    );

    try {
      response = await Dio(options).get<String>(overviewUrl);
      logger.i('status: ${response.statusCode}, data: ${response.data}');
      if (response.statusCode == 200) return true;
    } on DioError catch (e) {
      logger.e('dio error. error: ${e.error}');

      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Token Error',
          "Please verify your token freshly copied and valid.",
          image: Icon(Icons.error_outline),
        ),
      );
      return false;
    } catch (e) {
      logger.e('network error. error: $e');

      Get.generalDialog(
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, __, ___) => CustomDialog(
          'Network Error',
          "Please check your connection and try again.",
          image: Icon(Icons.error_outline),
        ),
      );
      return false;
    }

    return false;
  }

  Future<Overview> overview() async {
    if (!await validToRequest()) return null;

    final _function = "overview";

    final jsonMap = await baseRequest(
      function: _function,
      headers: baseHeaders,
      url: overviewUrl,
    );

    return Overview.fromJson(jsonMap);
  }

  Future<List<Transaction>> transactions({
    int startTimestamp,
    int endTimestamp,
    int limit = 100,
    String query,
  }) async {
    if (!await validToRequest()) return null;

    final _function = "transactions";

    final Map<String, dynamic> params = {
      'limit': limit,
    };

    if (startTimestamp != null) {
      params['start_from'] = startTimestamp; // past
    }

    if (query != null) {
      params['store_transaction_identifier'] = query;
    }

    final jsonMap = await baseRequest(
      function: _function,
      headers: baseHeaders,
      url: transactionsUrl,
      params: params,
    );

    return RootTransactions.fromJson(jsonMap).transactions;
  }
}
