import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/mixin/photo_picker_mixin.dart';
import 'package:flutter_templet_project/pages/demo/NScanPhotoDemo.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';

/// 图片扫描demo
class ScanAnimationDemo extends StatefulWidget {
  ScanAnimationDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ScanAnimationDemo> createState() => _ScanAnimationDemoState();
}

class _ScanAnimationDemoState extends State<ScanAnimationDemo> with SingleTickerProviderStateMixin, PhotoPickerMixin {
  final _scrollController = ScrollController();

  File? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    Widget imgWidget = Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Image(
        image: AssetImage("assets/images/icon_camera.png"),
        width: 24,
        height: 24,
      ),
    );
    if (image != null) {
      imgWidget = Image.file(image!);
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: imgWidget,
      ),
    );
  }

  Future<void> onTap() async {
    final asset = await onPicker(maxCount: 1);
    if (asset == null) {
      ToastUtil.show("取消选择");
      return;
    }
    final file = await asset.firstOrNull?.file;
    if (file == null) {
      ToastUtil.show("获取文件路径失败");
      return;
    }
    image = file;
    setState(() {});
    Get.to(
      () => NScanPhotoDemo(arguments: {
        "image": file,
        "onScanStop": () {
          DLog.d(file.path);
          Get.back();
        }
      }),
    );
  }
}
