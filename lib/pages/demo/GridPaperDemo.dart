//
//  GridPaperDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/12/21 10:31 PM.
//  Copyright © 10/12/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

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
    final items = AppRes.image.urls.map((e) => NNetworkImage(url: e, fit: BoxFit.cover)).toList();

    final style = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    );
    return Container(
      key: GlobalKey(),
//       color: Colors.grey,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.all(10.0),
        childAspectRatio: 1.3,
        children: <Widget>[
          GridTile(
            header: GridTileBar(
              backgroundColor: Colors.blueGrey,
              title: Text('title'),
              subtitle: Text('subtitle'),
              leading: Icon(Icons.add),
              trailing: Text("trailing"),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.blueGrey,
              leading: IconButton(
                icon: const Icon(Icons.favorite),
                color: Colors.white,
                onPressed: () {},
              ),
              title: const Text(
                "Title",
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {},
                color: Colors.white,
              ),
            ),
            child: NNetworkImage(
              url: AppRes.image.urls[3],
              fit: BoxFit.cover,
            ),
          ),
          GridPaper(
            //绘制一个像素宽度的直线网格
            interval: 3, //参数表示2条线之间的间隔
            divisions: 3, //分割数
            subdivisions: 3, //测网格分割数,包含自身
            // color: Colors.transparent,
            child: NNetworkImage(
              url: AppRes.image.urls[0],
              fit: BoxFit.cover,
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
