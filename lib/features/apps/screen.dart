import 'package:app/core/controllers/account.controller.dart';
import 'package:app/core/utils/constants.dart';
import 'package:app/core/utils/logger.dart';
import 'package:app/features/apps/tile.dart';
import 'package:app/features/general/empty_placeholder.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

final logger = initLogger('AppsScreen');

class AppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AccountController controller = Get.find();

    Widget _itemBuilder(context, index) {
      final data = controller.apps[index];

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
                  visible: controller.apps.length == 0,
                  replacement: Expanded(
                    child: EasyRefresh(
                      header: MaterialHeader(),
                      footer: MaterialFooter(),
                      onRefresh: controller.fetch,
                      controller: controller.refreshController,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: controller.apps.length,
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
