import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/dash_line.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';
import 'package:flutter_templet_project/extensions/buildContext_extension.dart';

import 'package:styled_widget/styled_widget.dart';

final kUpdateContent = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
5、新增加了分类查看功能;
""";

class SnackBarDemo extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => SnackBarDemoState();
}

class SnackBarDemoState extends State<SnackBarDemo> {

  GlobalKey globalKey = GlobalKey();

  final _globalKey = GlobalKey<ScaffoldMessengerState>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SnackBar'),
        ),
        body: Builder(builder: (BuildContext context) {
          return RepaintBoundary(
            key: globalKey,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2),
                    GestureDetector(
                      onTap: () {
                        final snackBar = buildSnackBar(context);
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        showSnackBar(buildSnackBar(context));
                      },
                      child: Text('显示SnackBar, 不覆盖'),
                    ),
                    Spacer(),

                    DashLine(color: Colors.red,),
                    Spacer(),

                    GestureDetector(
                      onTap: () {
                        // ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(context));
                        showSnackBar(buildSnackBar(context), true);
                      },
                      child: Text('显示SnackBar, 覆盖'),
                    ),
                    Spacer(),

                    GestureDetector(
                      onTap: () {
                        // ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(context));
                        showSnackBar(buildSnackBar2(context), true);
                      },
                      child: Text('显示SnackBar, 覆盖'),
                    ),
                    Spacer(flex: 2),

                  ],
                ),
              )
            ),
          );
        })
    );
  }


  // SnackBar buildFlushbar(BuildContext context) {
  //   return Flushbar(
  //     flushbarPosition: FlushbarPosition.TOP,
  //     message:
  //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  //     duration: Duration(seconds: 3),
  //   )..show(context);
  // }

  SnackBar buildSnackBar(BuildContext context) {
    return SnackBar(
      content: Container(
        // color: Colors.yellow,
        // decoration: BoxDecoration(color: Colors.red,
        //     border: Border.all(width: 2.0, color: Colors.black),
        //     borderRadius: BorderRadius.circular(20)),
        // margin: EdgeInsets.fromLTRB(0, 0, 0, 175),
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        child: Text(kUpdateContent)
            // .padding(all: 8)
            // .backgroundColor(Colors.yellow)
      ,
      ).gestures(onTap: (){
        ddlog(kUpdateContent);
      }),

      padding: EdgeInsets.only(left: 13, right: 13),
      // backgroundColor: Colors.green,
      elevation: 1000,
      behavior: SnackBarBehavior.fixed,
    );
  }

  SnackBar buildSnackBar2(BuildContext context) {
    return SnackBar(
      onVisible: () {
        print("显示SnackBar");
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.orange,
      content: Text('断网了？'),
      action: SnackBarAction(
        ///配置action的字体颜色为绿色
        textColor: Colors.green,
        label: '点击重试',
        onPressed: () {
          //执行相关逻辑
        },
      ),
    );
  }

}
