import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

// Header.h4(title: "字符串超过一行时(折叠)"),
// Container(
//   color: Colors.yellow,
//   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//   child: NExpandText(
//     text: text,
//     textStyle: textStyle,
//     expandTitleStyle: TextStyle(color: Colors.green)
//   ),
// ),

///如果文字超过一行,右边有展开收起按钮
class NExpandText extends StatefulWidget {
  NExpandText({
    Key? key,
    required this.text,
    required this.textStyle,
    this.expandMaxLine = 10,
    this.expandTitleStyle,
    this.initiallyExpanded = false,
  }) : super(key: key);

  /// 字符串
  final String text;

  /// 字符串样式
  final TextStyle? textStyle;

  /// 超过一行初始展开状态
  final bool initiallyExpanded;

  /// 展开状态最大行
  final int expandMaxLine;

  /// 展开按钮文字样式
  final TextStyle? expandTitleStyle;

  @override
  _NExpandTextState createState() => _NExpandTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(DiagnosticsProperty<bool>('initiallyExpanded', initiallyExpanded));
    properties.add(IntProperty('expandMaxLine', expandMaxLine));
    properties.add(DiagnosticsProperty<TextStyle?>('expandTitleStyle', expandTitleStyle));
  }
}

class _NExpandTextState extends State<NExpandText> {
  @override
  Widget build(BuildContext context) {
    var isExpand = widget.initiallyExpanded;
    final text = widget.text;
    final textStyle = widget.textStyle;
    final expandMaxLine = widget.expandMaxLine;
    final expandTitleStyle = widget.expandTitleStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainterExt.getTextPainter(
          text: text,
          textStyle: textStyle,
          maxLine: 100,
          maxWidth: constraints.maxWidth,
        );
        final numberOfLines = textPainter.computeLineMetrics().length;
        // debugPrint("numberOfLines:${numberOfLines}");

        return StatefulBuilder(
          builder: (context, setState) {
            final btnTitle = isExpand ? "收起" : "展开";
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(19))),
                    child: Container(
                      // color: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        text,
                        style: textStyle,
                        maxLines: isExpand ? expandMaxLine : 1,
                      ),
                    ),
                  ),
                ),
                if (numberOfLines > 1)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(50, 18),
                      ),
                      onPressed: () {
                        isExpand = !isExpand;
                        setState(() {});
                      },
                      child: Text(
                        btnTitle,
                        style: expandTitleStyle,
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
