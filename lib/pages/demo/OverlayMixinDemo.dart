//
//  OverlayMixinDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/22 09:05.
//  Copyright © 2024/11/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_cancel_and_confirm_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';

import 'package:flutter_templet_project/mixin/overlay_mixin.dart';

class OverlayMixinDemo extends StatefulWidget {
  const OverlayMixinDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayMixinDemo> createState() => _OverlayMixinDemoState();
}

class _OverlayMixinDemoState extends State<OverlayMixinDemo> with OverlayMixin {
  final _scrollController = ScrollController();

  Alignment alignment = Alignment.topCenter;

  @override
  void didUpdateWidget(covariant OverlayMixinDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            NMenuAnchor(
              values: AlignmentExt.allCases,
              initialItem: alignment,
              onChanged: (val) {
                alignment = val;
                // showPop();
              },
              cbName: (e) => "$e",
              equal: (a, b) => a == b,
            ),
          ],
        ),
      ),
    );
  }

  void showPop() {
    presentModalView(
      alignment: alignment,
      barrierDismissible: false,
      builder: (context, onHide) {
        return Container(
          height: 300,
          width: 300,
          color: Colors.yellow,
          child: Column(
            children: [
              FlutterLogo(
                size: 200,
              ),
              NCancelAndConfirmBar(
                onCancel: () {},
                onConfirm: () {
                  onHide();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
