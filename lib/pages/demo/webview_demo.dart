//
//  WebviewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/13 13:20.
//  Copyright © 2024/10/13 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/app_webView_page.dart';

class WebviewDemo extends StatefulWidget {
  const WebviewDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<WebviewDemo> createState() => _WebviewDemoState();
}

class _WebviewDemoState extends State<WebviewDemo> {
  final _scrollController = ScrollController();

  final fullUrl =
      "https://kp-test.yljk.cn/?articleId=608705053087371264&sourceType=APP_PATIENT";

  @override
  void didUpdateWidget(covariant WebviewDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
    return buildWevView();

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

  Widget buildWevView() {
    return AppWebViewPage(
      hideAppBar: true,
      url: fullUrl,
      onWebViewCreated: (controller) {
        controller.addJavaScriptHandler(
          handlerName: "handleScrollBottom",
          callback: (arguments) {
            debugPrint("handleScrollBottom: $arguments");
          },
        );
        controller.addJavaScriptHandler(
          handlerName: "handleScrollTop",
          callback: (arguments) {
            debugPrint("handleScrollTop: $arguments");
          },
        );
      },
    );
  }
}
