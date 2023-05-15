import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/constants.dart';

final logger = initLogger("OverviewScreenController");

class OverviewScreenController extends BaseController {
  static OverviewScreenController get to => Get.find();

  // VARIABLES
  final _api = Get.find<GeneralAPI>();
  final refreshController = EasyRefreshController();

  // PROPERTIES
  final overview = Overview().obs;

  // GETTERS
  String get trials => NumberFormat.decimalPattern()
      .format(overview.value?.activeTrialsCount ?? 0);

  String get subscribers => NumberFormat.decimalPattern()
      .format(overview.value?.activeSubscribersCount ?? 0);

  String get mrr =>
      NumberFormat.simpleCurrency().format(overview.value?.mrr ?? 0);

  String get arr =>
      NumberFormat.simpleCurrency().format((overview.value?.mrr ?? 0) * 12);

  String get revenue =>
      NumberFormat.simpleCurrency().format(overview.value?.revenue ?? 0);

  String get installs =>
      NumberFormat.decimalPattern().format(overview.value?.installsCount ?? 0);

  String get users => NumberFormat.decimalPattern()
      .format(overview.value?.activeUsersCount ?? 0);

  // PESO
  String get mrrPhp => NumberFormat.simpleCurrency(locale: 'fil')
      .format((overview.value?.mrr ?? 0) * kPesoUsdRate);

  String get arrPhp => NumberFormat.simpleCurrency(locale: 'fil')
      .format(((overview.value?.mrr ?? 0) * kPesoUsdRate) * 12);

  String get revenuePhp => NumberFormat.simpleCurrency(locale: 'fil')
      .format((overview.value?.revenue ?? 0) * kPesoUsdRate);

  // INIT

  // FUNCTIONS
  Future<void> fetch() async {
    this.busyState();

    overview.value = Overview();
    final result = await _api.overview();

    result.fold(
      (error) =>
          this.errorState(text: 'API Error: ${error.code}!\n${error.message}'),
      (data) {
        overview.value = data;
        this.idleState();
      },
    );
  }
}
