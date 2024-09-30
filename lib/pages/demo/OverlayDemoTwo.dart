//
//  OverlayDemoTwo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/9/29 21:25.
//  Copyright © 2024/9/29 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverlayDemoTwo extends StatefulWidget {
  const OverlayDemoTwo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<OverlayDemoTwo> createState() => _OverlayDemoTwoState();
}

class _OverlayDemoTwoState extends State<OverlayDemoTwo> {
  bool get hideApp =>
      "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant OverlayDemoTwo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                'done',
              ]
                  .map((e) => TextButton(
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => debugPrint(e),
                      ))
                  .toList(),
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
          ],
        ),
      ),
    );
  }

  static final List<OverlayEntry> _entriesList = [];

  late final overlayEntry = OverlayEntry(
    maintainState: true,
    builder: (_) => Container(
      child: Container(
        width: 300,
        height: 200,
        color: Colors.black12,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              hideOverlay();
            },
            child: Text("overlayEntry remove"),
          ),
        ),
      ),
    ),
  );

  void showOverlay() {
    Overlay.of(context).insert(overlayEntry);
    _entriesList.add(overlayEntry);
  }

  void hideOverlay() {
    if (_entriesList.isNotEmpty) {
      for (final e in _entriesList) {
        e.remove();
      }
      _entriesList.clear();
    }
  }
}
