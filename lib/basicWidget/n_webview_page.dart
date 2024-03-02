//
//  AppWebViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/8/21 8:54 AM.
//  Copyright © 6/8/21 shang. All rights reserved.
//

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// webview_flutter 简易封装
class NWebViewPage extends StatefulWidget {

  NWebViewPage({
    super.key,
    required this.title,
    required this.initialUrl,
    this.onProgress,
    this.hideAppBar = true,
  });


  final String title;

  final String initialUrl;

  final ValueChanged<double>? onProgress;

  final bool hideAppBar;

  @override
  _NWebViewPageState createState() => _NWebViewPageState();
}

class _NWebViewPageState extends State<NWebViewPage> {
  late final WebViewController _controller;

  String? currentTitle;

  final progressVN = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();

    configWebview();
  }

  configWebview() {
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            progressVN.value = progress/100.0;
            widget.onProgress?.call(progressVN.value);
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');

            if (progressVN.value < 1) {
              progressVN.value = 1;
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar? null : AppBar(
        title: Text(currentTitle ?? widget.title,),
        actions: [
          WebViewNavigationControls(controller: _controller),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          ValueListenableBuilder(
              valueListenable: progressVN,
              builder: (context, progress, child){

                return LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.transparent,
                  color: progress >= 1 ? Colors.transparent : Colors.blue,
                );
              },
          ),
        ],
      ),
    );
  }
}

class WebViewNavigationControls extends StatelessWidget {
  const WebViewNavigationControls({
    super.key,
    required this.controller,
  });

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              presentMessage(
                context: context,
                message: 'No back history item',
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              presentMessage(
                context: context,
                message: 'No forward history item',
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => controller.reload(),
        ),
      ],
    );
  }

  presentMessage({required BuildContext context, required String message}) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}