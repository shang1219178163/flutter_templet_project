//
//  LocationPopView.dart
//  flutter_templet_project
//
//  Created by shang on 7/29/21 9:26 AM.
//  Copyright © 7/29/21 shang. All rights reserved.
//


import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/button_extension.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';

import 'package:flutter_templet_project/extension/color_extension.dart';


class LocationPopView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter高级进阶')),
      body: buildListView(context),
    );
  }

  Widget buildListView(context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Align(
        alignment: Alignment.centerRight,
        child: PopupMenuButtonExt.fromEntryFromJson(
            json: {"aa": "0",
              "bb": "1",
              "cc": "2"},
            checkedString: "aa",
            child: Icon(Icons.security, color: ColorExt.random,),
            offset: Offset(0, 30),
            callback: (value) {
              ddlog(value);
            }
        ),
      );
    });
  }
}

// class PopRoute extends PopupRoute {
//   // push的耗时，milliseconds为毫秒
//   final Duration _duration = Duration(milliseconds: 300);
//
//   // 接收一个child，也就是我们push的内容。
//   Widget child;
//
//   // 构造方法
//   PopRoute({required this.child});
//
//   @override
//   Color? get barrierColor => null;
//
//   @override
//   bool get barrierDismissible => true;
//
//   @override
//   String? get barrierLabel => null;
//
//   @override
//   Widget buildPage(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation) {
//     return child;
//   }
//
//   @override
//   Duration get transitionDuration => _duration;
// }
//
// // 类型声明回调
// typedef OnItem = Function(String value);
//
// class Popup extends StatefulWidget {
//   final BuildContext btnContext;
//   final OnItem onClick; //点击child事件
//
//   Popup({required this.btnContext, required this.onClick});
//
//   PopupState createState() => PopupState();
// }
//
// class PopupState extends State<Popup> {
//   // 声明对象
//   late RenderBox button;
//   late RenderBox overlay;
//   late RelativeRect position;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // 找到并渲染对象button
//     button = widget.btnContext.findRenderObject() as RenderBox;
//     // 找到并渲染对象overlay
//     overlay = Overlay.of(widget.btnContext)!.context.findRenderObject() as RenderBox;
//     // 位置设置
//     position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//       ),
//       Offset.zero & overlay.size,
//     );
//   }
//
//   // item构建
//   Widget itemBuild(item) {
//     // 字体样式
//     TextStyle labelStyle = TextStyle(color: Colors.white);
//
//     return Expanded(
//       child: FlatButton(
//         //点击Item
//         onPressed: () {
//           // 如果没接收也返回的花就会报错，所以这里需要判断
//           if (widget.onClick != null) {
//             Navigator.of(context).pop();
//             widget.onClick(item); // 事件返回String类型的值
//           }
//         },
//         child: Text(item, style: labelStyle),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = Size(200, 36);
//
//     return Material(
//       type: MaterialType.transparency, // Material类型设置
//       child: GestureDetector(
//         child: Stack(
//           children: <Widget>[
//             Container(
//               // 设置一个容器组件，是整屏幕的。
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               color: Colors.transparent, // 它的颜色为透明色
//             ),
//             Positioned(
//               child: Container(
//                 width: size.width,
//                 height: size.height,
//                 decoration: BoxDecoration(
//                   color: Color.fromRGBO(75, 75, 75, 1.0),
//                   borderRadius: BorderRadius.all(Radius.circular(4.0)), // 圆角
//                 ),
//                 child: Row(
//                     children: ['点赞', '评论'].map(itemBuild).toList()),
//               ),
//               top: position.top, // 顶部位置
//               right: position.right, // 右边位置x
//               // top: (MediaQuery.of(context).size.height - size.height) /2, // 顶部位置
//               // right: (MediaQuery.of(context).size.width - size.width) /2, // 右边位
//             )
//           ],
//         ),
//         onTap: () => Navigator.of(context).pop(), //点击空白处直接返回
//       ),
//     );
//   }
// }
