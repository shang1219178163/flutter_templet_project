//
//  SecureKeyboardTextfieldDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/10/22 18:40.
//  Copyright © 2024/10/22 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class SecureKeyboardDemo extends StatefulWidget {
  const SecureKeyboardDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<SecureKeyboardDemo> createState() => _SecureKeyboardDemoState();
}

class _SecureKeyboardDemoState extends State<SecureKeyboardDemo> {
  final _scrollController = ScrollController();

  /// 账号焦点
  final focusNodeAccount = FocusNode();

  /// 密码焦点
  final focusNodePwd = FocusNode();

  @override
  void didUpdateWidget(covariant SecureKeyboardDemo oldWidget) {
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
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Text("$widget"),
            Listener(
              onPointerDown: (event) async {
                // YLog.d("onPointerDown: $event");
                await Future.delayed(const Duration(milliseconds: 350));
                focusNodeAccount.requestFocus();
              },
              child: TextField(
                focusNode: focusNodeAccount,
                decoration: InputDecoration(
                  border: buildBorder(),
                  focusedBorder: buildBorder(),
                  hintText: "账号",
                  hintStyle: TextStyle(fontSize: 15, color: Color(0xffB3B3B3)),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Listener(
              onPointerDown: (event) async {
                // YLog.d("onPointerDown: $event");
                await Future.delayed(const Duration(milliseconds: 350));
                focusNodePwd.requestFocus();
              },
              child: TextField(
                focusNode: focusNodePwd,
                decoration: InputDecoration(
                  border: buildBorder(),
                  focusedBorder: buildBorder(),
                  hintText: "密码",
                  hintStyle: TextStyle(fontSize: 15, color: Color(0xffB3B3B3)),
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder({
    Color color = const Color(0xffe4e4e4),
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: .5),
      borderRadius: BorderRadius.circular(4),
    );
  }
}
