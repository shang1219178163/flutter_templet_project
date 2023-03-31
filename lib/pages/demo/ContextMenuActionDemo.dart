//
//  ContextMenuActionDemo.dart
//  flutter_templet_project
//
//  Created by shang on 8/16/21 9:33 AM.
//  Copyright © 8/16/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContextMenuActionDemo extends StatelessWidget {

  final String? title;

  const ContextMenuActionDemo({
  	Key? key,
  	this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(arguments[1]),
        ),
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CupertinoContextMenu(
              actions: <Widget>[
                CupertinoContextMenuAction(
                  trailingIcon: Icons.chevron_right,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Action one'),
                ),
                CupertinoContextMenuAction(
                  trailingIcon: Icons.chevron_right,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Action two'),
                ),
              ],
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
        ),
    );
  }
}