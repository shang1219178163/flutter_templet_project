//
//  BottomSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 1:31 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/navigator_extension.dart';

class BottomSheetDemo extends StatelessWidget {
  final String? title;

  const BottomSheetDemo({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("$this"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Builder(
      builder: (context) {
        return Center(
          child: TextButton(
            child: Text('SHOW BOTTOM SHEET'),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildList(context),
                        Positioned(
                          top: -30,
                          right: 15,
                          child: FloatingActionButton(
                              foregroundColor: Colors.blue,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.directions_bike),
                              onPressed: () {
                                ddlog("directions_bike");
                              }),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  _buildList(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        Container(
          height: 80,
          color: theme.colorScheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Header',
                  style: theme.textTheme.subtitle1!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'this is subtitle',
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                    Text(
                      "trailing",
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButtonExt.build(
                text: Text("CALL"),
                image: Icon(Icons.call),
                imageAlignment: ImageAlignment.top,
                callback: (value) {
                  ddlog(value.data);
                }),
            TextButtonExt.build(
                text: Text("SHARE"),
                image: Icon(Icons.share_outlined),
                imageAlignment: ImageAlignment.top,
                callback: (value) {
                  ddlog(value.data);
                }),
            TextButtonExt.build(
                text: Text("SAVE"),
                image: Icon(Icons.playlist_add),
                imageAlignment: ImageAlignment.top,
                callback: (value) {
                  ddlog(value.data);
                }),
          ],
        ),
        Divider(),
        ListTile(
            leading: Icon(Icons.share, color: Theme.of(context).colorScheme.secondary),
            title: Text('Share'),
            onTap: () {
              ddlog("share");
            }),
        ListTile(
            leading: Icon(Icons.link, color: Theme.of(context).colorScheme.secondary),
            title: Text('Get link'),
            onTap: () {
              ddlog("link");
            }),
        ListTile(
            leading: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary),
            title: Text('Edit name'),
            onTap: () {
              ddlog("name");
            }),
        ListTile(
            leading: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
            title: Text('Delete collection'),
            onTap: () {
              ddlog("collection");
            }),
      ],
    );
  }
}
