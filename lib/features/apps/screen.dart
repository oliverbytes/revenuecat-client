import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/apps/tile.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:app/core/controllers/account.controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

final logger = initLogger('AppsScreen');

class AppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AccountController _uiController = Get.find();

    Widget _itemBuilder(context, index) {
      final data = _uiController.apps[index];

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(child: AppsTile(data)),
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
                Visibility(
                  visible: _uiController.apps.length == 0,
                  replacement: Expanded(
                    child: EasyRefresh(
                      header: MaterialHeader(),
                      footer: MaterialFooter(),
                      onRefresh: _uiController.fetch,
                      controller: _uiController.refreshController,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _uiController.apps.length,
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
                        child: const Text('Refresh'),
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
      ),
    );

    return Obx(
      () => Visibility(
        visible: _uiController.busy,
        replacement: Visibility(
          visible: _uiController.error,
          child: EmptyPlaceholder(
            iconData: Icons.error_outline,
            message: _uiController.message.value,
            child: OutlineButton(
              child: const Text('Refresh'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: _uiController.fetch,
            ),
          ),
          replacement: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: _uiController.fetch,
              child: const Icon(Icons.refresh),
            ),
            body: _content,
          ),
        ),
        child: kIsWeb
            ? Opacity(opacity: 0.5, child: _content)
            : SizedBox(
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
