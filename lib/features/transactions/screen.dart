import 'package:app/core/logger.dart';
import 'package:app/features/general/busy_indicator.widget.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:app/features/transactions/screen.controller.dart';
import 'package:app/features/transactions/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

final logger = initLogger('TransactionsScreen');

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _uiController = Get.put(TransactionsScreenController());

    Widget _itemBuilder(context, index) {
      final data = _uiController.data.value[index];

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: TransactionsTile(data),
          ),
        ),
      );
    }

    final _title = AppBar(
      title: Text(
        'Transactions',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: [
        FlatButton.icon(
          icon: Icon(Icons.date_range),
          label: Obx(() => Text(_uiController.sinceDate)),
          onPressed: () => _uiController.selectDate(context),
        ),
      ],
    );

    final _searchBox = Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Obx(
        () => TextField(
          maxLines: 1,
          enabled: !_uiController.busy,
          focusNode: _uiController.searchFocusNode,
          style: const TextStyle(fontWeight: FontWeight.w700),
          onSubmitted: (text) => _uiController.search(text),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            hintStyle: const TextStyle(fontWeight: FontWeight.w700),
            hintText: 'Store Transaction ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );

    final _content = Padding(
      padding: EdgeInsets.only(top: 10),
      child: AnimationLimiter(
        child: Obx(
          () => Column(
            children: [
              _searchBox,
              Visibility(
                visible: _uiController.count == 0,
                replacement: Expanded(
                  child: EasyRefresh(
                    header: MaterialHeader(),
                    footer: MaterialFooter(),
                    onRefresh: _uiController.refresh,
                    onLoad: _uiController.fetchNext,
                    controller: _uiController.refreshController,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _uiController.count,
                      itemBuilder: _itemBuilder,
                      separatorBuilder: (_, __) => Divider(),
                    ),
                  ),
                ),
                child: Expanded(
                  child: EmptyPlaceholder(
                    iconData: Icons.search,
                    message: 'No Results',
                    child: OutlineButton(
                      child: Text('Refresh'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: _uiController.fetch,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: _title,
      body: Obx(
        () => Visibility(
          visible: _uiController.ready.value,
          replacement: Center(child: CircularProgressIndicator()),
          child:
              Opacity(opacity: _uiController.busy ? 0.5 : 1.0, child: _content),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: _uiController.busy,
          child: LinearProgressIndicator(),
        ),
      ),
    );
  }
}
