import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';

class SliverPersistentHeaderDemo extends StatelessWidget {
  SliverPersistentHeaderDemo({Key? key}) : super(key: key);

  final list = Colors.primaries.take(8).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverPersistentHeader'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          sectionHeader(text: Text('Header Section 1'), pinned: false),
          SliverGrid.count(
            crossAxisCount: 4,
            children: list.map((e) => Container(color: e)).toList(),
            // children: Colors.accents.map((e) => Container(color: e)).toList(),
          ),
          sectionHeader(text: Text('Header Section 2'), pinned: true),
          buildSliverGrid(count: 100),
          sectionHeader(text: Text('Header Section 3'), pinned: false),
          buildSliverGrid(count: 101),
        ],
      ),
    );
  }

  SliverPersistentHeader sectionHeader(
      {required Text text, bool pinned = false}) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: NSliverPersistentHeaderDelegate(
        min: 60.0,
        max: 80.0,
        builder: (ctx, offset, overlapsContent) => SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Center(
              child: text,
            ),
          ),
        ),
      ),
    );
  }

  buildSliverGrid({int count = 100}) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 4.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            alignment: Alignment.center,
            color: Colors.teal[100 * (index % 9)],
            child: Text('grid item $index'),
          );
        },
        childCount: count,
      ),
    );
  }
}
