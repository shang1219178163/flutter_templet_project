//
//  EmailSenderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/2/5 18:04.
//  Copyright © 2025/2/5 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class EmailSenderDemo extends StatefulWidget {
  const EmailSenderDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<EmailSenderDemo> createState() => _EmailSenderDemoState();
}

class _EmailSenderDemoState extends State<EmailSenderDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant EmailSenderDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
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
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: onSendEmail,
              child: Text('发送邮件'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSendEmail() async {
    final email = Email(
      body: '这是邮件的内容',
      subject: '邮件主题',
      recipients: ['example@example.com'],
      isHTML: false, // 如果需要 HTML 格式的邮件，将此设置为 true
    );

    try {
      await FlutterEmailSender.send(email);
      DLog.d('邮件已发送');
    } catch (e) {
      DLog.d('邮件发送失败: $e');
    }
  }
}
