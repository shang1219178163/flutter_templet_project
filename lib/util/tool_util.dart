//
//  ToolUtil.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/21 21:31.
//  Copyright © 2024/6/21 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_image_preview.dart';
import 'package:flutter_templet_project/basicWidget/n_webview_page.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/routes/APPRouter.dart';
import 'package:flutter_templet_project/util/fade_page_route.dart';
import 'package:flutter_templet_project/vendor/file_preview/file_preview_page.dart';
import 'package:flutter_templet_project/vendor/file_preview/webview_file_preview_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolUtil {
  // 创建一个全局的GlobalKey
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // 全局获取context
  static get globalContext => navigatorKey.currentState!.overlay!.context;

  // 移除输入框焦点
  static void removeInputFocus() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(globalContext).unfocus();
    FocusManager.instance.primaryFocus?.unfocus(); //（flutter 框架本身持有一个焦点，需要手动失焦）。
  }

  // 访问外部链接
  static Future<void> openLaunchUrl(String url) async {
    final Uri launchUri = Uri.parse(url);
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );
  }

  // doc、docx、pdf等预览
  static void filePreview(String title, String path) {
    if (Platform.isAndroid) {
      openLaunchUrl(path); // 安卓
    } else {
      Navigator.push(
        globalContext,
        MaterialPageRoute(builder: (context) {
          if (path.startsWith("http")) {
            return WebviewFilePreviewPage(
              title: title,
              url: path,
            );
          }
          return FilePreviewPage(title: title, path: path);
        }),
      );
    }
  }

  // 隐私协议等webview
  static void webViewPreview(String url, {String title = ""}) {
    Navigator.push(
      globalContext,
      MaterialPageRoute(
        builder: (context) => NWebViewPage(
          url: url,
          title: title,
        ),
      ),
    );
  }

  // 查看大图
  static void imagePreview(List<String> urls, int index) {
    FocusScope.of(globalContext).unfocus();
    Navigator.push(
      globalContext,
      FadePageRoute(
        builder: (context) => NImagePreview(
          urls: urls,
          index: index,
        ),
      ),
    );
  }

  /// 返回登录页
  static toLoginPage() {
    if (Get.currentRoute != APPRouter.loginPage) {
      Get.offAllNamed(APPRouter.loginPage);
    }
  }

  static toPage(String page) {
    if (Get.currentRoute != page) {
      Get.toNamed(page);
    }
  }
}
