//
//  W3ThemeColorPage.dart
//  flutter_templet_project
//
//  Created by shang on 2026/7/23.
//  Copyright © 2026/7/23 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/enum/w3_theme_color.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

/// W3 Schools 主题色列表
class W3ThemeColorPage extends StatefulWidget {
  const W3ThemeColorPage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<W3ThemeColorPage> createState() => _W3ThemeColorPageState();
}

class _W3ThemeColorPageState extends State<W3ThemeColorPage> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();
  final boundaryKey = GlobalKey();

  final items = W3ThemeColor.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
              actions: [
                IconButton(
                  tooltip: "截屏",
                  onPressed: captureScreenshot,
                  icon: const Icon(Icons.crop),
                ),
              ],
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: RepaintBoundary(
          key: boundaryKey,
          child: Column(
            children: [
              ...items.map(buildColorItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorItem(W3ThemeColor item) {
    final color = item.color;
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      child: ListTile(
        onTap: () => copy(item.desc),
        onLongPress: () => copy(item.name),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          item.desc,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: Icon(Icons.copy, size: 18),
      ),
    );
  }

  Future<void> copy(String val) async {
    await Clipboard.setData(ClipboardData(text: val));
    DLog.d("已复制名称 $val");
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("已复制 $val"), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> captureScreenshot() async {
    final bytes = await boundaryKey.currentContext?.toImageUint8List(pixelRatio: 3);
    if (bytes == null) {
      ToastUtil.show("截屏失败，请稍后重试");
      return;
    }
    final result = await ImageGallerySaverPlus.saveImage(
      bytes,
      quality: 100,
      name: "w3_theme_color_${DateTime.now().millisecondsSinceEpoch}",
    );
    DLog.d("截屏结果: $result");
    final isSuccess = result is Map && (result['isSuccess'] as bool? ?? false);
    ToastUtil.show(isSuccess ? "已保存到相册" : "保存失败");
  }
}
