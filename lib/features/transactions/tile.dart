import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/utils.dart';
import 'package:app/features/general/selection.sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

class TransactionsTile extends StatelessWidget {
  final Transaction object;
  const TransactionsTile(this.object);

  @override
  Widget build(BuildContext context) {
    final _subTitleStyle = TextStyle(color: Colors.grey);

    final _badges = object.statuses
        .map(
          (e) => Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: e.color),
            child: Text(
              e.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
        .toList();

    final _title = Text(
      object.app.name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    );

    final _subTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          object.productIdentifier,
          style: _subTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        if (object.expiresDate != null) ...[
          Text(
            'Expires: ${DateFormat.yMMMEd().format(object.expiresDate)}',
            style: _subTitleStyle,
          ),
        ],
        SizedBox(height: 5),
        Wrap(
          children: [
            Icon(
              object.platform.name == 'android'
                  ? Icons.android
                  : Entypo.app_store,
              color: object.platform.color,
              size: 13,
            ),
            SizedBox(width: 5),
            ..._badges,
          ],
        ),
      ],
    );

    final _trailing = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          NumberFormat.simpleCurrency().format(object.revenue),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: object.revenue > 0
                ? Colors.lightGreen
                : object.revenue < 0 ? Colors.red : Colors.grey,
          ),
        ),
        Text(
          Utils.getTimeAgo(dateTime: object.purchaseDate, short: true) + ' ago',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          DateFormat.jm().format(object.purchaseDate),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );

    void _onTap() async {
      List<BaseSelection> selections = [
        BaseSelection(
            action: SelectionAction.COPY_TRANSACTION_ID,
            title: 'Copy Store Transaction ID',
            icon: const Icon(Icons.content_copy)),
        BaseSelection(
            action: SelectionAction.COPY_USER_ID,
            title: 'Copy RC User ID',
            icon: const Icon(Icons.content_copy)),
        BaseSelection(
            action: SelectionAction.COPY_PRODUCT_ID,
            title: 'Copy Product ID',
            icon: const Icon(Icons.content_copy)),
      ];

      final BaseSelection selected = await Utils.showSelectionSheet(selections);

      if (selected != null) {
        if (selected.action == SelectionAction.COPY_TRANSACTION_ID) {
          Utils.copyToClipboard(text: object.storeTransactionIdentifier);
        } else if (selected.action == SelectionAction.COPY_USER_ID) {
          Utils.copyToClipboard(text: object.subscriberId);
        } else if (selected.action == SelectionAction.COPY_PRODUCT_ID) {
          Utils.copyToClipboard(text: object.productIdentifier);
        }
      }
    }

    return ListTile(
      leading: Image.asset(object.app.image, height: 40),
      title: _title,
      subtitle: _subTitle,
      trailing: _trailing,
      onTap: _onTap,
    );
  }
}
