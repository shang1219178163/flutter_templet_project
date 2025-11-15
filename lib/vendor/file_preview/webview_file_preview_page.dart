//
//  WebviewFilePreviewPage.dart
//  yl_health_app
//
//  Created by shang on 2023/9/19 16:24.
//  Copyright © 2023/9/19 shang. All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_webview_page.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';

import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:share_plus/share_plus.dart';

/// 网页加载
class WebviewFilePreviewPage extends StatefulWidget {
  WebviewFilePreviewPage({
    super.key,
    required this.url,
    this.title,
  }) : assert(url.startsWith("http"));

  final String url;

  final String? title;

  @override
  _WebviewFilePreviewPageState createState() => _WebviewFilePreviewPageState();
}

class _WebviewFilePreviewPageState extends State<WebviewFilePreviewPage> {
  final _progressVN = ValueNotifier(0.0);

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
                final indicatorColor = value >= 1.0 ? Colors.transparent : primaryColor;

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
      child: NWebViewPage(
        url: widget.url,
        title: '',
        hideAppBar: true,
      ),
    );
  }

  onShare() async {
    var tempDir = await AssetCacheService().getDir();
    var tmpPath = '${tempDir.path}/${widget.title}';

    final percentVN = ValueNotifier(0.0);

    ToastUtil.loading("文件下载中",
        indicator: ValueListenableBuilder<double>(
            valueListenable: percentVN,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
              );
            }));

    final response = await Dio().download(widget.url, tmpPath, onReceiveProgress: (received, total) {
      if (total != -1) {
        final percent = (received / total);
        final percentStr = "${(percent * 100).toStringAsFixed(0)}%";
        percentVN.value = percent;
        debugPrint("percentStr: $percentStr");
      }
    });
    // debugPrint("response: ${response.data}");
    debugPrint("tmpPath: $tmpPath");
    ToastUtil.hideLoading();

    Share.shareXFiles([XFile(tmpPath)]);
  }
}
