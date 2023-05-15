import 'package:app/core/apis/base.api.dart';
import 'package:app/core/models/account.model.dart';
import 'package:app/core/models/api_error.model.dart';
import 'package:app/core/models/hive/session.model.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:either_option/either_option.dart';
import 'package:get/get.dart';

final logger = initLogger('GeneralAPI');

class GeneralAPI extends BaseAPI {
  static GeneralAPI get to => Get.find();

  Future<Either<ApiError, Session>> login(String email, String password) async {
    if (!await internetConnected()) {
      return Left(ApiError(code: 0, message: kInternetError));
    }

    final result = await baseRequest(
      function: "login",
      headers: {'X-Requested-With': 'XMLHttpRequest'},
      url: loginUrl,
      debug: true,
      method: 'POST',
      params: {'email': email, 'password': password},
    );

    return result.fold(
      (error) => Left(error),
      (data) => Right(Session.fromJson(data)),
    );
  }

  Future<Either<ApiError, Overview>> overview() async {
    if (!await internetConnected()) {
      return Left(ApiError(code: 0, message: kInternetError));
    }

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

  Future<Either<ApiError, Account>> account() async {
    if (!await internetConnected()) {
      return Left(ApiError(code: 0, message: kInternetError));
    }

    final result = await baseRequest(
      function: "me",
      headers: baseHeaders,
      url: meUrl,
      debug: true,
    );

    return result.fold(
      (error) => Left(error),
      (data) => Right(Account.fromJson(data)),
    );
  }

  Future<Either<ApiError, List<Transaction>>> transactions({
    int startTimestamp,
    int endTimestamp,
    int limit = 100,
    String query,
  }) async {
    if (!await internetConnected()) {
      return Left(ApiError(code: 0, message: kInternetError));
    }

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
