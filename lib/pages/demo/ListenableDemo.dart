//
//  ListenableDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/13 12:14.
//  Copyright © 2025/3/13 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:get/get.dart';

class ListenableDemo extends StatefulWidget {
  const ListenableDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ListenableDemo> createState() => _ListenableDemoState();
}

class _ListenableDemoState extends State<ListenableDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final _focusNode = FocusNode();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  final _textController = TextEditingController();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();

  late final items = [
    (focusNode: _focusNode, controller: _textController),
    (focusNode: _focusNode1, controller: _textController1),
    (focusNode: _focusNode2, controller: _textController2),
  ];

  @override
  void dispose() {
    items.forEach((e) {
      e.focusNode.removeListener(onKeyborad);
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    items.forEach((e) {
      e.focusNode.addListener(onKeyborad);
    });
  }

  void onKeyborad() {
    final list = items.map((e) {
      final i = items.indexOf(e);
      final desc = "${e.focusNode.hasFocus}";
      return desc;
    }).toList();
    DLog.d("${list.asMap()}");
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
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...items.map((e) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildTextfield(
                      focusNode: e.focusNode,
                      controller: e.controller,
                    ),
                    buildListenable(
                      focusNode: e.focusNode,
                      controller: e.controller,
                    ),
                    Divider(height: 16),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextfield({
    required FocusNode focusNode,
    required TextEditingController controller,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: InputDecoration(
        hintText: '请输入',
        hintStyle: TextStyle(fontSize: 14),
        // labelText: labelText,
        // border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            controller.clear();
            focusNode.requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  Widget buildListenable({
    required FocusNode focusNode,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([
            focusNode,
          ]),
          builder: (context, child) {
            final value = focusNode.hasFocus;
            final desc = "AnimatedBuilder: ${value ? "展示键盘" : "隐藏键盘"}";
            return Text(desc);
          },
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            focusNode,
          ]),
          builder: (context, child) {
            final value = focusNode.hasFocus;
            final desc = "ListenableBuilder: ${value ? "展示键盘" : "隐藏键盘"}";
            return Text(desc);
          },
        ),
      ],
    );
  }
}
