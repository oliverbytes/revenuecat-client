import 'package:app/core/apis/general.api.dart';
import 'package:app/core/base.controller.dart';
import 'package:app/core/logger.dart';
import 'package:app/core/managers/hive.manager.dart';
import 'package:app/core/models/overview.model.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils.dart';
import 'package:app/features/authentication/screen.dart';
import 'package:app/features/general/custom_dialog.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final logger = initLogger("MainScreenController");

class MainScreenController extends BaseController {
  static MainScreenController get to => Get.find();

  // VARIABLES
  final _api = Get.find<GeneralAPI>();

  final refreshController = EasyRefreshController();
  final List<Transaction> overviewTransactions = [];
  DateTime today;
  int startTimestamp = 0;

  // PROPERTIES
  final ready = false.obs;

  final overview = Overview().obs;
  final startDate = DateTime.now().obs;

  final lastPurchase = Transaction().obs;
  final lastRenewal = Transaction().obs;
  final lastConversion = Transaction().obs;

  // ANDROID
  final revenueTodayAndroid = 0.0.obs;
  final renewalsTodayAndroid = 0.obs;
  final trialsTodayAndroid = 0.obs;
  final subscribersTodayAndroid = 0.obs;
  final trialConversionsTodayAndroid = 0.obs;
  final refundsTodayAndroid = 0.obs;
  final transactionsTodayAndroid = 0.obs;

  // IOS
  final revenueTodayIOS = 0.0.obs;
  final renewalsTodayIOS = 0.obs;
  final trialsTodayIOS = 0.obs;
  final subscribersTodayIOS = 0.obs;
  final trialConversionsTodayIOS = 0.obs;
  final refundsTodayIOS = 0.obs;
  final transactionsTodayIOS = 0.obs;

  // GETTERS
  // OVERVIEW BY DATE
  String get revenueToday => NumberFormat.simpleCurrency()
      .format(revenueTodayAndroid.value + revenueTodayIOS.value);

  String get revenueTodayAndroidString =>
      NumberFormat.simpleCurrency().format(revenueTodayAndroid.value);

  String get revenueTodayIOSString =>
      NumberFormat.simpleCurrency().format(revenueTodayIOS.value);

  int get renewalsToday => renewalsTodayAndroid.value + renewalsTodayIOS.value;

  int get trialsToday => trialsTodayAndroid.value + trialsTodayIOS.value;

  int get subscribersToday =>
      subscribersTodayAndroid.value + subscribersTodayIOS.value;

  int get trialConversionsToday =>
      trialConversionsTodayAndroid.value + trialConversionsTodayIOS.value;

  int get refundsToday => refundsTodayAndroid.value + refundsTodayIOS.value;

  int get transactionsToday =>
      transactionsTodayAndroid.value + transactionsTodayIOS.value;

  String get selectedDate => startDate.value.day == DateTime.now().day
      ? 'Today'.toUpperCase()
      : Utils.formatDateTime(startDate.value, shorten: true).toUpperCase();

  String get lastPurchaseDetails => lastPurchase.value.purchaseDate != null
      ? DateFormat.jm().format(lastPurchase.value.purchaseDate.toLocal()) +
          ' - ' +
          NumberFormat.simpleCurrency().format(lastPurchase.value.revenue)
      : '';

  String get lastRenewalDate => lastRenewal.value.purchaseDate != null
      ? DateFormat.jm().format(lastRenewal.value.purchaseDate.toLocal())
      : '';

  String get lastConversionDate => lastConversion.value.purchaseDate != null
      ? DateFormat.jm().format(lastConversion.value.purchaseDate.toLocal())
      : '';

  bool get canGoForward => startDate.value.isBefore(today);

  // OVERVIEW
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
  @override
  void onInit() {
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    startDate.value = today;
    if (HiveManager.clientToken.isNotEmpty) refresh();
    super.onInit();
  }

  @override
  void onReady() {
    if (HiveManager.clientToken.isEmpty) Get.to(AuthScreen());
    super.onInit();
  }

  // FUNCTIONS

  Future<void> refresh() async {
    this.busyState();

    overview.value = Overview();
    _clear();
    await fetchOverview();
    await fetchByDate();
    ready.value = true;

    this.idleState();
  }

  Future<void> fetchOverview() async {
    overview.value = await _api.overview();
  }

