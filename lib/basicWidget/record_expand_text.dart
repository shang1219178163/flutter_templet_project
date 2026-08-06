// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_shader_text.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/generated/assets.dart';

/// 档案文字展开/收起组件
class RecordExpandText extends StatefulWidget {
  RecordExpandText({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
      overflow: TextOverflow.clip,
    ),
    this.expandMinLine = 3,
    this.disableExpand = false,
    this.isExpand = false,
    this.tailing,
    this.tailingWidth = 0,
    this.textBuilder,
  });

  final String text;

  final TextStyle? textStyle;
  final int expandMinLine;

  /// 是否禁用折叠, 默认 false
  final bool disableExpand;

  /// 会看来回变化
  final bool isExpand;
  final Widget? tailing;
  final double tailingWidth;

  final Widget Function(bool isExpand, int expandMinLine)? textBuilder;

  @override
  RecordExpandTextState createState() => RecordExpandTextState();
}

class RecordExpandTextState extends State<RecordExpandText> {
  late bool isExpand = widget.isExpand;

  @override
  void didUpdateWidget(covariant RecordExpandText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text ||
        widget.textStyle != oldWidget.textStyle ||
        widget.isExpand != oldWidget.isExpand ||
        widget.disableExpand != oldWidget.disableExpand ||
        widget.tailing != oldWidget.tailing ||
        widget.tailingWidth != oldWidget.tailingWidth) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // assert(widget.tailing != null && widget.tailingWidth > 0 || widget.tailing == null,
    //     "tailingWidth 应该是tailing的宽度");
    if (widget.disableExpand) {
      return Row(
        children: [
          Expanded(
            child: NText(
              widget.text,
              fontSize: 16,
              maxLines: null,
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.w400,
              style: widget.textStyle,
            ),
          ),
          widget.tailing ?? const SizedBox(),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainterExt.getTextPainter(
          text: widget.text,
          textStyle: widget.textStyle,
          maxLine: widget.expandMinLine,
          maxWidth: (constraints.maxWidth - widget.tailingWidth),
        );
        // final numberOfLines = textPainter.computeLineMetrics().length;
        // debugPrint("numberOfLines:${numberOfLines}");
        var isBeyond = textPainter.didExceedMaxLines;
        // DLog.d([
        //   widget.text.length,
        //   constraints.maxWidth - widget.tailingWidth,
        //   textPainter.height,
        //   textPainter.didExceedMaxLines,
        //   textPainter.computeLineMetrics().length,
        // ].asMap().toString());

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // final btnTitle = isExpand ? "收起" : "展开";

            final toggleImage = AssetImage((isExpand) ? Assets.imagesIconExpandArrowUp : Assets.imagesIconExpandArrowDown);
            // gradientColor = Colors.blue;

            onToggle() {
              isExpand = !isExpand;
              setState(() {});
            }

            final textChild = widget.textBuilder?.call(isExpand, widget.expandMinLine) ??
                NText(
                  widget.text,
                  fontSize: 16,
                  maxLines: isExpand ? null : widget.expandMinLine,
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w400,
                  style: widget.textStyle,
                );

            final textContent = Row(
              children: [
                Expanded(
                  child: isBeyond
                      ? NShaderText(
                          hasShader: isExpand,
                          child: textChild,
                        )
                      : textChild,
                ),
                widget.tailing ?? const SizedBox(),
              ],
            );
            if (!isBeyond) {
              return textContent;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                textContent,
                Offstage(
                  offstage: !isBeyond,
                  child: InkWell(
                    onTap: onToggle,
                    child: Container(
                      padding: const EdgeInsets.only(top: 11),
                      alignment: Alignment.center,
                      child: Image(
                        image: toggleImage,
                        width: 21,
                        height: 8,
                        color: context.themeData.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
