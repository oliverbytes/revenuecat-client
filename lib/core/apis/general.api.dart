import 'package:app/core/apis/base.api.dart';
import 'package:app/core/models/api_error.model.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';
import 'package:get/get.dart';

final logger = initLogger('GeneralAPI');

class GeneralAPI extends BaseAPI {
  static GeneralAPI get to => Get.find();

  Future<Either<ApiError, bool>> isTokenValid(String token) async {
    if (!await internetConnected())
      return Left(ApiError(code: 0, message: kInternetError));

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
      final response = await Dio(options).get(overviewUrl);
      logger.i('status: ${response.statusCode}, data: ${response.data}');
      return Right(true);
    } on DioError catch (e) {
      logger.e('dio error. error: ${e.error}');

      return Left(
        ApiError(
          code: 0,
          message: 'Please verify your token freshly copied and valid.',
        ),
      );
    } catch (e) {
      logger.e('network error. error: $e');
      return Left(ApiError(code: 0, message: '$kInternetError: $e'));
    }
  }

  Future<Either<ApiError, Overview>> overview() async {
    if (!await internetConnected())
      return Left(ApiError(code: 0, message: kInternetError));

    final result = await baseRequest(
      function: "overview",
      headers: baseHeaders,
      url: overviewUrl,
      debug: true,
    );

    return result.fold(
      (error) => Left(error),
      (data) => Right(Overview.fromJson(data)),
    );
  }

  Future<Either<ApiError, List<Transaction>>> transactions({
    int startTimestamp,
    int endTimestamp,
    int limit = 100,
    String query,
  }) async {
    if (!await internetConnected())
      return Left(ApiError(code: 0, message: kInternetError));

    final Map<String, dynamic> params = {
      'limit': limit,
    };

    if (startTimestamp != null) {
      params['start_from'] = startTimestamp; // past
    }

    if (query != null) {
      params['store_transaction_identifier'] = query;
    }

    final result = await baseRequest(
      function: "transactions",
      headers: baseHeaders,
      url: transactionsUrl,
      params: params,
      debug: true,
    );

    return result.fold(
      (error) => Left(error),
      (data) => Right(RootTransactions.fromJson(data).transactions),
    );
  }
}
