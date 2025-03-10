import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';

class NExpandTextOne extends StatefulWidget {
  const NExpandTextOne({
    super.key,
    required this.data,
    this.textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    required this.isExpand,
    this.tailing,
    this.tailingWidth = 0,
    this.expandBuilder,
  });

  final String data;
  final TextStyle textStyle;
  final bool isExpand;
  final Widget? tailing;
  final double tailingWidth;

  /// 整个自定义
  final Widget Function(bool isExpand, VoidCallback onToggle)? expandBuilder;

  @override
  State<NExpandTextOne> createState() => _NExpandTextOneState();
}

class _NExpandTextOneState extends State<NExpandTextOne> {
  late bool isExpand = widget.isExpand;

  @override
  void didUpdateWidget(covariant NExpandTextOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.textStyle != oldWidget.textStyle ||
        widget.isExpand != oldWidget.isExpand ||
        widget.tailing != oldWidget.tailing ||
        widget.tailingWidth != oldWidget.tailingWidth ||
        widget.expandBuilder != oldWidget.expandBuilder) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.tailing != null && widget.tailingWidth > 0 || widget.tailing == null, "tailingWidth 应该是tailing的宽度");

    onToggle() {
      isExpand = !isExpand;
      setState(() {});
    }

    final arrowImage = isExpand ? "icon_expand_arrow_up.png" : "icon_expand_arrow_down.png";

    Widget buildArrow() {
      // return Text(
      //   isExpand ? "收起" : "展开",
      //   style: TextStyle(
      //     color: context.primaryColor,
      //   ),
      // );

      return Image(
        image: arrowImage.toAssetImage(),
        width: 21,
        height: 8,
      );
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final textPainter = TextPainterExt.getTextPainter(
        text: widget.data,
        textStyle: widget.textStyle,
        maxLine: 3,
        maxWidth: (constraints.maxWidth - widget.tailingWidth),
      );

      final isBeyond = textPainter.didExceedMaxLines;
      // DLog.d([data.length,
      //   constraints.maxWidth - tailingWidth,
      //   textPainter.height,
      //   textPainter.didExceedMaxLines,
      //   textPainter.computeLineMetrics().length,
      // ].asMap());

      return widget.expandBuilder?.call(isExpand, onToggle) ??
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              // color: Colors.green,
              border: Border.all(color: Colors.blue),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                // horizontal: 8,
                                // vertical: 8,
                                ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.05),
                            ),
                            child: Text(
                              widget.data,
                              style: widget.textStyle,
                              maxLines: isExpand ? null : 3,
                            ),
                          ),
                          if (isBeyond)
                            InkWell(
                              onTap: onToggle,
                              child: Container(
                                height: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    // color: context.primaryColor.withOpacity(0.3),
                                    // gradient: isExpand ? null : LinearGradient(
                                    //   colors: [
                                    //     Colors.red.withOpacity(0.5),
                                    //     Colors.red,
                                    //   ],
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    // ),
                                    ),
                                child: !isExpand ? null : buildArrow(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    widget.tailing ?? SizedBox(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: !isBeyond || isExpand ? 0 : 1,
                    child: InkWell(
                      onTap: onToggle,
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x99FFFFFF).withOpacity(0.6),
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: buildArrow(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
    });
  }
}
