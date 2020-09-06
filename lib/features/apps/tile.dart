import 'package:app/core/models/app.model.dart';
import 'package:app/features/general/app_image.widget.dart';
import 'package:flutter/material.dart';

class AppsTile extends StatelessWidget {
  final App object;
  const AppsTile(this.object);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AppImage(app: object),
      title: Text(
        object.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: Text(
        'ID: ${object.id}\nGoogle: ${object.playStorePackageName}\nApple: ${object.bundleId}',
        style: TextStyle(color: Colors.grey, fontSize: 13),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }
}
