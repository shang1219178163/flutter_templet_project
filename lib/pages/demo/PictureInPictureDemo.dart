//
//  PictureInPictureDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/9/10 12:23.
//  Copyright © 2025/9/10 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PictureInPictureDemo extends StatefulWidget {
  const PictureInPictureDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<PictureInPictureDemo> createState() => _PictureInPictureDemoState();
}

class _PictureInPictureDemoState extends State<PictureInPictureDemo> {
  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant PictureInPictureDemo oldWidget) {
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
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Text("$widget"),
          ],
        ),
      ),
    );
  }
}
