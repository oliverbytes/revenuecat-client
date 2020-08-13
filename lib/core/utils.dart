import 'package:app/features/general/selection.sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'logger.dart';

final logger = initLogger('Utils');

class Utils {
  static String getTimeAgo({final DateTime dateTime, bool short = true}) {
    return timeago
        .format(dateTime, locale: short ? 'en_short' : 'en')
        .replaceFirst("~", "");
  }

  static void copyToClipboard({@required final String text}) async {
    await Clipboard.setData(ClipboardData(text: text));
    showSnackBar(
        title: "Copied To Clipboard",
        message: "Successfully copied to clipboard");
  }

  static showSnackBar({
    @required String title,
    @required String message,
    final Widget icon,
    final Color backgroundColor,
    int seconds = 3,
  }) async {
    Get.snackbar(
      title,
      message,
      icon: icon ?? Icon(Icons.info, size: 25),
      titleText: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      messageText: Text(message, style: TextStyle(fontSize: 14)),
      duration: Duration(seconds: seconds),
      borderRadius: 8,
      backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
      shouldIconPulse: true,
      margin: EdgeInsets.fromLTRB(8, 8, 8, 8.0),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static Future<dynamic> showSelectionSheet(List<dynamic> selections,
      {final double height,
      final Axis direction = Axis.vertical,
      final String title}) async {
    dynamic selected;

    final sheet = SelectionSheet(
      title: title,
      selections: selections,
      direction: direction,
      selected: (selection) => selected = selection,
    );

    await Get.bottomSheet(
      height == null ? sheet : SizedBox(height: height, child: sheet),
      isScrollControlled: height != null,
      backgroundColor: Color(0xFF171717),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
    );

    return selected;
  }

  static String formatDateTime(final DateTime date,
      {final bool shorten = false}) {
    if (date == null) return '';

    String formatMonthIndex(int index) {
      switch (index) {
        case DateTime.january:
          return "January";
          break;
        case DateTime.february:
          return "February";
          break;
        case DateTime.march:
          return "March";
          break;
        case DateTime.april:
          return "April";
          break;
        case DateTime.may:
          return "May";
          break;
        case DateTime.june:
          return "June";
          break;
        case DateTime.july:
          return "July";
          break;
        case DateTime.august:
          return "August";
          break;
        case DateTime.september:
          return "September";
          break;
        case DateTime.october:
          return "October";
          break;
        case DateTime.november:
          return "November";
          break;
        case DateTime.december:
          return "December";
          break;
        default:
          return "(Invalid Month)";
      }
    }

    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final ampm = date.hour > 12 ? "PM" : "AM";

    final short = "${formatMonthIndex(date.month)} ${date.day}, ${date.year}";
    final long = "$short - $hour:${date.minute}:${date.second}$ampm";

    return shorten ? short : long;
  }
}
