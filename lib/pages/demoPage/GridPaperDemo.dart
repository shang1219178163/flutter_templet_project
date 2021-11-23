//
//  GridPaperDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/12/21 10:31 PM.
//  Copyright © 10/12/21 shang. All rights reserved.
//



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridPaperDemo extends StatelessWidget {
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
    return Container(
//      height: 400.0,
//      width: 300.0,
      color: Colors.grey,
      child: GridView.count(
        crossAxisCount: 2,
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
            child: Container(),
            footer: Text('footer'),
          ),
          GridPaper(
            interval:1.0,
            divisions: 1,
            subdivisions: 1,
            color: Colors.transparent,
            child: Image.network(
                'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
                scale: 1,
                fit: BoxFit.cover),
          ),
          Image.network(
              'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
              scale: 1,
              fit: BoxFit.cover),
          Image.network(
              'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
              scale: 1,
              fit: BoxFit.cover),
          Image.network(
              'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
              scale: 1,
              fit: BoxFit.cover),
          Image.network(
              'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
              scale: 1,
              fit: BoxFit.cover),
          Image.network(
              'https://flutter.io/assets/homepage/news-2-599aefd56e8aa903ded69500ef4102cdd8f988dab8d9e4d570de18bdb702ffd4.png',
              scale: 1,
              fit: BoxFit.cover),
        ],
      ),
    );
  }
}

