//
//  SliverListPopverDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/26 16:26.
//  Copyright © 2023/1/26 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class SliverListPopverDemo extends StatefulWidget {
  final String? title;

  const SliverListPopverDemo({Key? key, this.title}) : super(key: key);

  @override
  _SliverListPopverDemoState createState() => _SliverListPopverDemoState();
}

class _SliverListPopverDemoState extends State<SliverListPopverDemo> {
  final _globalKey = GlobalKey();

  var btnIdx = 0;
  var isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: createExample(),
    );
  }

  sectionHeader({Widget? child}) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 20,
        ),
        child: child ?? Text('SliverToBoxAdapter'),
      ),
    );
  }

  Widget buildItem({required Color color}) {
    return Container(
      height: 50,
      color: color,
    );
  }

  createExample() {
    List<Color> colors = Colors.primaries.sublist(5, 10);
    var list = colors.map((e) => buildItem(color: e)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        sectionHeader(child: Text('SliverList - SliverChildListDelegate')),
        SliverList(
          delegate: SliverChildListDelegate(
            list,
          ),
        ),
        buildSection().toSliverToBoxAdapter(),
        sectionHeader(child: Text('SliverList - SliverChildBuilderDelegate')),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return buildItem(color: colors[index]);
          }, childCount: colors.length),
        ),
        sectionHeader(child: Text('SliverFixedExtentList - SliverChildBuilderDelegate')),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return buildItem(color: colors[index]);
            },
            childCount: colors.length,
          ),
          itemExtent: 50,
        ),
      ],
    );
  }

  Widget buildSection() {
    return Stack(
      key: _globalKey,
      clipBehavior: Clip.none,
      children: [
        buildMenu(),
        if (isVisible)
          Positioned(
            // left: 0,
            right: 0.0,
            top: _globalKey.currentContext?.renderBoxSize?.height ?? 30,
            width: context.screenSize.width,
            height: 300.0,
            child: buildDropBox(),
          ),
      ],
    );
  }

  Widget buildMenu({int count = 3}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          count,
          (index) => ElevatedButton(
                onPressed: () {
                  final val = _globalKey.currentContext?.origin();
                  btnIdx = index;
                  isVisible = !isVisible;
                  setState(() {});
                },
                child: Text("菜单$index"),
              )).map((e) => Expanded(child: e)).toList(),
    );
  }

  Widget buildDropBox() {
    return Builder(builder: (context) {
      if (btnIdx == 0) {
        return buildDropBox1();
      }
      if (btnIdx == 1) {
        return buildDropBox2();
      }
      return buildDropBox3();
    });
  }

  Widget buildDropBox1() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.red),
        ),
        child: Center(child: Text("one")));
  }

  Widget buildDropBox2() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 5, color: Colors.yellow),
        ),
        child: Center(child: Text("two")));
  }

  Widget buildDropBox3() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          Column(
            children: [
              ...List.generate(
                  20,
                  (index) => ListTile(
                        title: Text("我是弹窗_$index"),
                      )).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
