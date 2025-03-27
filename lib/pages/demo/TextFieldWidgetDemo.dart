//
//  TextFieldWidgetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/8/30 23:46.
//  Copyright © 2024/8/30 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_text_view.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield_search.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';

class TextFieldWidgetDemo extends StatefulWidget {
  const TextFieldWidgetDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<TextFieldWidgetDemo> createState() => _TextFieldWidgetDemoState();
}

class _TextFieldWidgetDemoState extends State<TextFieldWidgetDemo> {
  bool get hideApp =>
      Get.currentRoute.toLowerCase() != "/$widget".toLowerCase();

  final _scrollController = ScrollController();

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
    return SafeArea(
      child: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              NSectionBox(
                title: "NTextField",
                child: NButton.tonal(
                  title: "取消焦点",
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
              NSectionBox(
                title: "NTextField",
                child: buildNTextField(
                  decorationBuilder: (dt) {
                    return dt.copyWith(fillColor: Colors.white);
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: NSectionBox(
                  title: "NTextField - hideSuffix",
                  child: buildNTextField(
                    hideSuffix: true,
                    decorationBuilder: (dt) {
                      return dt.copyWith(fillColor: bgColor);
                    },
                  ),
                ),
              ),
              NSectionBox(
                title: "NTextField - hidePrefix",
                child: buildNTextField(
                  prefixImage: AssetImage("assets/images/icon_account.png"),
                  suffixImage: AssetImage("assets/images/icon_camera.png"),
                  decorationBuilder: (dt) {
                    return dt.copyWith(fillColor: Colors.white);
                  },
                ),
              ),
              NSectionBox(
                title: "NTextField - hidePrefix & hideSuffix",
                child: buildNTextField(
                  hidePrefix: true,
                  hideSuffix: true,
                  decorationBuilder: (dt) {
                    return dt.copyWith(fillColor: Colors.white);
                  },
                ),
              ),
              NSectionBox(
                title: "NTextField - hidePrefix & hideSuffix & maxLines: 4",
                child: buildNTextField(
                  maxLines: 4,
                  maxLength: 200,
                  hidePrefix: true,
                  hideSuffix: true,
                  hideClear: true,
                  decorationBuilder: (dt) {
                    return dt.copyWith(fillColor: Colors.white);
                  },
                ),
              ),
              NSectionBox(
                title: "NTextView - counterInner: false",
                child: NTextView(
                  isCounterInner: false,
                  minLines: 4,
                  onChanged: (String value) {},
                ),
              ),
              NSectionBox(
                title: "NTextView - counterInner: true",
                child: NTextView(
                  isCounterInner: true,
                  minLines: 4,
                  onChanged: (String value) {},
                ),
              ),
              NSectionBox(
                title: "NSearchTextField",
                child: NSearchTextField(
                  backgroundColor: Colors.white,
                  onChanged: (String value) {},
                ),
              ),
              NSectionBox(
                title: "NSearchTextField - textAlign: TextAlign.center",
                child: NSearchTextField(
                  backgroundColor: Colors.white,
                  textAlign: TextAlign.center,
                  onChanged: (String value) {},
                ),
              ),
              NSectionBox(
                title: "NSearchBar ",
                child: NSearchBar(
                  onChanged: (String value) {},
                  onCancel: () {},
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: NSectionBox(
                  title: "NSearchBar ",
                  child: NSearchBar(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    onChanged: (String value) {},
                    onCancel: () {},
                  ),
                ),
              ),
              // NSectionHeader(
              //   title: "CupertinoSearchTextField",
              //   child: CupertinoSearchTextField(
              //     backgroundColor: Colors.white,
              //     onChanged: (String value) {},
              //   ),
              // ),
              // NSectionHeader(
              //   title: "CupertinoTextField",
              //   child: CupertinoTextField(
              //     placeholder: "🔍搜索",
              //     minLines: 1,
              //     maxLines: 4,
              //     textAlign: TextAlign.center,
              //     onChanged: (String value) {},
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNTextField({
    FocusNode? focusNode,
    bool hidePrefix = false,
    bool hideSuffix = false,
    bool hideClear = false,
    AssetImage? prefixImage,
    AssetImage? suffixImage,
    Widget? suffix,
    int? maxLines,
    int? maxLength,
    InputDecoration Function(InputDecoration decoration)? decorationBuilder,
  }) {
    // final prefixImage = Image(
    //   image: AssetImage("assets/images/icon_search.png"),
    //   width: 16,
    //   height: 16,
    //   fit: BoxFit.fill,
    // );
    // final prefixPadding = const EdgeInsets.only(left: 8, right: 4);
    // final prefixIconConstraints = BoxConstraints(
    //   maxHeight: prefixImage.height!,
    //   maxWidth: prefixImage.width! + prefixPadding.left + prefixPadding.right,
    // );
    //
    // final suffixImage = Image(
    //   image: AssetImage("assets/images/icon_scan.png"),
    //   width: 16,
    //   height: 16,
    //   fit: BoxFit.fill,
    // );
    // final suffixPadding = const EdgeInsets.only(left: 4, right: 8);
    // final suffixIconConstraints = BoxConstraints(
    //   maxHeight: suffixImage.height!,
    //   maxWidth: suffixImage.width! + suffixPadding.left + suffixPadding.right,
    // );
    return NTextField(
      focusNode: focusNode,
      isCollapsed: true,
      // fillColor: Colors.white,
      // contentPadding: const EdgeInsets.only(
      //   left: 8,
      //   right: 8,
      //   top: 6,
      //   bottom: 6,
      // ),
      // prefixIconBuilder: (isFocus) {
      //   return Padding(padding: prefixPadding, child: prefixImage);
      // },
      // prefixIconConstraints: prefixIconConstraints,
      // suffixIconBuilder: (isFocus) {
      //   return Padding(padding: suffixPadding, child: suffixImage);
      // },
      // suffixIconConstraints: suffixIconConstraints,
      // suffix: Icon(Icons.cancel, size: 16, color: Colors.black38),
      maxLines: maxLines,
      maxLength: maxLength,
      prefixImage: prefixImage,
      suffixImage: suffixImage,
      hidePrefix: hidePrefix,
      hideSuffix: hideSuffix,
      hideClear: hideClear,
      decorationBuilder: decorationBuilder,
      onChanged: (String value) {
        if (value.trim().isEmpty) {
          DLog.d("$this onChanged 不能为空");
          return;
        }
      },
    );
  }
}
