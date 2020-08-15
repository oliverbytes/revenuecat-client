import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

final logger = initLogger("TransactionsScreenController");

class TransactionsScreenController extends BaseController {
  static TransactionsScreenController get to => Get.find();

  // VARIABLES
  final _api = Get.find<GeneralAPI>();
  final refreshController = EasyRefreshController();
  final searchFocusNode = FocusNode();

  // PROPERTIES
  final data = List<Transaction>().obs;
  final date = DateTime.now().obs;
  final ready = false.obs;

  // GETTERS
  int get count => data.value.length;
  String get sinceDate => DateFormat.yMMMd().format(date.value);

  // INIT
  @override
  void onInit() {
    final now = DateTime.now();
    date.value = DateTime(now.year, now.month, now.day, 23, 59, 59);
    super.onInit();
  }

  // FUNCTIONS

  Future<void> refresh() async {
    await fetch();
    ready.value = true;
  }

  Future<void> fetch() async {
    this.busyState();
    final result = await _api.transactions(
        startTimestamp: date.value.millisecondsSinceEpoch, limit: 20);
    refreshController.finishRefresh();

    result.fold(
      (error) =>
          this.errorState(text: 'API Error: ${error.code}!\n${error.message}'),
      (transactions) {
        data.value = transactions;
        this.idleState();
      },
    );
  }

  Future<void> fetchNext() async {
    final lastTimestamp = data.value.last.purchaseDate.millisecondsSinceEpoch;

    final result =
        await _api.transactions(startTimestamp: lastTimestamp, limit: 20);
    refreshController.finishLoad();

    result.fold(
      (error) =>
          this.errorState(text: 'API Error: ${error.code}!\n${error.message}'),
      (transactions) => data.addAll(transactions),
    );
  }

  Future<void> search(String text) async {
    if (text.isEmpty) return;

    this.busyState();
    final result = await _api.transactions(limit: 20, query: text);
    refreshController.finishRefresh();

    result.fold(
      (error) =>
          this.errorState(text: 'API Error: ${error.code}!\n${error.message}'),
      (transactions) {
        data.value = transactions;
        this.idleState();
      },
    );
  }

  void selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime(2007),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) return;

    date.value = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    fetch();
  }
}
