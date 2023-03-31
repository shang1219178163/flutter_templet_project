//
//  ResponsiveColumn.dart
//  flutter_templet_project
//
//  Created by shang on 12/2/21 9:41 AM.
//  Copyright © 12/2/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_templet_project/basicWidget/layout_log_print.dart';

class ResponsiveColumn extends StatelessWidget {

  const ResponsiveColumn({
  	Key? key,
  	required this.children,
  }) : super(key: key);

  final List<Widget> children;


  @override
  Widget build(BuildContext context) {
    final scrennize = MediaQuery.of(context).size;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < scrennize.width*0.5) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      }

      var list = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        if (i + 1 < children.length) {
          list.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: [children[i], children[i+1]],)
          );
        } else {
          list.add(children[i]);
        }
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    });
  }
}


class ResponsiveColumnDemo extends StatelessWidget {
  const ResponsiveColumnDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _children = List.filled(6, Text("A"));
    // Column在本示例中在水平方向的最大宽度为屏幕的宽度
    return Scaffold(
        appBar: AppBar(
          title: Text(toString()),
        ),
        body: Column(
          children: [
            // 限制宽度为190，小于 200
            SizedBox(width: 190, child: ResponsiveColumn(children: _children)),
            Divider(color: Colors.red),
            Container(
              width: 190,
              color: Colors.green,
              child: ResponsiveColumn(children: _children)),
            Divider(color: Colors.red),
            ResponsiveColumn(children: _children),
            Divider(color: Colors.red),
            LayoutLogPrint(child:Text("xx")) // 下面介绍
          ],
        )
    );
  }
}

