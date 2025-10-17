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
  NConvertView({
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
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final _scrollController = ScrollController();

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
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(spacing * 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              Container(
                height: constraints.maxHeight * 0.7,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(
                height: spacing * 3,
              ),
              Container(
                child: buildRight(),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLeft(width: constraints.maxWidth * 0.45),
                SizedBox(
                  width: spacing * 3,
                ),
                Expanded(
                  child: buildRight(),
                ),
              ],
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
            widget.title ?? SizedBox(),
            if (widget.title != null) SizedBox(height: spacing),
            widget.message ?? SizedBox(),
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
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xff999999),
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

    var child = widget.start ??
        buildTextfield(
          controller: _textEditingController,
          focusNode: _focusNode,
          maxLines: 200,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: maxWidth,
            child: child,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        widget.toolbarBuilder(context),
      ],
    );
  }

  Widget buildRight({
    ScrollController? controller,
    double spacing = 10,
    bool selectable = true,
  }) {
    return ValueListenableBuilder<String>(
      valueListenable: outVN,
      builder: (context, value, child) {
        final text = selectable
            ? SelectableText(
                value,
                // maxLines: 1000,
              )
            : NText(
                value,
                // maxLines: 1000,
              );

        return widget.end ??
            Container(
              padding: EdgeInsets.only(left: 4, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Color(0xffe4e4e4), width: 1),
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

  TextEditingController get textEditingController {
    return _anchor!._textEditingController;
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
