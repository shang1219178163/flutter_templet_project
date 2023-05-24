

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/snack_bar_state_ext.dart';
import 'package:w_popup_menu/w_popup_menu.dart';

class WPopupMenuDemo extends StatefulWidget {

  WPopupMenuDemo({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _WPopupMenuDemoState createState() => _WPopupMenuDemoState();
}

class _WPopupMenuDemoState extends State<WPopupMenuDemo> {

  final List<String> actions = [
    '复制',
    '转发',
    // '收藏',
    // '删除',
    // '多选',
    // '提醒',
    // '翻译',
  ];

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
        body: Stack(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: 40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: WPopupMenu(
                      onValueChanged: (int value) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(actions[value]),
                          duration: Duration(milliseconds: 500),
                        ));
                      },
                      pressType: PressType.longPress,
                      actions: actions,
                      menuWidth: 135,
                      menuHeight: 35,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      child: UnconstrainedBox(
                        child: Container(
                          height: 40,
                          color: Colors.cyan,
                          alignment: Alignment.center,
                          child: Text(
                            '我是Title $index',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            // TextField()
          ],
        ));
//    );
  }
}