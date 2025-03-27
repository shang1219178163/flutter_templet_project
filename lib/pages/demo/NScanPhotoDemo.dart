//
//  NScanImageDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/31 12:09.
//  Copyright © 2024/7/31 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_scan_photo.dart';
import 'package:flutter_templet_project/mixin/photo_picker_mixin.dart';
import 'package:get/get.dart';

class NScanPhotoDemo extends StatefulWidget {
  const NScanPhotoDemo({
    super.key,
    required this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<NScanPhotoDemo> createState() => _NScanPhotoDemoState();
}

class _NScanPhotoDemoState extends State<NScanPhotoDemo> with PhotoPickerMixin {
  late final arguments =
      widget.arguments ?? Get.arguments ?? <String, dynamic>{};
  late File? file = arguments["image"] as File?;
  late VoidCallback? onScanStop = arguments["onScanStop"] as VoidCallback?;

  @override
  void initState() {
    super.initState();
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

  buildBody() {
    return NScanPhoto(
      image: file,
      onScanning: onAction,
      onStop: () {
        if (onScanStop != null) {
          onScanStop!();
        } else {
          Get.back();
        }
      },
    );
  }

  Future<void> onAction() async {
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
