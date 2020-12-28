import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/account.model.dart';
import 'package:app/core/models/app.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final logger = initLogger("AccountController");

class AccountController extends BaseController {
  static AccountController get to => Get.find();

  // VARIABLES
  final _api = Get.find<GeneralAPI>();
  final refreshController = EasyRefreshController();

  // PROPERTIES
  final account = Account().obs;

  // GETTERS
  List<App> get apps => account.value?.apps ?? [];

  String get accountId => account.value?.distinctId ?? '';
  String get accountName => account.value?.name ?? '';
  String get accountEmail => account.value?.email ?? '';
  String get accountPlan => account.value?.currentPlan ?? '';

  int get currentMtr => account.value?.billingInfo?.currentMtr ?? 0;
  int get mtrLimit => account.value?.billingInfo?.mtrLimit ?? 1;

  String get currentMtrFormatted =>
      NumberFormat.simpleCurrency().format(currentMtr);

  String get mtrLimitFormatted =>
      NumberFormat.simpleCurrency().format(mtrLimit);

  String get firstTransactionDate => account.value?.firstTransactionAt != null
      ? DateFormat.yMMMMd().add_jm().format(account.value.firstTransactionAt)
      : 'none';

  // INIT

  // FUNCTIONS
  Future<void> fetch() async {
    this.busyState();
    account.value = Account();

    await _api.account()
      ..fold(
        (error) => this
            .errorState(text: 'API Error: ${error.code}!\n${error.message}'),
        (data) {
          account.value = data;
        },
      );

    this.idleState();
  }
}
