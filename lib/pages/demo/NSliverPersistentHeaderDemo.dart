//
//  NnSliverPersistentHeaderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 10:30.
//  Copyright © 2023/3/25 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NSliverPersistentHeaderDemo extends StatefulWidget {
  const NSliverPersistentHeaderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NSliverPersistentHeaderDemoState createState() =>
      _NSliverPersistentHeaderDemoState();
}

class _NSliverPersistentHeaderDemoState
    extends State<NSliverPersistentHeaderDemo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return CustomScrollView(
      slivers: [
        Container(
                height: 200,
                alignment: Alignment.center,
                color: Colors.green,
                child: Text("${widget}"))
            .toSliverToBoxAdapter(),
        NSliverPersistentHeaderBuilder(
          // pinned: true,
          // floating: true,
          builder: (context, offset, overlapsContent) {
            return Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(116)),
              ),
              child: Center(
                child: Text("NSliverPersistentHeader"),
              ),
            );
          },
        ),
        Container(
          height: 1000,
          color: ColorExt.random,
        ).toSliverToBoxAdapter(),
      ],
    );
  }

  onPressed() {}

  SliverPersistentHeader buildSliverHeader(
      {required Text text, bool pinned = true}) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: NSliverPersistentHeaderDelegate(
        min: 60.0,
        max: 80.0,
        builder: (ctx, offset, overlapsContent) => SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(116)),
            ),
            child: Center(
              child: text,
            ),
          ),
        ),
      ),
    );
  }
}
