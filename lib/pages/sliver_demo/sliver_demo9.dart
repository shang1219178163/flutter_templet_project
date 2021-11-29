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
import 'package:fluttertemplet/dartExpand/color_extension.dart';
import 'package:fluttertemplet/dartExpand/num_extension.dart';

class SliverDemo9 extends StatefulWidget {
  final String? title;

  SliverDemo9({Key? key, this.title}) : super(key: key);

  @override
  _SliverDemo9State createState() => _SliverDemo9State();
}

class _SliverDemo9State extends State<SliverDemo9> {

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
    return StaggeredGridView.countBuilder(
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) => Container(
          color: ColorExt.random(),
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
    );
  }

  Widget _buildCustomScrollView() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverStaggeredGrid.count(
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
          children: const <Widget>[
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5'),
            Text('6'),
            Text('7'),
            Text('8'),
          ],
        )
      ],
    );
  }
}
//

