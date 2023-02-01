import 'package:app/core/models/app.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppsTile extends StatelessWidget {
  final App object;
  const AppsTile(this.object, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: 'https://www.appatar.io/${object.bundleId}/small',
        width: 50,
        height: 50,
      ),
      title: Text(
        object.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: Text(
        'ID: ${object.id}\nGoogle: ${object.playStorePackageName}\nApple: ${object.bundleId}',
        style: const TextStyle(color: Colors.grey, fontSize: 13),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }
}
