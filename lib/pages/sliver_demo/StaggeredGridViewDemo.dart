//
//  SliverDemo9.dart
//  lib
//
//  Created by shang on 11/29/21 3:00 PM.
//  Copyright © 11/29/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class StaggeredGridViewDemo extends StatefulWidget {
  final String? title;

  StaggeredGridViewDemo({Key? key, this.title}) : super(key: key);

  @override
  _StaggeredGridViewDemoState createState() => _StaggeredGridViewDemoState();
}

class _StaggeredGridViewDemoState extends State<StaggeredGridViewDemo> {

  bool _type = true;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              _type = _type == true ? false : true;
            });
          }, child: Icon(Icons.change_circle_outlined, color: Colors.white,)),
        ],
      ),
      body: _type == true ? _buildBody() : _buildCustomScrollView(),
    );
  }

  _buildBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: StaggeredGridView.countBuilder(
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) => Container(
            color: ColorExt.random,
            child: Container(
              height: randomInt(min: 100, max: 200).toDouble(),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('$index'),
                ),
              ),
            )),
        // staggeredTileBuilder: (int index) =>
        //     StaggeredTile.count(2, index.isEven ? 2 : 1),
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      ),
    );
  }

  Widget _buildCustomScrollView() {
    print('_buildCustomScrollView');
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        // _buildSliverBorderRadius(),
        _buildGrid(),
      ],
    );
  }

  _buildGrid() {
    List<Widget> list = List.generate(9, (index) => Container(
      child: Text('$index'),
      color: Colors.primaries[index],
    ));

    return SliverPadding(
      padding: EdgeInsets.all(20),
      sliver: SliverStaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        staggeredTiles: const <StaggeredTile>[
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
          StaggeredTile.count(2, 2),
          StaggeredTile.count(2, 1),
        ],
        children: list,
      ),
    );
  }

  _buildSliverBorderRadius({bool addToSliverBox = true}) {
    final child = Container(
      color: Color(0xff5c63f1),
      height: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );

    if (addToSliverBox) {
      return SliverToBoxAdapter(
        child: child,
      );
    }
    return child;
  }

}
