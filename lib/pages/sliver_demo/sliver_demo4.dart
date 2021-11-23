import 'package:flutter/material.dart';

class SliverDemo4 extends StatefulWidget {
  @override
  _SliverDemo4State createState() => _SliverDemo4State();
}

class _SliverDemo4State extends State<SliverDemo4>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: createExample2(),
    );
  }

  /// 图片下拉放大
  Widget createExample2() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: false,
          snap: false,
          pinned: true,
          stretch: true,        // 是否可拉伸
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: Image.asset(
              'images/bg.png',
              fit: BoxFit.cover,
              height: 250,
            ),
            // stretchModes: [StretchMode.zoomBackground],   // 默认就是StretchMode.zoomBackground
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          }, childCount: 20),
        ),
      ],
    );
  }

  /// 导航栏随着滚动方向而展开或收起
  Widget createExample1() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: false,
          snap: false,
          pinned: true,
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: Image.asset(
              'images/flutter-logo-sharing.png',
              fit: BoxFit.cover,
              height: 250,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          }, childCount: 20),
        ),
      ],
    );
  }
}
