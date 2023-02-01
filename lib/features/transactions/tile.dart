import 'package:app/core/models/transactions.model.dart';
import 'package:app/core/utils/utils.dart';
import 'package:app/features/general/selection.sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TransactionsTile extends StatelessWidget {
  final Transaction object;
  const TransactionsTile(this.object, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const subTitleStyle = TextStyle(color: Colors.grey);

    final badges = object.statuses
        .map(
          (e) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: e.color,
            ),
            child: Text(
              e.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
        .toList();

    final title = Text(
      object.app.name,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    );

    final subTitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          object.productIdentifier,
          style: subTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        if (object.expiresDate != null) ...[
          Text(
            'Renews: ${DateFormat.yMMMEd().format(object.expiresDate)}',
            style: subTitleStyle,
          ),
        ],
        const SizedBox(height: 5),
        Wrap(
          children: [
            Text(
              object.subscriberCountryCode.isNotEmpty
                  ? EmojiConverter.fromAlpha2CountryCode(
                      object.subscriberCountryCode,
                    )
                  : '🌍',
            ),
            const SizedBox(width: 5),
            Text(
              object.subscriberCountryCode,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 5),
            Icon(
              object.platform.name == 'google'
                  ? Icons.android
                  : Entypo.app_store,
              color: object.platform.color,
              size: 13,
            ),
            const SizedBox(width: 5),
            ...badges,
          ],
        ),
      ],
    );

    final trailing = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          NumberFormat.simpleCurrency().format(object.revenue),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: object.revenue > 0
                ? Colors.lightGreen
                : object.revenue < 0
                    ? Colors.red
                    : Colors.grey,
          ),
        ),
        Text(
          '${Utils.getTimeAgo(dateTime: object.purchaseDate, short: true)} ago',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          DateFormat.jm().format(object.purchaseDate),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );

    void onTap() async {
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
      leading: CachedNetworkImage(
        imageUrl: 'https://www.appatar.io/${object.app.bundleId}/small',
        width: 50,
        height: 50,
      ),
      title: title,
      subtitle: subTitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
