//
//  ScanBarcodeDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/21 09:59.
//  Copyright © 2025/3/21 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/photo_picker_mixin.dart';
import 'package:get/get.dart';

class ScanBarcodeDemo extends StatefulWidget {
  const ScanBarcodeDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ScanBarcodeDemo> createState() => _ScanBarcodeDemoState();
}

class _ScanBarcodeDemoState extends State<ScanBarcodeDemo> with PhotoPickerMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  /// 图片文件
  File? file;

  /// 码识别结果
  var recognizedCodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await recognizedBarcode();
          setState(() {});
        },
        child: Icon(Icons.ac_unit),
      ),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recognizedCodes.isNotEmpty) Text(recognizedCodes.formatedString()),
            buildImage(),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    Widget content = file == null
        ? Image(
            image: "assets/images/img_placeholder.png".toAssetImage(),
          )
        : Image.file(file!);
    return GestureDetector(
      onTap: () async {
        final list = await onPicker();
        file = await list?.firstOrNull?.file;
        setState(() {});

        await recognizedBarcode();
        setState(() {});
      },
      child: content,
    );
  }

  /// 识别二维码
  Future<void> recognizedBarcode() async {
    try {
      final items = await BarcodeExt.barcodeFromFilePath(path: file!.path);
      DLog.d(items);
      recognizedCodes = items;
    } catch (e) {
      debugPrint("$this $e");
      recognizedCodes = [e.toString()];
    }
  }
}
