//
//  UrlLauncherDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/11/27 10:45.
//  Copyright © 2024/11/27 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherDemo extends StatefulWidget {
  const UrlLauncherDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<UrlLauncherDemo> createState() => _UrlLauncherDemoState();
}

class _UrlLauncherDemoState extends State<UrlLauncherDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant UrlLauncherDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
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
        child: Column(
          children: [
            // url
            ElevatedButton(
              onPressed: () => onOpenUrl("https://baidu.com"),
              child: const Text('打开 baidu.com'),
            ),

            // url app 内打开
            ElevatedButton(
              onPressed: () => onOpenUrl(
                "https://baidu.com",
                mode: LaunchMode.inAppWebView,
              ),
              child: const Text('APP 内，打开 baidu.com'),
            ),

            // url app 内打开
            ElevatedButton(
              onPressed: () => onOpenUrl(
                "https://baidu.com",
                mode: LaunchMode.externalApplication,
              ),
              child: const Text('外部，打开 baidu.com'),
            ),

            // email
            ElevatedButton(
              onPressed: () => onSendMail("ducafecat@gmail.com", "邮件标题", "邮件正文"),
              child: const Text('发送邮件'),
            ),

            // sms
            ElevatedButton(
              onPressed: () => onSendSMS("+1234567890", "短信正文"),
              child: const Text('发送短信'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onOpenUrl(String url, {LaunchMode? mode}) async {
    Uri uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
    if (!await launchUrl(
      uri,
      mode: mode ?? LaunchMode.platformDefault,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Future<void> onSendMail(String to, String subject, String body) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: to,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch $to');
    }
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $to');
    }
  }

  Future<void> onSendSMS(String phone, String body) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{
        'body': body,
      },
    );
    if (!await canLaunchUrl(uri)) {
      throw Exception('Could not launch sms $phone');
    }
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch sms $phone');
    }
  }
}
