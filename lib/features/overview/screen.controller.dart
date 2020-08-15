import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  String get revenue =>
      NumberFormat.simpleCurrency().format(overview.value?.revenue ?? 0);

  String get installs =>
      NumberFormat.decimalPattern().format(overview.value?.installsCount ?? 0);

  String get users => NumberFormat.decimalPattern()
      .format(overview.value?.activeUsersCount ?? 0);

  // INIT

  // FUNCTIONS

  Future<void> fetch() async {
    this.busyState();
    overview.value = Overview();
    final result = await _api.overview();
    this.idleState();

    result.fold(
      (error) =>
          errorState(text: 'API Error: ${error.code}!\n${error.message}'),
      (data) => overview.value = data,
    );
  }
}
