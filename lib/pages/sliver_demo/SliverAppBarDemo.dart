import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class SliverAppBarDemo extends StatefulWidget {
  const SliverAppBarDemo({Key? key}) : super(key: key);

  @override
  _SliverAppBarDemoState createState() => _SliverAppBarDemoState();
}

class _SliverAppBarDemoState extends State<SliverAppBarDemo> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("$widget"),
      //   actions: ['done',].map((e) => TextButton(
      //     onPressed: () => debugPrint(e.toString()),
      //     child: Text(e,
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   )).toList(),
      // ),
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
          stretch: true, // 是否可拉伸
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('SliverAppBar'),
            background: Image(
              image: 'bg.png'.toAssetImage(),
              fit: BoxFit.cover,
              height: 250,
            ),
            stretchModes: [
              StretchMode.fadeTitle,
              // StretchMode.blurBackground,
              // StretchMode.zoomBackground
            ],
          ),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: () => debugPrint(e.toString()),
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
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
              'assets/images/flutter-logo-sharing.png',
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
