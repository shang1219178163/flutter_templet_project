//
//  GridPaperDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/12/21 10:31 PM.
//  Copyright © 10/12/21 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/util/R.dart';


class GridPaperDemo extends StatelessWidget {
  const GridPaperDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Girdpaper'),
          centerTitle: true,
        ),
        body: _contentWidget());
  }

  Widget _contentWidget() {
    final items = R.image.urls.map((e) => Image.network(
        e,
        scale: 1,
        fit: BoxFit.cover)).toList();

    return Container(
      key: GlobalKey(),
//       color: Colors.grey,
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(10.0),
        childAspectRatio: 1.3,
        children: <Widget>[
          GridTile(
            header: GridTileBar(
              title: Text('title'),
              subtitle: Text('subtitle'),
              leading: Icon(Icons.add),
              trailing: Text("trailing"),
            ),
            footer: Center(child: Text('footer')),
            child: Image.network(
              R.image.urls[6],
              scale: 1,
              fit: BoxFit.cover
            ),
          ),
          GridPaper(//绘制一个像素宽度的直线网格
            interval: 3,//参数表示2条线之间的间隔
            divisions: 3,//分割数
            subdivisions: 3,//测网格分割数,包含自身
            // color: Colors.transparent,
            child: Image.network(
              R.image.urls[0],
              scale: 1,
              fit: BoxFit.cover
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

