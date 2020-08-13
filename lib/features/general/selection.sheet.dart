import 'package:app/features/general/sheet_dismiss_indicator.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class SelectionSheet extends StatelessWidget {
  final Axis direction;
  final List<dynamic> selections;
  final ValueSetter<dynamic> selected;
  final String title;

  const SelectionSheet({
    Key key,
    this.selections,
    this.selected,
    this.direction = Axis.vertical,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _itemBuilder(context, index) {
      final data = selections[index];

      void _onTap() {
        selected(data);
        Get.back();
      }

      Widget _content;

      if (direction == Axis.vertical) {
        _content = ListTile(
          title: Text(data.title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          subtitle: data?.subTitle != null
              ? Text(data.subTitle, style: const TextStyle(color: Colors.grey))
              : null,
          leading: data.icon,
          trailing: (data?.active == true ? Icon(Icons.check_circle) : null),
          onTap: _onTap,
        );
      } else if (direction == Axis.horizontal) {
        _content = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            child: Column(
              children: <Widget>[
                data.icon,
                const SizedBox(height: 10),
                Text(data.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15))
              ],
            ),
            onTap: _onTap,
          ),
        );
      }

      final animationOffset = 50.0;

      return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: direction == Axis.vertical ? animationOffset : 0,
          horizontalOffset: direction == Axis.horizontal ? animationOffset : 0,
          child: FadeInAnimation(child: _content),
        ),
      );
    }

    final _content = ListView.builder(
      shrinkWrap: true,
      itemCount: selections.length,
      itemBuilder: _itemBuilder,
      scrollDirection: direction,
    );

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SheetDimissIndicator(),
          const SizedBox(height: 10),
          if (title != null) ...[Text(title), const SizedBox(height: 5)],
          Flexible(child: AnimationLimiter(child: _content)),
        ],
      ),
    );
  }
}

enum SelectionAction {
  COPY_TRANSACTION_ID,
  COPY_USER_ID,
  COPY_PRODUCT_ID,
}

class BaseSelection {
  final SelectionAction action;
  final String title;
  final String subTitle;
  final Widget icon;
  final bool active;

  BaseSelection({
    this.action,
    this.title,
    this.subTitle,
    this.icon,
    this.active = false,
  });
}
