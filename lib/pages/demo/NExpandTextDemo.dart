import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text.dart';
import 'package:flutter_templet_project/basicWidget/n_expand_text_vertical.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';

class NExpandTextDemo extends StatefulWidget {
  NExpandTextDemo({Key? key, this.title}) : super(key: key);

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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => onPressed(e),
                  ))
              .toList(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 14,
              ),
              NSectionBox(
                title: "字符串不够一行时",
                child: Container(
                  color: Colors.yellowAccent,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: NExpandText(
                      text: text.substring(0, 20),
                      textStyle: textStyle,
                      expandTitleStyle: TextStyle(color: Colors.green)),
                ),
              ),
              NSectionBox(
                title: "字符串超过一行时(折叠)",
                child: Container(
                  color: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: NExpandText(
                      text: text,
                      textStyle: textStyle,
                      expandTitleStyle: TextStyle(color: Colors.green)),
                ),
              ),
              NSectionBox(
                title: "字符串超过一行时(展开)",
                child: Container(
                  color: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: NExpandText(
                      text: text,
                      textStyle: textStyle,
                      expandTitleStyle: TextStyle(color: Colors.green)),
                ),
              ),
              NSectionBox(
                title: "NExpandTextVertical",
                child: NExpandTextVertical(
                  text: text * 2,
                  isExpand: false,
                  expandMinLine: 3,
                ),
              ),
              NSectionBox(
                title: "NExpandTextVertical",
                child: NExpandTextVertical(
                  text: text * 2,
                  isExpand: false,
                  expandMinLine: 3,
                  tailingWidth: 100,
                  tailing: Container(
                    width: 100,
                    height: 20,
                    color: Colors.green,
                  ),
                ),
              ),
              // buildBtnColor(),
              // buildSection4(),
              // buildSection5(),
              SizedBox(
                height: 34,
              ),
            ],
          ),
        ));
  }

  void onPressed(String e) {
    final items = List.generate(3, (i) => "我是可能很长的字符串_$i" * (i + 1));
    showTipsSheet(
        items: items,
        textStyle: TextStyle(overflow: TextOverflow.ellipsis),
        cb: (String val) {
          debugPrint(val);
        });
  }

  showTipsSheet({
    required List<String> items,
    TextStyle? textStyle,
    required ValueChanged<String> cb,
  }) {
    final child = Container(
      height: 400,
      padding: EdgeInsets.only(top: 16, bottom: 0),
      decoration: BoxDecoration(
        // color: Colors.green,
        color: Color(0xffe6e6e6),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, int i) {
                final e = items[i];

                return InkWell(
                  onTap: () {
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
                        expandTitleStyle: TextStyle(color: Colors.green)),
                  ),
                );
              },
              separatorBuilder: (context, int index) {
                return SizedBox(
                  height: 8,
                );
              },
            ),
          ),
          NFooterButtonBar(
            confirmTitle: "自定义常用语",
            onConfirm: () {
              debugPrint("自定义常用语");
            },
            hideCancel: true,
          ),
          // NFooter(
          //   title: "自定义常用语",
          //   padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          //   onPressed: (){
          //     debugPrint("自定义常用语");
          //   }
          // ),
        ],
      ),
    );
    child.toShowModalBottomSheet(context: context);
  }
}
