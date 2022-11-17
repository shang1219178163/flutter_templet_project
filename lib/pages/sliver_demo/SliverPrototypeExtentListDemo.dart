import 'package:flutter/material.dart';

class SliverPrototypeExtentListDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverPrototypeExtentList'),
      ),
      body: _buildList(),
    );
  }

  _buildList() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPrototypeExtentList(
          prototypeItem: Container(
            height: 70,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                height: 100,        // 高度设置无效
                color: Colors.primaries[index],
              );
            },
            childCount: Colors.primaries.length,
          ),
        ),
      ],
    );
  }
}