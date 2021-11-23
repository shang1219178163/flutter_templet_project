import 'package:flutter/material.dart';

class SliverDemo8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SliverPrototypeExtentList'
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPrototypeExtentList(
            prototypeItem: Container(
              height: 70,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  height: 100,        // 高度设置无效
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              },
              childCount: Colors.primaries.length,
            ),
          ),
        ],
      ),
    );
  }
}