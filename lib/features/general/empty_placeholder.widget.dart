import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  final IconData iconData;
  final String message;
  final Widget child;
  const EmptyPlaceholder(
      {Key key, @required this.iconData, @required this.message, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 100, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (child != null) ...[
              const SizedBox(height: 10),
              child,
            ]
          ],
        ),
      ),
    );
  }
}
