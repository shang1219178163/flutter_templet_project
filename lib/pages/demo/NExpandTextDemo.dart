

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';

class NExpandTextDemo extends StatefulWidget {

  NExpandTextDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NExpandTextDemoState createState() => _NExpandTextDemoState();
}

class _NExpandTextDemoState extends State<NExpandTextDemo> {


  // final text = "稍后与您联系，一会儿把把东西送过去。祝您保持好心情，早日康复。再见。"*3;
  final text = "态度决定一切，有什么态度，就有什么样的未来;性格决定命运，有怎样的性格，就有怎样的人生。";
  final textStyle = TextStyle(overflow: TextOverflow.ellipsis);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildText(
                  text: text,
                  textStyle: textStyle,
                  expandTitleStyle: TextStyle(color: Colors.red)
              ),
              SizedBox(height: 134,),

              Header.h4(title: "字符串不够一行时"),
              Container(
                color: Colors.yellowAccent,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: NExpandText(
                    text: text.substring(0, 20),
                    textStyle: textStyle,
                    expandTitleStyle: TextStyle(color: Colors.green)
                ),
              ),
              Header.h4(title: "字符串超过一行时(折叠)"),
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: NExpandText(
                    text: text,
                    textStyle: textStyle,
                    expandTitleStyle: TextStyle(color: Colors.green)
                ),
              ),
              Header.h4(title: "字符串超过一行时(展开)"),
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: NExpandText(
                    text: text,
                    textStyle: textStyle,
                    expandTitleStyle: TextStyle(color: Colors.green)
                ),
              ),
              // buildBtnColor(),
              // buildSection4(),
              // buildSection5(),
              SizedBox(height: 34,),
            ],
          ),
        )
    );
  }

  void _onPressed(int e) {

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
                          // width: maxWidth,
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
                        minimumSize: Size(50, 30),
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