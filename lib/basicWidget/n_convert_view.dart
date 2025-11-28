//
//  NTransformView.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/27 09:02.
//  Copyright © 2024/4/27 shang. All rights reserved.
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

/// 字符串转文件
class NConvertView extends StatefulWidget {
  const NConvertView({
    super.key,
    this.controller,
    this.title,
    this.message,
    this.header,
    this.start,
    this.end,
    required this.toolbarBuilder,
  });

  /// 控制器
  final NTransformViewController? controller;

  /// 标题
  final Widget? title;

  /// 描述
  final Widget? message;

  /// 顶部组件
  final Widget? header;

  /// 头部组件
  final Widget? start;

  /// 尾部组件
  final Widget? end;

  final Widget Function(BuildContext context) toolbarBuilder;

  @override
  NConvertViewState createState() => NConvertViewState();
}

class NConvertViewState extends State<NConvertView> {
  final extraController = TextEditingController();
  final extraFocusNode = FocusNode();

  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  final scrollController = ScrollController();
  final scrollControllerRight = ScrollController();

  final outVN = ValueNotifier("");

  // bool get isDrag => Platform.isMacOS && widget.canDrag;

  List<File> files = [];

  @override
  void dispose() {
    super.dispose();
    widget.controller?._detach(this);
  }

  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final direction = constraints.maxWidth > 500 ? Axis.horizontal : Axis.vertical;
      if (direction == Axis.horizontal) {
        return buildBodyHorizontal(constraints: constraints);
      }
      return buildBodyVertical(constraints: constraints);
    });
  }

  Widget buildBodyVertical({
    double spacing = 10,
    required BoxConstraints constraints,
  }) {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.all(spacing * 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              SizedBox(
                height: constraints.maxHeight * 0.7,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(
                height: spacing * 3,
              ),
              Container(
                child: buildRight(controller: scrollControllerRight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBodyHorizontal({
    double spacing = 10,
    required BoxConstraints constraints,
  }) {
    return Container(
      padding: EdgeInsets.all(spacing * 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTop(),
          Expanded(
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildLeft(width: constraints.maxWidth * 0.45),
                  SizedBox(
                    width: spacing * 3,
                  ),
                  Expanded(
                    child: buildRight(controller: scrollControllerRight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTop({
    bool isVertical = false,
    double spacing = 10,
  }) {
    return widget.header ??
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.title ?? const SizedBox(),
            if (widget.title != null) SizedBox(height: spacing),
            widget.message ?? const SizedBox(),
            if (widget.message != null) SizedBox(height: spacing * 2),
          ],
        );
  }

  Widget buildTextfield({
    hintText = "请输入",
    maxLines = 1,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xff999999),
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        fillColor: AppColor.bgColorEDEDED,
        filled: true,
        hoverColor: AppColor.bgColorEDEDED,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
      onChanged: (val) async {
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val) {
        debugPrint("onSubmitted: $val");
      },
      onEditingComplete: () {
        debugPrint("onEditingComplete: ");
      },
      // onTap: (){
      //   debugPrint("onTap: ${controller?.value.text}");
      // },
      // onTapOutside: (e){
      //   debugPrint("onTapOutside: $e ${controller?.value.text}");
      // },
    );
  }

  Widget buildLeft({
    bool isVertical = false,
    double spacing = 10,
    double width = 400,
  }) {
    double? maxWidth = isVertical ? double.maxFinite : width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            width: maxWidth,
            child: widget.start ??
                Column(
                  children: [
                    Expanded(
                      child: buildTextfield(
                        controller: textEditingController,
                        focusNode: focusNode,
                        maxLines: 200,
                        hintText: "input",
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8),
                      child: buildTextfield(
                        controller: extraController,
                        focusNode: extraFocusNode,
                        maxLines: 1,
                        hintText: "",
                      ),
                    ),
                  ],
                ),
          ),
        ),
        const SizedBox(height: 8),
        widget.toolbarBuilder(context),
      ],
    );
  }

  Widget buildRight({
    required ScrollController controller,
    double spacing = 10,
    bool selectable = true,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: outVN,
      builder: (context, value, child) {
        final text = selectable ? SelectableText(value) : NText(value);

        return widget.end ??
            Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 4, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: const Color(0xffe4e4e4), width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: controller,
                  child: text,
                ),
              ),
            );
      },
    );
  }
}

class NTransformViewController {
  NConvertViewState? _anchor;

  void _attach(NConvertViewState anchor) {
    _anchor = anchor;
  }

  void _detach(NConvertViewState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  TextEditingController get extraController {
    return _anchor!.extraController;
  }

  set extra(String value) {
    extraController.text = value;
  }

  String get extra {
    return extraController.text;
  }

  TextEditingController get textEditingController {
    return _anchor!.textEditingController;
  }

  ValueNotifier<String> get outVN {
    return _anchor!.outVN;
  }

  set input(String value) {
    textEditingController.text = value;
  }

  String get input {
    return textEditingController.text;
  }

  set out(String value) {
    _anchor!.outVN.value = value;
  }

  String get out {
    return _anchor!.outVN.value;
  }

  Future<void> paste() async {
    var data = await Clipboard.getData("text/plain");
    final str = data?.text ?? "";
    if (str.isNotEmpty) {
      textEditingController.text = str;
    }
  }

  void clear() {
    textEditingController.text = "";
    out = "";
  }
}
