import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:flutter_templet_project/basicWidget/SliverPersistentHeaderBuilder.dart';

class SliverPersistentHeaderDemo extends StatelessWidget {

  final list = Colors.primaries.take(4).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverPersistentHeader'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          sectionHeader('Header Section 1'),
          SliverGrid.count(
            crossAxisCount: 4,
              children: list.map((e) => Container(color: e)).toList(),
            // children: Colors.accents.map((e) => Container(color: e)).toList(),
          ),
          sectionHeader('Header Section 2'),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: Colors.teal[100 * (index % 9)],
                  child: Text('grid item $index'),
                );
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }

  SliverPersistentHeader sectionHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverPersistentHeaderBuilder(
        min: 60.0,
        max: 60.0,
        builder: (ctx, offset) => SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text(headerText),
            ),
          ),
        ),
      ),
    );
  }

}


