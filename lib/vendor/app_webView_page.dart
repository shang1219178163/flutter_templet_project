//
//  InAppWebViewPage.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/10 16:33.
//  Copyright © 2024/4/10 shang. All rights reserved.
//

import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_templet_project/basicWidget/n_app_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_skeleton_screen.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/app_color.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:share_plus/share_plus.dart';

/// 基于 flutter_inappwebview 的 全局 webview 页面封装
class AppWebViewPage extends StatefulWidget {
  const AppWebViewPage({
    super.key,
    this.controller,
    required this.url,
    this.htmlContent,
    this.title,
    this.actions,
    this.canShare = false,
    this.hideAppBar = false,
    this.hideSkeletonScreen = false,
    this.bottomNavigationBar,
    this.onBack,
    this.javaScriptEnabled = true,
    this.mediaPlaybackRequiresUserGesture = true,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.shouldOverrideUrlLoading,
  });

  final AppWebViewPageController? controller;

  // 链接必传
  final String url;

  /// 标题
  final String? title;

  /// html 内容
  final String? htmlContent;

  final VoidCallback? onBack;
  final List<Widget>? actions;

  /// 是否可以分享
  final bool canShare;
  final bool hideAppBar;
  final bool hideSkeletonScreen;
  final bool? javaScriptEnabled;
  final bool? mediaPlaybackRequiresUserGesture;

  /// Scaffold 的 bottomNavigationBar
  final Widget? bottomNavigationBar;

  final void Function(InAppWebViewController controller)? onWebViewCreated;

  final void Function(InAppWebViewController controller, WebUri? url)? onLoadStart;

  final void Function(InAppWebViewController controller, WebUri? url)? onLoadStop;

  final Future<NavigationActionPolicy?> Function(InAppWebViewController controller, NavigationAction navigationAction)?
      shouldOverrideUrlLoading;

  @override
  State<AppWebViewPage> createState() => _AppWebViewPageState();
}

class _AppWebViewPageState extends State<AppWebViewPage> {
  final progressVN = ValueNotifier(0.0);

  final titleVN = ValueNotifier("");

  bool isFirst = true;

  InAppWebViewController? _controller;

  // late InAppWebViewSettings settings = InAppWebViewSettings(
  //   userAgent: "APP_YLHEALTH",
  //   javaScriptEnabled: true,
  //   // useShouldOverrideUrlLoading: true,
  //   // mediaPlaybackRequiresUserGesture:
  //   //     widget.mediaPlaybackRequiresUserGesture ?? true,
  //   // allowsInlineMediaPlayback: true,
  //   // iframeAllow: "camera; microphone",
  //   // iframeAllowFullscreen: true,
  // );

  InAppWebViewSettings settings = InAppWebViewSettings(
    userAgent: "APP_YLHEALTH",
    javaScriptEnabled: true,
    mediaPlaybackRequiresUserGesture: true,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  /// 是否本地文件路径
  bool get isAssetPath => widget.url.startsWith("assets/");

  bool isInFullScreenMode = false;

  bool? fullScreenLandscape;

  List<VideoElementDetailModel> videoModels = [];

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    videoModels = parserVideoTags(widget.htmlContent ?? "");
  }

