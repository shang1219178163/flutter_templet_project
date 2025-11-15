//
//  AnimatedModalBarrierDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/27 09:02.
//  Copyright © 2025/3/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:get/get.dart';

class AnimatedModalBarrierDemo extends StatefulWidget {
  const AnimatedModalBarrierDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AnimatedModalBarrierDemo> createState() => _AnimatedModalBarrierDemoState();
}

class _AnimatedModalBarrierDemoState extends State<AnimatedModalBarrierDemo> with SingleTickerProviderStateMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  late final items = <ActionRecord>[
    (e: "onTest", action: onTest),
  ];

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  bool _isBlocking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.black38,
    ).animate(_controller);
  }

  void onToggleBarrier() {
    _isBlocking = !_isBlocking;
    if (_isBlocking) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody2(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: buildSectionBox(items: items),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody2() {
    return Stack(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: onToggleBarrier,
            child: Text(_isBlocking ? "隐藏遮罩层" : "显示遮罩层"),
          ),
        ),
        if (_isBlocking)
          AnimatedModalBarrier(
            color: _colorAnimation,
            dismissible: true,
            onDismiss: () {
              // Navigator.of(context).pop();
              DLog.d("AnimatedModalBarrier onDismiss");
              onToggleBarrier();
            },
          ),
      ],
    );
  }

  Widget buildSectionBox({
    required List<ActionRecord> items,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((e) {
        return InkWell(
          onTap: e.action,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: NText(
              e.e,
              color: context.primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  void onTest() {}
}
