//
//  AlignmentDrawDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/8/21 1:31 PM.
//  Copyright © 12/8/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_alignment_drawer.dart';
import 'package:flutter_templet_project/basicWidget/n_pair.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/extension/alignment_ext.dart';
import 'package:flutter_templet_project/extension/button_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/navigator_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

/// 九个方向的 drawer
class AlignmentDrawDemo extends StatefulWidget {
  AlignmentDrawDemo({
    super.key,
  });

  @override
  State<AlignmentDrawDemo> createState() => _AlignmentDrawDemoState();
}

class _AlignmentDrawDemoState extends State<AlignmentDrawDemo> {
  final _scrollController = ScrollController();

  Alignment topAlignment = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    presentDrawer(alignment: topAlignment);
                  },
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(height: 10,),
              NMenuAnchor(
                values: AlignmentExt.allCases,
                initialItem: topAlignment,
                onChanged: (val) {
                  DLog.d(val);
                  topAlignment = val;
                  presentDrawer(alignment: topAlignment);
                },
                cbName: (e) => "$e",
                equal: (a, b) => a == b,
              ),
            ],
          ),
        ),
      ),
    );
  }

  presentDrawer({
    Alignment alignment = Alignment.topCenter,
  }) {
    NAlignmentDrawer(
      alignment: alignment,
      builder: (onHide) {
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            width: 300,
            height: 400,
            child: Scaffold(
              appBar: AppBar(title: Text("NAlignmentDrawer"), automaticallyImplyLeading: false, actions: [
                TextButton(
                  onPressed: onHide,
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
              body: buildBody(),
            ),
          ),
        );
      },
    ).toShowDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
    );
  }
}