  @override
  void didUpdateWidget(covariant AppWebViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {});
    }
    if (oldWidget.htmlContent != widget.htmlContent) {
      videoModels = parserVideoTags(widget.htmlContent ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideAppBar) {
      return buildBody();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NAppBar(
        onBack: widget.onBack,
        // title: widget.title ?? '详情',
        title: buildTitle(),
        actions: widget.actions ??
            [
              if (widget.canShare)
                IconButton(
                  onPressed: onShare,
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.black87,
                  ),
                ),
            ],
        // bottom: buildBottomProgress(),
      ),
      body: buildBody(),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  Widget buildTitle() {
    return ValueListenableBuilder(
      valueListenable: titleVN,
      builder: (context, value, child) {
        return Text(
          widget.title ?? value,
          style: TextStyle(
            fontSize: 18,
            color: AppColor.fontColor,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  /// 进度指示条
  Widget buildBottomProgress() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(2),
      child: ValueListenableBuilder<double>(
        valueListenable: progressVN,
        builder: (context, value, child) {
          final indicatorColor = value >= 1.0 ? Colors.transparent : AppColor.primary;

          return LinearProgressIndicator(
            value: value,
            color: indicatorColor,
            backgroundColor: Colors.transparent,
            minHeight: 2,
          );
        },
      ),
    );
  }

  Widget buildBody() {
    if (widget.url.startsWith("http") != true && !isAssetPath) {
      return NPlaceholder(
        message: "链接失效\n${widget.url}",
      );
    }

    if (widget.hideSkeletonScreen) {
      return buildWebView();
    }

    return Stack(
      children: [
        buildWebView(),
        Positioned(
          child: ValueListenableBuilder(
            valueListenable: progressVN,
            builder: (context, value, child) {
              return Offstage(
                offstage: value >= 1.0,
                child: const NSkeletonScreen(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildWebView() {
    final urlRequest = widget.url.startsWith("http") ? URLRequest(url: WebUri(widget.url)) : null;

    return InAppWebView(
      initialUrlRequest: urlRequest,
      initialUserScripts: UnmodifiableListView<UserScript>([]),
      initialSettings: settings,
      onWebViewCreated: (controller) async {
        _controller = controller;
        controller.addJavaScriptHandler(
          handlerName: "messageHandler",
          callback: ((arguments) {
            debugPrint("message.message = $arguments");
            if (arguments.isNotEmpty) {}
          }),
        );
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        //解决 handshake failed问题 修复白屏问题
        return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
      },
      onLoadStart: (controller, url) async {},
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        // var uri = navigationAction.request.url!;
        return NavigationActionPolicy.ALLOW;
      },
      onLoadStop: (controller, url) async {
        isFirst = false;
        widget.onLoadStop?.call(controller, url);
      },
      onReceivedError: (controller, request, error) {
        debugPrint("❌webPage--onReceivedError: $error");
        //首次加载如果没有加载成功展示原生导航
        if (isFirst) {
          InAppWebViewController.clearAllCache();
          controller.reload();
        }
      },
      onProgressChanged: (controller, progress) {
        progressVN.value = progress / 100;
        // YLog.d("progress: $progress");
      },
      onUpdateVisitedHistory: (controller, url, isReload) async {
        // fullScreenLandscape = null;
        debugPrint("webPage--onUpdateVisitedHistory = $url");
      },
      onConsoleMessage: (controller, consoleMessage) {
        debugPrint("webPage--onConsoleMessage = $consoleMessage");
      },
      onEnterFullscreen: (controller) async {
        isInFullScreenMode = true;
        // if (Platform.isAndroid) {
        final currentUrl = await getCurrentVideoUrl();
        final model = videoModels.firstWhereOrNull((e) => e.src == currentUrl);
        if (model == null || model.isHorizontal == true) {
          // 全屏进入横屏模式
          tunLandscape();
        }
        // }
      },
      onExitFullscreen: (controller) async {
        isInFullScreenMode = false;
        // if (Platform.isAndroid) {
        // 退出全屏恢复竖屏
        tunPortrait(milliseconds: 0);
        // }
      },
    );
  }

  // void _messageHandler(Map params) async {
  //   if (params.isEmpty || params["messageType"] == null) {
  //     return;
  //   }
  // }

  /// 全屏进入横屏模式
  void tunLandscape({int milliseconds = 300}) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      return;
    }

    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    });
  }

  /// 全屏进入竖屏模式
  void tunPortrait({int milliseconds = 0}) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return;
    }

    Future.delayed(Duration(milliseconds: milliseconds), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });
  }

  onShare() async {
    var tempDir = await AssetCacheService().getDir();
    var tmpPath = '${tempDir.path}/${widget.title}';

    final percentVN = ValueNotifier(0.0);

    ToastUtil.loading(
      "文件下载中",
      indicator: ValueListenableBuilder<double>(
        valueListenable: percentVN,
        builder: (context, value, child) {
          return CircularProgressIndicator(
            value: value,
          );
        },
      ),
    );

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

  List<VideoElementDetailModel> parserVideoTags(String htmlContent) {
    if (htmlContent.isEmpty) {
      return [];
    }
    // 正则表达式匹配 <video> 标签及其内容
    // RegExp videoTagExp =
    //     RegExp(r'<video[^>]*>.*?</video>', caseSensitive: false, dotAll: true);
    //
    // // 使用 allMatches 方法提取所有匹配的 <video> 标签及内容
    // Iterable<RegExpMatch> matches = videoTagExp.allMatches(htmlContent);
    // // 将匹配到的内容存入数组
    // List<String> videoTags = matches.map((match) => match.group(0)!).toList();
    // YLog.d({"videoTags": videoTags});

    // 解析 HTML 字符串
    final document = html_parser.parse(htmlContent);
    final elements = document.querySelectorAll('video');
    final videoModels = elements.map((el) {
      var sourceAttributes = el.nodes.firstOrNull?.attributes ?? {};
      var attributes = el.attributes ?? {};

      // 创建字典并将 <video> 标签的属性添加进去
      var videoAttributes = <String, dynamic>{
        ...sourceAttributes,
        ...attributes,
      };
      return VideoElementDetailModel.fromJson(videoAttributes);
    }).toList();

    return videoModels;
  }

  Future<String?> getCurrentVideoUrl() async {
    // 使用 JavaScript 获取页面上视频元素的 src 属性
    String? videoUrl = await _controller?.evaluateJavascript(source: '''
      (function() {
        var video = document.querySelector('video');
        return video ? video.currentSrc || video.src : null;
      })();
    ''');
    DLog.d("当前播放视频的链接: $videoUrl");
    return videoUrl;
  }
}

class AppWebViewPageController {
  _AppWebViewPageState? _anchor;

  void _attach(_AppWebViewPageState anchor) {
    _anchor = anchor;
  }

  void _detach(_AppWebViewPageState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  /// InAppWebViewController
  InAppWebViewController? get controller => _anchor?._controller;
}

/// 视频标签<Video>模型
class VideoElementDetailModel {
  VideoElementDetailModel({
    this.src,
    this.type,
    this.poster,
    this.controls,
    this.width,
    this.height,
  });

  String? src;
  String? type;
  String? poster;
  String? controls;
  String? width;
  String? height;

  /// 水平播放
  bool get isHorizontal {
    final result = (width ?? "auto").compareTo(height ?? "auto") >= 0;
    return result;
  }

  VideoElementDetailModel.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    type = json['type'];
    poster = json['poster'];
    controls = json['controls'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['src'] = src;
    data['type'] = type;
    data['poster'] = poster;
    data['controls'] = controls;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
