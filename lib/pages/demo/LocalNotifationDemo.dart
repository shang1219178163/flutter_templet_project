// //
// //  LocalNotifationDemo.dart
// //  flutter_templet_project
// //
// //  Created by shang on 5/19/21 2:23 PM.
// //  Copyright © 5/19/21 shang. All rights reserved.
// //
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
//
// class LocalNotifationDemo extends StatefulWidget {
//
//   final String? title;
//
//   LocalNotifationDemo({ Key? key, this.title}) : super(key: key);
//
//
//   @override
//   _LocalNotifationDemoState createState() => _LocalNotifationDemoState();
// }
//
// class _LocalNotifationDemoState extends State<LocalNotifationDemo> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   var titles = ["0", "1", "2",
//     "3", "4", "5", "6", "7", "8"];
//
//   @override
//   void initState() {
//     super.initState();
//
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = IOSInitializationSettings();
//     var initSetttings = InitializationSettings(android: android, iOS: iOS);
//     flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
//   }
//
//   ///点击本地通知
//   Future onSelectNotification(String? payload) async {
//     debugPrint("payload : $payload");
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text('Notification'),
//         content: Text('$payload'),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dynamic arguments = ModalRoute.of(context)!.settings.arguments;
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title ?? "$widget"),
//         ),
//         body: buildGridView(titles)
//     );
//   }
//
//   Widget buildGridView(List<String> list) {
//     return GridView.count(
//       padding: EdgeInsets.all(15.0),
//       //一行多少个
//       crossAxisCount: 3,
//       //滚动方向
//       scrollDirection: Axis.vertical,
//       // 左右间隔
//       crossAxisSpacing: 8,
//       // 上下间隔
//       mainAxisSpacing: 8,
//       //宽高比
//       childAspectRatio: 1 / 0.3,
//
//       children: initListWidget(list),
//     );
//   }
//
//   List<Widget> initListWidget(List<String> list) {
//     List<Widget> lists = [];
//     for (var e in list) {
//       lists.add(
//         Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("${e}", style: TextStyle(fontSize: 12),),
//             ],
//           ),
//         )
//         }),
//       );
//     }
//     return lists;
//   }
//
//   void _onPressed(int e) {
//     DLog.d(e);
//
//     showNotification();
//   }
//
//   ///展示本地通知
//   void showNotification() async {
//     var android = AndroidNotificationDetails(
//         'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
//         priority: Priority.high, importance: Importance.max
//     );
//     var iOS = IOSNotificationDetails();
//     var platform = NotificationDetails(android: android, iOS: iOS);
//     await flutterLocalNotificationsPlugin.show(0,
//         'Video is out',
//         'Flutter Local Notification',
//         platform,
//         payload: 'Nitish Kumar Singh is part time Youtuber');
//   }
// }
//
// // extension on FlutterLocalNotificationsPlugin{
// //   Future<bool?> initialize(
// //       InitializationSettings initializationSettings, {
// //         required Future<dynamic> Function(String? payload) block,
// //       }) async {
// //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// //     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
// //     var iOS = IOSInitializationSettings();
// //     var initSetttings = InitializationSettings(android: android, iOS: iOS);
// //     return flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: _onSelectNotification);
// //   }
// //
// //   Future _onSelectNotification(String? payload) async {
// //
// //   }
// // }
// //
// //
// // class FlutterLocalNotificationsPluginTarget{
// //
// //
// // }

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class LocalNotifationDemo extends StatefulWidget {
  final String? title;

  const LocalNotifationDemo({Key? key, this.title}) : super(key: key);

  @override
  _LocalNotifationDemoState createState() => _LocalNotifationDemoState();
}

class _LocalNotifationDemoState extends State<LocalNotifationDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Text('11111'));
  }
}
