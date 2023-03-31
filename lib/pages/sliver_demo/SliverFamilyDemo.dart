//
//  SliverFamilyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/15/21 1:57 PM.
//  Copyright © 10/15/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverAppBarDemoOne.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverGridDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverListDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverListPopverDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverPersistentHeaderDemoOne.dart';
import 'package:flutter_templet_project/pages/sliver_demo/StaggeredGridViewDemo.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/pages/sliver_demo/SliverPersistentHeaderDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverAnimatedListDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverAppBarDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverFillRemainingDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverFillViewportDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverBaseDemo.dart';
import 'package:flutter_templet_project/pages/sliver_demo/SliverPrototypeExtentListDemo.dart';

class SliverFamilyDemo extends StatefulWidget {

  final String? title;

  const SliverFamilyDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _SliverFamilyDemoState createState() => _SliverFamilyDemoState();
}

class _SliverFamilyDemoState extends State<SliverFamilyDemo> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      itemCount: _list.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.green,
        );
      },
      itemBuilder: (context, index) {
        final e = _list[index];
        return Container(
          height: 45,
          child: ListTile(
            dense: true,
            title: Text(e.item1),
            subtitle: Text(e.item2),
            trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.withOpacity(0.5)),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return e.item3;
                  }
              ));
            },
          ),
        );
      });
  }


}


class SliverFamilyPageViewDemo extends StatefulWidget {

  final String? title;

  const SliverFamilyPageViewDemo({ Key? key, this.title}) : super(key: key);


  @override
  _SliverFamilyPageViewDemoState createState() => _SliverFamilyPageViewDemoState();
}

class _SliverFamilyPageViewDemoState extends State<SliverFamilyPageViewDemo> {

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      onPageChanged: (index){
        debugPrint('当前为第$index页');
      },
      children: _list.map((e) => Container(
        child: e.item3,
      )).toList(),
    );
  }
}


List<Tuple3<String, String, Widget>> _list = [
  Tuple3(
    'SliverBaseDemo',
    '设置子控件透明度 SliverOpacity、SliverPadding',
    SliverBaseDemo(),
  ),
  Tuple3(
    'SliverAppBar',
    '可变的导航栏',
    SliverAppBarDemo(),
  ),
  Tuple3(
    'SliverAppBarDemoOne',
    '可变的导航栏',
    SliverAppBarDemoOne(),
  ),

  Tuple3(
    'SliverList、SliverFixedExtentList',
    '常用的组合方式',
    SliverListDemo(title:
    'SliverList、SliverFixedExtentList',
    ),
  ),
  Tuple3(
    'SliverGrid',
    '常用的组合方式',
    SliverGridDemo(title:
    'SliverGrid',
    ),
  ),
  Tuple3(
    'SliverPersistentHeader',
    '吸顶效果',
    SliverPersistentHeaderDemo(),
  ),
  Tuple3(
    'SliverPersistentHeaderDemoOne',
    '吸顶效果',
    SliverPersistentHeaderDemoOne(),
  ),

  Tuple3(
    'SliverAnimatedList',
    '带动画的SliverList组件',
    SliverAnimatedListDemo(),
  ),
  Tuple3(
    'SliverFillRemaining',
    '充满视图的剩余空间，通常用于最后一个sliver组件',
    SliverFillRemainingDemo(),
  ),
  Tuple3(
    'SliverFillViewport',
    '每个子元素都填充满整个视图',
    SliverFillViewportDemo(),
  ),
  Tuple3(
    'SliverPrototypeExtentList',
    '由prototypeItem属性来控制所有子控件的高度',
    SliverPrototypeExtentListDemo(),
  ),
  Tuple3(
    'StaggeredGridView',
    '瀑布流',
    StaggeredGridViewDemo(),
  ),
  Tuple3(
    'SliverListPopverDemo',
    'Popver弹窗',
    SliverListPopverDemo(),
  ),


];