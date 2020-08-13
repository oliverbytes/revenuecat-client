import 'package:app/core/apis/general.api.dart';
import 'package:app/core/controllers/base.controller.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/core/models/transactions.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

final logger = initLogger("TransactionsScreenController");

class TransactionsScreenController extends BaseController {
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
    refresh();
    super.onInit();
  }

  // FUNCTIONS

  Future<void> refresh() async {
    await fetch();
    ready.value = true;
  }

  Future<void> fetch() async {
    this.busyState();
    data.value = await _api.transactions(
        startTimestamp: date.value.millisecondsSinceEpoch, limit: 20);
    refreshController.finishRefresh();
    this.idleState();
  }

  Future<void> fetchNext() async {
    this.busyState();
    final lastTimestamp = data.value.last.purchaseDate.millisecondsSinceEpoch;
    final transactions =
        await _api.transactions(startTimestamp: lastTimestamp, limit: 20);
    data.addAll(transactions);
    refreshController.finishLoad();
    this.idleState();
  }

  Future<void> search(String text) async {
    if (text.isEmpty) return;

    this.busyState();
    data.value = await _api.transactions(limit: 20, query: text);
    refreshController.finishRefresh();
    this.idleState();
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
