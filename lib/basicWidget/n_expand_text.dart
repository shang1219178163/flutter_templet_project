

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';

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


  String text;

  TextStyle textStyle;

  bool initiallyExpanded;

  int expandMaxLine;

  TextStyle? expandTitleStyle;

  @override
  _NExpandTextState createState() => _NExpandTextState();
}

class _NExpandTextState extends State<NExpandText> {


  @override
  Widget build(BuildContext context) {

    return buildText(
      text: widget.text,
      textStyle: widget.textStyle,
      isExpand: widget.initiallyExpanded,
      expandMaxLine: widget.expandMaxLine,
      expandTitleStyle: widget.expandTitleStyle,
    );
  }

  buildText({
    required String text,
    required TextStyle textStyle,
    bool isExpand = false,
    int expandMaxLine = 10,
    TextStyle? expandTitleStyle,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){

        final textPainter = TextPainterExt.getTextPainter(
          text: text,
          textStyle: textStyle,
          maxLine: 100,
          maxWidth: constraints.maxWidth,
        );
        final numberOfLines = textPainter.computeLineMetrics().length;
        // debugPrint("numberOfLines:${numberOfLines}");

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {

            final btnTitle = isExpand ? "收起" : "展开";
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(19))
                    ),
                    child: Container(
                      // color: Colors.green,
                      child: Text(text,
                        style: textStyle,
                        maxLines: isExpand ? expandMaxLine : 1,
                      ),
                    ),
                  ),
                ),
                if(numberOfLines > 1) TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size(50, 18),
                  ),
                  onPressed: (){
                    isExpand = !isExpand;
                    setState((){});
                  },
                  child: Text(btnTitle, style: expandTitleStyle,),
                ),
              ],
            );
          }
        );
      }
    );

  }
}