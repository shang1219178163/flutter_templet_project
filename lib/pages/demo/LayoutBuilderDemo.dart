//
//  LayoutBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 6:47 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class LayoutBuilderDemo extends StatefulWidget {
  const LayoutBuilderDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LayoutBuilderDemoState createState() => _LayoutBuilderDemoState();
}

class _LayoutBuilderDemoState extends State<LayoutBuilderDemo> {
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
      body: Column(
        children: [
          buildItem(),
          buildItem(hasConstraints: true),
        ],
      ),
    );
  }

  onPressed() {
    setState(() {});
  }

  Widget buildItem({bool hasConstraints = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            child: Column(
              children: <Widget>[
                _buildImage(constraints: hasConstraints ? constraints : null),
                Text("图片"),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildImage({BoxConstraints? constraints}) {
    // return FadeInImage(
    //   // placeholder: "img_placeholder.png"),
    //   placeholder: R.image.placeholder(),
    //   image: NetworkImage(R.image.imgUrls[0]),
    //   fit: BoxFit.fill,
    //   width: constraints?.maxWidth,
    //   height: 100,
    // );
    final index = Random().nextInt(AppRes.image.urls.length);
    return Image(
      image: NetworkImage(AppRes.image.urls[index]),
      fit: BoxFit.fill,
      width: constraints?.maxWidth,
      height: 100,
      loadingBuilder: _buildLoadingBuilder,
    );
  }

  /// 占位
  Widget _buildLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) {
      return child;
    }
    final text = loadingProgress.current?.toStringAsPercent(2) ?? '';
    return Container(
        // color: Colors.green,
        width: 100,
        height: 100,
        child: Center(child: Text(text)));
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.current,
      ),
    );
  }
}
