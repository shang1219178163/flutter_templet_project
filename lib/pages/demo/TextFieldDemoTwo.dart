//
//  TextFieldDemoTwo.dart
//  flutter_templet_project
//
//  Created by shang on 8/14/21 9:43 AM.
//  Copyright © 8/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_textfield.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';

import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:get/get.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class TextFieldDemoTwo extends StatefulWidget {
  TextFieldDemoTwo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TextFieldDemoTwo> createState() => _TextFieldDemoTwoState();
}

class _TextFieldDemoTwoState extends State<TextFieldDemoTwo> with SingleTickerProviderStateMixin {
  bool get hideApp => Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

  late final tabController = TabController(length: items.length, vsync: this);

  var readOnly = ValueNotifier(false);

  late final items = [
    (name: "可编辑", action: onEdit),
    (name: "不可编辑", action: onOnlyRead),
    (name: "内容初始化", action: onInitial),
    (name: "小于三行", action: onMax60),
    // (name: "其他", action: onPressed),
  ];

  final textEditingController = TextEditingController();

  final String messgae =
      "今天我们向您介绍一个新的Flutter版本，Flutter 3.19。此版本为Gemini带来了一个新的Dart SDK，该SDK使开发人员能够对小部件动画进行细粒度控制，通过对Impeller进行更新提升了渲染性能，提供了工具来帮助实现深链接，支持Windows Arm64等等！Flutter社区继续给人留下深刻印象，由168名社区成员合并了1429个拉取请求，其中43名社区成员提交了他们的第一个Flutter拉取请求！继续阅读以了解Flutter社区为这个最新版本做出的所有新增和改进！";

  @override
  void initState() {
    super.initState();

    textEditingController.text = messgae;
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

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            buildTabbar(),
            // NSectionHeader(
            //   title: "TextField",
            //   child: buildTextField(),
            // ),
            NSectionBox(
              title: "填空组件封装",
              child: Container(
                // color: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ValueListenableBuilder(
                    valueListenable: readOnly,
                    builder: (context, value, child) {
                      return NExpandTextfield(
                        text: textEditingController.text,
                        isExpand: true,
                        expandMaxLine: null,
                        readOnly: value,
                        textStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      );
                    }),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.bgColor,
              ),
              child: NSectionBox(
                title: "填空组件封装 - 白底",
                child: Container(
                  // color: Colors.yellowAccent,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: readOnly,
                      builder: (context, value, child) {
                        return NExpandTextfield(
                          text: textEditingController.text,
                          isExpand: true,
                          expandMaxLine: null,
                          fillColor: Colors.white,
                          readOnly: value,
                          textStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildTabbar() {
    return Material(
      // color: Theme.of(context).colorScheme.primary,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: items.map((e) => Tab(key: PageStorageKey<String>(e.name), text: e.name)).toList(),
        labelColor: context.primaryColor,
        // indicatorSize: TabBarIndicatorSize.label,
        // indicatorPadding: EdgeInsets.only(left: 6, right: 6),
        indicatorColor: context.primaryColor,
        onTap: (index) => items[index].action(),
      ),
    );
  }

  Widget buildTextField() {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    );

    return ValueListenableBuilder(
        valueListenable: readOnly,
        builder: (context, value, child) {
          return TextField(
            controller: textEditingController,
            readOnly: value,
            textAlignVertical: TextAlignVertical.center,
            maxLines: null,
            decoration: InputDecoration(
              // labelText: "请输入",
              hintText: "请输入",
              hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
              labelStyle: TextStyle(fontSize: 14),
              filled: true,
              // fillColor: Colors.yellow,
              border: border,
              enabledBorder: border,
              focusedBorder: border,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              // isCollapsed: isCollapsed,
              // contentPadding: contentPadding,
              // suffixIcon: suffixIcon,
              // suffixIconConstraints: suffixIconConstraints,
            ),
          );
        });
  }

  onEdit() {
    readOnly.value = false;
  }

  onOnlyRead() {
    readOnly.value = true;
  }

  onMax60() {
    textEditingController.text = textEditingController.text.substring(0, 60);
    setState(() {});
  }

  onInitial() {
    textEditingController.text = messgae;
    setState(() {});
  }

  onPressed() {}
}
