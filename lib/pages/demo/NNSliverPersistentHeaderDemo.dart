//
//  NnSliverPersistentHeaderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2023/3/25 10:30.
//  Copyright © 2023/3/25 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/nn_sliver_persistent_header_delegate.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NNSliverPersistentHeaderDemo extends StatefulWidget {

  NNSliverPersistentHeaderDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _NNSliverPersistentHeaderDemoState createState() => _NNSliverPersistentHeaderDemoState();
}

class _NNSliverPersistentHeaderDemoState extends State<NNSliverPersistentHeaderDemo> {


  @override
  void initState() {
    super.initState();
  }

   @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressed,)
        ).toList(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return CustomScrollView(
      slivers: [
        Container(
          child: Text("arguments.toString()")
        ).toSliverToBoxAdapter(),
        NNSliverPersistentHeader(
          builder: (context, offset, overlapsContent){
            return Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(116)),
              ),
              child: Center(
                child: Text("NNSliverPersistentHeader"),
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

  onPressed(){

  }

  SliverPersistentHeader buildSliverHeader({required Text text, bool pinned = true}) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: NNSliverPersistentHeaderDelegate(
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