  void fetchPrevious() {
    startDate.value = startDate.value.subtract(Duration(days: 1));
    fetchByDate();
  }

  void fetchNext() {
    startDate.value = startDate.value.add(Duration(days: 1));
    fetchByDate();
  }

  void selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate.value,
      firstDate: DateTime(2007),
      lastDate: DateTime.now(),
    );

    startDate.value = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    fetchByDate();
  }

  Future<void> fetchByDate() async {
    this.busyState();

    // CLEAR
    overviewTransactions.clear();
    _clear();

    final _startDate = DateTime(startDate.value.year, startDate.value.month,
        startDate.value.day, 23, 59, 59);
    startTimestamp = _startDate.millisecondsSinceEpoch;

    logger.i('start day: ${_startDate.day}'); // past

    outerloop:
    for (var i = 0; i < 5; i++) {
      logger.i('loop index: $i');

      final transactions =
          await _api.transactions(startTimestamp: startTimestamp, limit: 100);
      if (transactions == null || transactions.isEmpty) {
        logger.e('empty transactions');
        return;
      }

      startTimestamp = transactions.last.purchaseDate.millisecondsSinceEpoch;

      for (var e in transactions) {
        if (e.purchaseDate.toLocal().day == _startDate.day) {
          overviewTransactions.add(e);
        } else {
          logger.i('break day: ${e.purchaseDate.day}');
          break outerloop;
        }
      }

      logger.i('loaded: ${transactions.length}');
    }

    Transaction _lastPurchase, _lastRenewal, _lastConversion;

    await Future.forEach(overviewTransactions, (Transaction e) {
      if (e.platform.name == 'android') {
        revenueTodayAndroid.value += e.revenue;
        transactionsTodayAndroid.value++;
        if (e.isRenewal) renewalsTodayAndroid.value++;
        if (e.isTrialConversion) trialConversionsTodayAndroid.value++;
        if (e.isTrialPeriod) trialsTodayAndroid.value++;
        if (e.expiresDate != null) subscribersTodayAndroid.value++;
        if (e.wasRefunded) refundsTodayAndroid.value++;
      } else if (e.platform.name == 'ios') {
        revenueTodayIOS.value += e.revenue;
        transactionsTodayIOS.value++;
        if (e.isRenewal) renewalsTodayIOS.value++;
        if (e.isTrialConversion) trialConversionsTodayIOS.value++;
        if (e.isTrialPeriod) trialsTodayIOS.value++;
        if (e.expiresDate != null) subscribersTodayIOS.value++;
        if (e.wasRefunded) refundsTodayIOS.value++;
      }

      if (e.revenue > 0 && _lastPurchase == null) _lastPurchase = e;
      if (e.isRenewal && _lastRenewal == null) _lastRenewal = e;
      if (e.isTrialConversion && _lastConversion == null) _lastConversion = e;
    });

    lastPurchase.value = _lastPurchase;
    logger.e('last purchase: ${_lastPurchase.revenue}');
    lastRenewal.value = _lastRenewal;
    lastConversion.value = _lastConversion;

    this.idleState();
  }

  void _clear() {
    revenueTodayAndroid.value = 0;
    renewalsTodayAndroid.value = 0;
    trialsTodayAndroid.value = 0;
    subscribersTodayAndroid.value = 0;
    trialConversionsTodayAndroid.value = 0;
    refundsTodayAndroid.value = 0;
    transactionsTodayAndroid.value = 0;

    revenueTodayIOS.value = 0;
    renewalsTodayIOS.value = 0;
    trialsTodayIOS.value = 0;
    subscribersTodayIOS.value = 0;
    trialConversionsTodayIOS.value = 0;
    refundsTodayIOS.value = 0;
    transactionsTodayIOS.value = 0;

    lastPurchase.value = Transaction();
    lastRenewal.value = Transaction();
    lastConversion.value = Transaction();
  }

  void logOut() {
    Get.generalDialog(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => CustomDialog(
        'Logout?',
        'Are you sure you want to logout?',
        image: Image.asset('assets/images/revenuecat.png', height: 100),
        button: 'Log Out',
        pressed: () {
          HiveManager.setClientToken('');
          Get.to(AuthScreen());
        },
      ),
    );
  }
}
