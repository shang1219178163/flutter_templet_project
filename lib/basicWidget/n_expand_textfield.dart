//
//  NExpandTextfield.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/16 14:50.
//  Copyright © 2024/3/16 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';


/// 用 Textfield实现的文字折叠组件
class NExpandTextfield extends StatefulWidget {
   const NExpandTextfield({
    super.key,
    required this.text,
    required this.textStyle,
    this.expandMaxLine,
    this.expandMinLine = 3,
    // this.expandTitleStyle,
    this.readOnly = true,
    this.maxLength = 300,
    this.initiallyExpanded = false,
  });

  /// 字符串
  final String text;

  /// 字符串样式
   final TextStyle? textStyle;

  /// 超过一行初始展开状态
   final bool initiallyExpanded;

  /// 展开状态最大行
   final int? expandMaxLine;

  /// 展开状态最小行
   final int expandMinLine;

  /// 最大字符数
   final int maxLength;

   final bool readOnly;

   /// 展开按钮文字样式
   // final TextStyle? expandTitleStyle;

  @override
  _NExpandTextfieldState createState() => _NExpandTextfieldState();
}

class _NExpandTextfieldState extends State<NExpandTextfield> {
  late bool isExpand = widget.initiallyExpanded;

  final textEditingController = TextEditingController();

  late final wordCount =
      ValueNotifier(textEditingController.text.characters.length);

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(onListener);
  }

  void onListener() {
    wordCount.value = textEditingController.text.characters.length;
    ddlog(
        "onListener: ${textEditingController.text.length},${textEditingController.text.characters.length}");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final textPainter = TextPainterExt.getTextPainter(
        text: widget.text,
        textStyle: widget.textStyle,
        maxLine: widget.expandMinLine,
        maxWidth: constraints.maxWidth,
      );
      // final numberOfLines = textPainter.computeLineMetrics().length;
      // debugPrint("numberOfLines:${numberOfLines}");

      var isBeyond = textPainter.didExceedMaxLines;

      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        // final btnTitle = isExpand ? "收起" : "展开";

        final toggleImage = (isExpand
                ? "icon_expand_arrow_up.png"
                : "icon_expand_arrow_down.png")
            .toAssetImage();

        onToggle() {
          isExpand = !isExpand;
          setState(() {});
        }

        final child = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildTextField(
              text: widget.text,
              style: widget.textStyle,
              maxLines: isExpand ? widget.expandMaxLine : widget.expandMinLine,
              readOnly: widget.readOnly,
              maxLength: widget.maxLength,
            ),
            // if(numberOfLines > 1) Padding(
            //   padding: EdgeInsets.only(bottom: 8),
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.zero,
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       minimumSize: Size(50, 18),
            //     ),
            //     onPressed: (){
            //       isExpand = !isExpand;
            //       setState((){});
            //     },
            //     child: Text(btnTitle, style: expandTitleStyle,),
            //   ),
            // ),
            Offstage(
              offstage: !isBeyond || !widget.readOnly,
              child: InkWell(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  alignment: Alignment.center,
                  child: Image(
                    image: toggleImage,
                    width: 21,
                    height: 8,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        );

        if (!widget.readOnly) {
          return child;
        }

        return Stack(
          children: [
            child,
            Positioned(
              bottom: 25,
              left: 0,
              right: 0,
              child: Visibility(
                visible: isBeyond && !isExpand,
                child: InkWell(
                  onTap: onToggle,
                  child: Container(
                    width: double.maxFinite,
                    height: 25,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x99FFFFFF), Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      });
    });
  }

  Widget buildTextField({
    required String text,
    required TextStyle? style,
    required int? maxLines,
    bool readOnly = true,
    int maxLength = 150,
  }) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    );

    textEditingController.text = text;

    return TextField(
      controller: textEditingController,
      style: style,
      textAlignVertical: TextAlignVertical.center,
      maxLines: maxLines,
      scrollPhysics: readOnly ? NeverScrollableScrollPhysics() : null,
      readOnly: readOnly,
      maxLength: readOnly? null : maxLength,
      decoration: InputDecoration(
        // labelText: "请输入",
        hintText: "请输入",
        hintStyle: TextStyle(color: Colors.black38),
        filled: true,
        // fillColor: Colors.yellow,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // counterText: readOnly ? null : "${textEditingController.text.length}/$maxWordCount",
        counter: readOnly ? null : ValueListenableBuilder(
          valueListenable: wordCount,
          builder: (context, value, child) {

              return Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$value",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: '/$maxLength',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF737373),
                      ),
                    ),
                  ],
                ),
                maxLines: 3,
              );

            }),
        // isCollapsed: isCollapsed,
        // contentPadding: contentPadding,
        // suffixIcon: suffixIcon,
        // suffixIconConstraints: suffixIconConstraints,
      ),
    );
  }
}
