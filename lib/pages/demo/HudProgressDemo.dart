//
//  HudProgressDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/10/21 4:27 PM.
//  Copyright © 6/10/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_templet_project/basicWidget/hud/ToastDialog.dart';
import 'package:flutter_templet_project/basicWidget/hud/CirclePulseLoadingWidget.dart';

class HudProgressDemo extends StatelessWidget {

  var titles = List.generate(10, (index) => "item$index");

  final String? title;

  HudProgressDemo({
  	Key? key,
  	this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? "$this"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                print("更多");
                showToast(context);
              },
            ),
          ],
        ),
        body: buildGridView(context: context, list: titles),
      // body: Center(
        //   child: CirclePulseLoadingWidget(),
        // )
    );
  }

  Widget buildGridView({required BuildContext context, required List<String> list}) {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      //一行多少个
      crossAxisCount: 4,
      //滚动方向
      scrollDirection: Axis.vertical,
      // 左右间隔
      crossAxisSpacing: 8,
      // 上下间隔
      mainAxisSpacing: 8,
      //宽高比
      childAspectRatio: 3 / 4,
      children: list.map((e) => GridTile(
          child: Container(
            child: Center(
              child: Text("$e"),
            )
        )
            .decorated(color: Theme.of(context).primaryColor)
              // .gestures( onTap: () => ddlog(e)
            .gestures(onTap: (){
              ddlog(e);
              // showToast(context);
            _onPressed(context: context, e: e);
            }
          )
      )).toList()
    );
  }

  void _onPressed({required BuildContext context, required String e}) {
    ddlog(e);
    switch (titles.indexOf(e)) {
      case 1:
        {
          ToastDialog.show(
            context: context,
            loadingView: CirclePulseLoadingWidget(itemColor: Colors.white,),
            message: "经查，涉事两名攻击者非法获取某互联网公司客户信息共计 11.8 亿条，在 8 个月的时间里利用该信息经营共获利 34 万余元。"
                "最终，二人因侵犯公民个人信息罪，分别被判处有期徒刑三年六个月，有期徒刑三年三个月。",
            messageMargin: EdgeInsets.only(left: 40, right: 40),
          );
        }
        break;

      case 2:
        {
          ToastDialog.show(
            context: context,
            loadingView: CirclePulseLoadingWidget(itemColor: Colors.white,),
            // message: "经查，涉事两名攻击者非法获取某互联网公司客户信息共计 11.8 亿条，在 8 个月的时间里利用该信息经营共获利 34 万余元。"
            //     "最终，二人因侵犯公民个人信息罪，分别被判处有期徒刑三年六个月，有期徒刑三年三个月。",
            // messageMargin: EdgeInsets.only(left: 40, right: 40),
          );
        }
        break;

      case 3:
        {
          ToastDialog.show(
            context: context,
            // loadingView: CirclePulseLoadingWidget(itemColor: Colors.white,),
            message: "经查，涉事两名攻击者非法获取某互联网公司客户信息共计 11.8 亿条，在 8 个月的时间里利用该信息经营共获利 34 万余元。"
                "最终，二人因侵犯公民个人信息罪，分别被判处有期徒刑三年六个月，有期徒刑三年三个月。",
            messageMargin: EdgeInsets.only(left: 40, right: 40),
          );
        }
        break;

      case 4:
        {

        }
        break;

      case 5:
        {

        }
        break;

      case 6:
        {

        }
        break;

      case 7:
        {

        }
        break;

      case 8:
        {

        }
        break;

      default:
        break;
    }

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }

  void showToast(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode()); //收起键盘

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     barrierColor: Colors.transparent,
    //     builder: (BuildContext context) {
    //       // return CirclePulseLoadingWidget();
    //       return Center(
    //           child: Container(
    //             height: 120,
    //             width: 120,
    //             // color: Colors.black,
    //             decoration: ShapeDecoration(
    //               color: Colors.black.withAlpha(70),
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(8),
    //                 ),
    //               ),
    //             ),
    //             child: CirclePulseLoadingWidget(itemColor: Colors.white,),
    //           )
    //       );
    //     });

    final message = "经查，涉事两名攻击者非法获取某互联网公司客户信息共计 11.8 亿条，在 8 个月的时间里利用该信息经营共获利 34 万余元。"
        "最终，二人因侵犯公民个人信息罪，分别被判处有期徒刑三年六个月，有期徒刑三年三个月。";


    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return ToastDialog(
            // message: message,
            messageMargin: EdgeInsets.only(left: 50, right: 50),
            // loadingView: CirclePulseLoadingWidget(itemColor: Colors.white,),
          );
        });

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }
}
