//
//  LayoutBuilderDemo.dart
//  fluttertemplet
//
//  Created by shang on 10/14/21 6:47 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class LayoutBuilderDemo extends StatefulWidget {

  final String? title;

  LayoutBuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _LayoutBuilderDemoState createState() => _LayoutBuilderDemoState();
}

class _LayoutBuilderDemoState extends State<LayoutBuilderDemo> {

  final imageUrl = "https://item.jd.com/12673329.html";



  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            buildBody(context),
            buildBody1(context),
          ],
        ),
    );
  }

  Widget buildBody(BuildContext context) {
    return
    Center(
      child: Container(
        child: Column(
          children: <Widget>[
            Image.network(
              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563774129262&di=a62f1daccb204945eafcfd5082b4ce98&imgtype=0&src=http%3A%2F%2Fimages.ali213.net%2Fpicfile%2Fpic%2F2012-11-27%2F927_one_piece18.jpg",
              fit: BoxFit.fill,
              height: 100,
            ),
            Text("图片"),
          ],
        ),
      ),
    );
  }

  Widget buildBody1(BuildContext context) {
    return
      LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Image.network(
                    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563774129262&di=a62f1daccb204945eafcfd5082b4ce98&imgtype=0&src=http%3A%2F%2Fimages.ali213.net%2Fpicfile%2Fpic%2F2012-11-27%2F927_one_piece18.jpg",
                    fit: BoxFit.fill,
                    height: 100,
                    width: constraints.maxWidth,
                  ),
                  Text("图片"),
                ],
              ),
            ),
          );
        },
      );
  }

}