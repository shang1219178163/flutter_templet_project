

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/model_generator.dart';


/// 字符串转文件
class NTransformView extends StatefulWidget {

  NTransformView({
    super.key,
    this.controller,
    required this.title,
    required this.message,
    required this.toolbarBuilder,
  });

  final NTransformViewController? controller;

  final Widget title;
  final Widget message;

  final Widget Function(BuildContext context) toolbarBuilder;

  @override
  NTransformViewState createState() => NTransformViewState();
}

class NTransformViewState extends State<NTransformView> {

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final _scrollController = ScrollController();

  final outVN = ValueNotifier("");

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
    return LayoutBuilder(
      builder: (context, constraints) {

        final direction = constraints.maxWidth > 500 ? Axis.horizontal : Axis.vertical;
        if (direction == Axis.horizontal) {
          return buildBodyHorizontal(constraints: constraints);
        }
        return buildBodyVertical(constraints: constraints);
      }
    );
  }

  Widget buildBodyVertical({double spacing = 10, required BoxConstraints constraints}) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(spacing*3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTop(),
              Container(
                height: constraints.maxHeight * 0.7,
                child: buildLeft(isVertical: true),
              ),
              SizedBox(height: spacing*3,),
              Container(
                child: buildRight(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBodyHorizontal({double spacing = 10, required BoxConstraints constraints}) {
    return Container(
      padding: EdgeInsets.all(spacing*3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTop(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildLeft(width: constraints.maxWidth * 0.45),
                SizedBox(width: spacing*3,),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.title,
        SizedBox(height: spacing,),
        widget.message,
        SizedBox(height: spacing*2,),
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
        fillColor: bgColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        counterText: '',
      ),
      onChanged: (val) async{
        // debugPrint("onChanged: $val");
      },
      onSubmitted: (val){
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
          child: Container(
            width: maxWidth,
            child: buildTextfield(
              controller: _textEditingController,
              focusNode: _focusNode,
              maxLines: 200,
            ),
          ),
        ),
        SizedBox(height: 8,),
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
      builder: (context,  value, child){

        final child = selectable ?
        SelectableText(value,
          // maxLines: 1000,
        ) : NText(value,
          // maxLines: 1000,
        );

        return Scrollbar(
          controller: controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: controller,
            child: child,
          ),
        );
      }
    );
  }

}


class NTransformViewController {

  NTransformViewState? _anchor;

  void _attach(NTransformViewState anchor) {
    _anchor = anchor;
  }

  void _detach(NTransformViewState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }


  TextEditingController get textEditingController {
    return _anchor!._textEditingController;
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