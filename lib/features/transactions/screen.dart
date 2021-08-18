import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:app/features/transactions/screen.controller.dart';
import 'package:app/features/transactions/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

final logger = initLogger('TransactionsScreen');

class TransactionsScreen extends GetView<TransactionsScreenController> {
  @override
  Widget build(BuildContext context) {
    final _searchBox = Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Obx(
        () => TextField(
          maxLines: 1,
          enabled: !controller.busy,
          focusNode: controller.searchFocusNode,
          style: const TextStyle(fontWeight: FontWeight.w700),
          onSubmitted: (text) => controller.search(text),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(right: 15),
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

    Widget _itemBuilder(context, index) {
      final data = controller.data[index];

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(child: TransactionsTile(data)),
        ),
      );
    }

    final _content = Center(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        constraints: BoxConstraints(maxWidth: kWebMaxWidth),
        child: AnimationLimiter(
          child: Obx(
            () => Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _searchBox),
                    TextButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Obx(() => Text(controller.sinceDate)),
                      onPressed: () => controller.selectDate(context),
                    )
                  ],
                ),
                Visibility(
                  visible: controller.count == 0,
                  replacement: Expanded(
                    child: EasyRefresh(
                      header: MaterialHeader(),
                      footer: MaterialFooter(),
                      onRefresh: controller.refresh,
                      onLoad: controller.fetchNext,
                      controller: controller.refreshController,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.count,
                        itemBuilder: _itemBuilder,
                        separatorBuilder: (_, __) => Divider(),
                      ),
                    ),
                  ),
                  child: Expanded(
                    child: EmptyPlaceholder(
                      iconData: Icons.search,
                      message: 'No Results',
                      child: OutlinedButton(
                        child: const Text('Refresh'),
                        onPressed: controller.fetch,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Obx(
      () => Visibility(
        visible: controller.busy,
        replacement: Visibility(
          visible: controller.error,
          child: EmptyPlaceholder(
            iconData: Icons.error_outline,
            message: controller.message(),
            child: OutlinedButton(
              child: const Text('Refresh'),
              onPressed: controller.fetch,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          replacement: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: controller.fetch,
              child: const Icon(Icons.refresh),
            ),
            body: _content,
          ),
        ),
        child: SizedBox(
          height: Get.mediaQuery.size.height,
          width: Get.mediaQuery.size.height,
          child: Shimmer.fromColors(
            child: _content,
            baseColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
