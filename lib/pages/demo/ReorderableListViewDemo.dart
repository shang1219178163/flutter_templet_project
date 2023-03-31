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

  final  _items = List<int>.generate(20, (int index) => index);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    final colorScheme = Theme.of(context).colorScheme;
    final oddItemColor = colorScheme.primary.withOpacity(0.05);
    final evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      // padding: EdgeInsets.symmetric(horizontal: 40),
      children: _items.map((e) => ListTile(
        key: Key('$e'),
        tileColor: e.isOdd ? oddItemColor : evenItemColor,
        title: Text('Item $e'),
        trailing: Icon(Icons.drag_handle),
      )).toList(),
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }

}
