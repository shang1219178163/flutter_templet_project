//
//	ReorderableListViewDemo.dart
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 15:42
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/material.dart';


/// This is the stateful widget that the main application instantiates.
class ReorderableListViewDemo extends StatefulWidget {
  const ReorderableListViewDemo({Key? key}) : super(key: key);

  @override
  State<ReorderableListViewDemo> createState() => _ReorderableListViewDemoState();
}

/// This is the private State class that goes with ReorderableListViewDemo.
class _ReorderableListViewDemoState extends State<ReorderableListViewDemo> {
  final List<int> _items = List<int>.generate(50, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: ReorderableListView(
        // padding: EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < _items.length; index++)
            ListTile(
              key: Key('$index'),
              tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
              title: Text('Item ${_items[index]}'),
              trailing: Icon(Icons.drag_handle),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final int item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
