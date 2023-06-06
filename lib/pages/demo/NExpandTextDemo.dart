

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/header.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text.dart';
import 'package:flutter_templet_project/basicWidget/n_footer.dart';
import 'package:flutter_templet_project/extension/text_painter_ext.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

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
          onPressed: () => onPressed(e),)
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

  void onPressed(String e) {
    final items = List.generate(3, (i) => "我是可能很长的字符串_$i"*(i+1));
    showTipsSheet(
        items: items,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
        cb: (String val) {
      debugPrint(val);
    });
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

  showTipsSheet({
    required List<String> items,
    TextStyle? textStyle,
    required ValueChanged<String> cb,
  }) {
    final child = Container(
      height: 400,
      // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        // color: Colors.green,
          color: Color(0xffe6e6e6)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (context, int i) {
                  final e = items[i];

                  return InkWell(
                    onTap: (){
                      cb.call(e);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        border: Border.all(color: Color(0xFFe3e3e3), width: 1),
                        // border: Border.all(color: Colors.red, width: 1),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 38,
                      ),
                      alignment: Alignment.centerLeft,
                      child: NExpandText(
                          text: e,
                          textStyle: textStyle,
                          expandTitleStyle: TextStyle(color: Colors.green)
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, int index) {
                  return SizedBox(height: 8,);
                },
              ),
            ),
            NFooter(
              title: "自定义常用语",
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              onPressed: (){
                debugPrint("自定义常用语");
              }
            )
          ],
        ),
      ),
    );
    child.toShowModalBottomSheet(context: context);
  }
}