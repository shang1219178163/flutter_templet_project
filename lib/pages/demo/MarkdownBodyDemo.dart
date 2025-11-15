//
//  MarkdownBodyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/17 09:44.
//  Copyright © 2025/1/17 shang. All rights reserved.
//

//
//  MarkdownBodyDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/17 09:50.
//  Copyright © 2025/1/17 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

import 'package:flutter_templet_project/mixin/asset_resource_mixin.dart';

/// 第三方库 flutter_markdown
class MarkdownBodyDemo extends StatefulWidget {
  const MarkdownBodyDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<MarkdownBodyDemo> createState() => _MarkdownBodyDemoState();
}

class _MarkdownBodyDemoState extends State<MarkdownBodyDemo> with AssetResourceMixin {
  final _scrollController = ScrollController();

  var streamController = StreamController<String>.broadcast();

  /// 打印中
  bool isPrinting = false;

  var fullText = "";
  int charIndex = 0;

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    onAssetResourceFinished = () {
      fullText = assetFileModels.firstOrNull?.content ?? "";
      onStart();
    };
  }

  @override
  void didUpdateWidget(covariant MarkdownBodyDemo oldWidget) {
    super.didUpdateWidget(oldWidget);

    streamController = StreamController<String>.broadcast();
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
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NButton(
              title: "开始",
              onPressed: onStart,
            ),
            StreamBuilder<String>(
              stream: streamController.stream,
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return failedWidget();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CupertinoActivityIndicator();
                }
                return _markdownWidget(snapshot.data ?? '');
              }),
            )
          ],
        ),
      ),
    );
  }

  void onStart() {
    if (isPrinting) {
      DLog.d("isPrinting: $isPrinting");
      return;
    }

    final fullText = assetFileModels.firstOrNull?.content ?? "";
    var current = '';

    isPrinting = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (charIndex < fullText.length) {
        final tmp = fullText[charIndex];
        charIndex++;
        current = '$current$tmp';
        streamController.add(current);
      } else {
        timer.cancel(); // 停止计时器
        isPrinting = false;
      }
    });
  }

  Widget failedWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8).copyWith(topLeft: Radius.zero),
        color: Colors.white,
      ),
      child: NText('识别失败', fontSize: 16),
    );
  }

  Widget _markdownWidget(String data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8).copyWith(topLeft: Radius.zero),
      ),
      child: SelectionArea(
        child: MarkdownBody(selectable: true, data: data),
      ),
    );
  }
}
