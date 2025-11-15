//
//  NExpandTextVertical.dart
//  flutter_templet_project
//
//  Created by shang on 2024/4/9 16:54.
//  Copyright © 2024/4/9 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

/// 档案文字展开/收起组件
class NExpandTextVertical extends StatefulWidget {
  NExpandTextVertical({
    super.key,
    required this.text,
    this.textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Color(0xff1A1A1A),
      overflow: TextOverflow.clip,
    ),
    this.expandMinLine = 3,
    this.disableExpand = false,
    this.isExpand = false,
    this.tailing,
    this.tailingWidth = 0,
  });

  final String text;

  final TextStyle? textStyle;
  final int expandMinLine;

  /// 是否禁用折叠, 默认 false
  final bool disableExpand;

  /// 会看来回变化
  late bool isExpand;
  final Widget? tailing;
  final double tailingWidth;

  @override
  NExpandTextVerticalState createState() => NExpandTextVerticalState();
}

class NExpandTextVerticalState extends State<NExpandTextVertical> {
  final weChatTitleColor = Color(0xff1A1A1A);

  @override
  void didUpdateWidget(covariant NExpandTextVertical oldWidget) {
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
    return buildText(
      text: widget.text,
      textStyle: widget.textStyle,
      expandMaxLine: widget.expandMinLine,
      tailing: widget.tailing,
      tailingWidth: widget.tailingWidth,
      disableExpand: widget.disableExpand,
    );
  }

  buildText({
    required String text,
    TextStyle? textStyle,
    int expandMaxLine = 3,
    Widget? tailing,
    double tailingWidth = 0,
    bool disableExpand = false,
  }) {
    // assert(tailing != null && tailingWidth > 0 || tailing == null,
    //     "tailingWidth 应该是tailing的宽度");
    if (disableExpand) {
      return Row(
        children: [
          Expanded(
            child: NText(
              text,
              fontSize: 16,
              maxLines: null,
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.w400,
              color: weChatTitleColor,
              style: textStyle,
            ),
          ),
          tailing ?? const SizedBox(),
        ],
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textPainter = TextPainterExt.getTextPainter(
          text: text,
          textStyle: textStyle,
          maxLine: expandMaxLine,
          maxWidth: (constraints.maxWidth - tailingWidth),
        );
        // final numberOfLines = textPainter.computeLineMetrics().length;
        // debugPrint("numberOfLines:${numberOfLines}");
        var isBeyond = textPainter.didExceedMaxLines;
        // YLog.d([
        //   text.length,
        //   constraints.maxWidth - tailingWidth,
        //   textPainter.height,
        //   textPainter.didExceedMaxLines,
        //   textPainter.computeLineMetrics().length,
        // ].asMap().toString());

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // final btnTitle = isExpand ? "收起" : "展开";

            final arrowImageName = widget.isExpand ? "icon_expand_arrow_up.png" : "icon_expand_arrow_down.png";

            final arrowImage = Image(
              image: arrowImageName.toAssetImage(),
              width: 21,
              height: 8,
              color: context.primaryColor,
            );

            var gradientColor = const Color(0xffFFFFFF);
            // gradientColor = Colors.green;

            onToggle() {
              widget.isExpand = !widget.isExpand;
              setState(() {});
            }

            final textContent = Row(
              children: [
                Expanded(
                  child: NText(
                    text,
                    fontSize: 16,
                    maxLines: widget.isExpand ? null : widget.expandMinLine,
                    // maxLines: null,
                    overflow: TextOverflow.clip,
                    fontWeight: FontWeight.w400,
                    color: weChatTitleColor,
                    style: textStyle,
                  ),
                ),
                tailing ?? const SizedBox(),
              ],
            );
            if (!isBeyond) {
              return textContent;
            }

            if (tailing != null && tailingWidth > 0) {
              return Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      textContent,
                      Offstage(
                        offstage: !widget.isExpand,
                        child: InkWell(
                          onTap: onToggle,
                          child: Container(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            alignment: Alignment.center,
                            child: arrowImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 1,
                    left: 0,
                    right: 0,
                    child: Visibility(
                      visible: !widget.isExpand,
                      child: InkWell(
                        onTap: onToggle,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 34, bottom: 8),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                // Color(0x99FFFFFF),
                                // white,
                                gradientColor.withOpacity(1),
                                gradientColor.withOpacity(0.7),
                                gradientColor.withOpacity(0.01),
                              ].reversed.toList(),
                            ),
                          ),
                          child: arrowImage,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    textContent,
                    Offstage(
                      offstage: !isBeyond,
                      child: InkWell(
                        onTap: onToggle,
                        child: Container(
                          padding: const EdgeInsets.only(top: 11, bottom: 5),
                          alignment: Alignment.center,
                          child: arrowImage,
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 22,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: isBeyond && !widget.isExpand,
                    child: Container(
                      width: double.infinity,
                      height: 25,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x99FFFFFF),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
