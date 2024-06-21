//
//  FilePreviewPage.dart
//  yl_health_app
//
//  Created by shang on 2023/9/19 16:24.
//  Copyright © 2023/9/19 shang. All rights reserved.
//

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_preview/file_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_webview_page.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// 网页加载
class FilePreviewPage extends StatefulWidget {
  FilePreviewPage({
    super.key,
    required this.path,
    this.title,
  });

  final String path;

  final String? title;

  @override
  _FilePreviewPageState createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
  final controller = FilePreviewController();

  final _progressVN = ValueNotifier(0.0);
  // 加载
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '详情'),
        actions: [
          IconButton(
            onPressed: onShare,
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black87,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: ValueListenableBuilder<double>(
              valueListenable: _progressVN,
              builder: (context, value, child) {
                final indicatorColor =
                    value >= 1.0 ? Colors.transparent : primaryColor;

                return LinearProgressIndicator(
                  value: value,
                  color: indicatorColor,
                  backgroundColor: Colors.transparent,
                );
              }),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: FilePreviewWidget(
        controller: controller,
        width: double.maxFinite,
        height: double.maxFinite,
        path: widget.path,
        callBack: FilePreviewCallBack(
          onShow: () {
            _isLoading = true;
            setState(() {});
          },
          onFail: (code, msg) {
            ToastUtil.show('文件加载失败');
          },
        ),
      ),
    );
  }

  onShare() async {
    Share.shareXFiles([XFile(widget.path)]);
  }
}
