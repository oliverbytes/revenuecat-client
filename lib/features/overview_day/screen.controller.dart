import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final logger = initLogger("OverviewDayScreenController");

class OverviewDayScreenController extends BaseController {
  static OverviewDayScreenController get to => Get.find();

  // VARIABLES
  final _api = Get.find<GeneralAPI>();
  final refreshController = EasyRefreshController();

  final List<Transaction> overviewTransactions = [];
  DateTime today;
  int _nextTimestamp = 0;

  // PROPERTIES
  final startDate = DateTime.now().obs;

  final lastPurchase = Transaction().obs;
  final lastRenewal = Transaction().obs;
  final lastConversion = Transaction().obs;

  // ANDROID
  final revenueAndroid = 0.0.obs;
  final purchasesAndroid = 0.obs;
  final renewalsAndroid = 0.obs;
  final trialsAndroid = 0.obs;
  final subscribersAndroid = 0.obs;
  final trialConversionsAndroid = 0.obs;
  final refundsAndroid = 0.obs;
  final transactionsAndroid = 0.obs;

  // IOS
  final revenueIOS = 0.0.obs;
  final purchasesIOS = 0.obs;
  final renewalsIOS = 0.obs;
  final trialsIOS = 0.obs;
  final subscribersIOS = 0.obs;
  final trialConversionsIOS = 0.obs;
  final refundsIOS = 0.obs;
  final transactionsIOS = 0.obs;

  // GETTERS
  // OVERVIEW BY DATE
  String get revenueTotal => NumberFormat.simpleCurrency()
      .format(revenueAndroid.value + revenueIOS.value);

  String get revenueAndroidString =>
      NumberFormat.simpleCurrency().format(revenueAndroid.value);

  String get revenueIOSString =>
      NumberFormat.simpleCurrency().format(revenueIOS.value);

  int get purchasesCount => purchasesAndroid.value + purchasesIOS.value;

  int get renewalsCount => renewalsAndroid.value + renewalsIOS.value;

  int get trialsCount => trialsAndroid.value + trialsIOS.value;

  int get subscribersCount => subscribersAndroid.value + subscribersIOS.value;

  int get trialConversionsCount =>
      trialConversionsAndroid.value + trialConversionsIOS.value;

  int get refundsCount => refundsAndroid.value + refundsIOS.value;

  int get transactionsCount =>
      transactionsAndroid.value + transactionsIOS.value;

  String get selectedDate => startDate.value.day == DateTime.now().day
      ? 'TODAY'
      : DateFormat.yMMMEd().format(startDate.value).toUpperCase();

  String get lastPurchaseDetails => lastPurchase.value?.purchaseDate != null
      ? DateFormat.jm().format(lastPurchase.value.purchaseDate) +
          ' - ' +
          NumberFormat.simpleCurrency().format(lastPurchase.value.revenue ?? 0)
      : 'none';

  String get lastRenewalDate => lastRenewal.value?.purchaseDate != null
      ? DateFormat.jm().format(lastRenewal.value.purchaseDate)
      : 'none';

  String get lastConversionDate => lastConversion.value?.purchaseDate != null
      ? DateFormat.jm().format(lastConversion.value.purchaseDate)
      : 'none';

  bool get canGoNext => startDate.value.isBefore(today);
  bool get canGoPrevious => startDate.value.isAfter(DateTime(2007));

  // INIT
  @override
  void onInit() {
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    startDate.value = today;
    super.onInit();
  }

  // FUNCTIONS

  void fetchPrevious() {
    startDate.value = startDate.value.subtract(Duration(days: 1));
    fetch();
  }

  void fetchNext() {
    startDate.value = startDate.value.add(Duration(days: 1));
    fetch();
  }

  Future<void> fetch() async {
    this.busyState();

    _clear();

    final _startDate = DateTime(startDate.value.year, startDate.value.month,
        startDate.value.day, 23, 59, 59);
    _nextTimestamp = _startDate.millisecondsSinceEpoch;

    logger.i('start day: ${_startDate.day}'); // past

    loop:
    for (var i = 0; i <= 5; i++) {
      logger.i('loop index: $i');

      final result =
          await _api.transactions(startTimestamp: _nextTimestamp, limit: 100);

      bool breakLoop = false;

      result.fold((error) {
        errorState(text: 'API Error: ${error.code}!\n${error.message}');
        breakLoop = true;
        return;
      }, (transactions) {
        if (transactions == null || transactions.isEmpty) {
          errorState(text: 'No results');
          breakLoop = true;
          return;
        }

        _nextTimestamp = transactions.last.purchaseDate.millisecondsSinceEpoch;

        for (var e in transactions) {
          if (e.purchaseDate.day == _startDate.day) {
            overviewTransactions.add(e);
          } else {
            logger.i('break day: ${e.purchaseDate.day}');
            breakLoop = true;
            break;
          }
        }

        logger.i('loaded: ${transactions.length}');
      });

      if (breakLoop) break loop;
    }

    if (state.value == BaseState.Error) return;

    logger.e('for each');

    Transaction _lastPurchase, _lastRenewal, _lastConversion;

    await Future.forEach(overviewTransactions, (Transaction e) {
      if (e.platform.name == 'android') {
        revenueAndroid.value += e.revenue;
        transactionsAndroid.value++;

        if (e.revenue > 0) purchasesAndroid.value++;
        if (e.isRenewal) renewalsAndroid.value++;
        if (e.isTrialConversion) trialConversionsAndroid.value++;
        if (e.isTrialPeriod) trialsAndroid.value++;
        if (e.expiresDate != null) subscribersAndroid.value++;
        if (e.wasRefunded) refundsAndroid.value++;
      } else if (e.platform.name == 'ios') {
        revenueIOS.value += e.revenue;
        transactionsIOS.value++;

        if (e.revenue > 0) purchasesIOS.value++;
        if (e.isRenewal) renewalsIOS.value++;
        if (e.isTrialConversion) trialConversionsIOS.value++;
        if (e.isTrialPeriod) trialsIOS.value++;
        if (e.expiresDate != null) subscribersIOS.value++;
        if (e.wasRefunded) refundsIOS.value++;
      }

      if (e.revenue > 0 && _lastPurchase == null) _lastPurchase = e;
      if (e.isRenewal && _lastRenewal == null) _lastRenewal = e;
      if (e.isTrialConversion && _lastConversion == null) _lastConversion = e;
    });

    lastPurchase.value = _lastPurchase;
    lastRenewal.value = _lastRenewal;
    lastConversion.value = _lastConversion;

    this.idleState();
  }

  void selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate.value,
      firstDate: DateTime(2007),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;

    startDate.value = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    fetch();
  }

  void _clear() {
    overviewTransactions.clear();

    purchasesAndroid.value = 0;
    revenueAndroid.value = 0;
    renewalsAndroid.value = 0;
    trialsAndroid.value = 0;
    subscribersAndroid.value = 0;
    trialConversionsAndroid.value = 0;
    refundsAndroid.value = 0;
    transactionsAndroid.value = 0;

    purchasesIOS.value = 0;
    revenueIOS.value = 0;
    renewalsIOS.value = 0;
    trialsIOS.value = 0;
    subscribersIOS.value = 0;
    trialConversionsIOS.value = 0;
    refundsIOS.value = 0;
    transactionsIOS.value = 0;

    lastPurchase.value = Transaction();
    lastRenewal.value = Transaction();
    lastConversion.value = Transaction();
  }
}
