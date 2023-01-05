//
//  alertDialog_extension.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 3:57 PM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';


extension AlertDialogExt on AlertDialog{

  // ///showDialog
  // toShowDialog({
  //   required BuildContext context,
  //   bool barrierDismissible = true,
  //   Color? barrierColor = Colors.black54,
  //   String? barrierLabel,
  //   bool useSafeArea = true,
  //   bool useRootNavigator = true,
  //   RouteSettings? routeSettings,
  // }) => showDialog(
  //   context: context,
  //   builder: (context) => this,
  //   barrierColor: barrierColor,
  //   barrierDismissible: barrierDismissible,
  //   barrierLabel: barrierLabel,
  //   useSafeArea: useSafeArea,
  //   routeSettings: routeSettings,
  // );

  ///按平台弹出不同样式
  static void toShowAlert({
    required BuildContext context,
    Widget? title,
    Widget? content,
    required List<String> actionTitles,
    required void Function(String value) callback}) {

    switch(Platform.operatingSystem) {
      case "android":
        AlertDialog(
          title: title,
          content: content,
          actions: actionTitles.map((e) => TextButton(onPressed: (){
            callback(e);
          }, child: Text(e),)).toList()
          ,
        ).toShowDialog(context: context);

        break;
      default:

        CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actionTitles.map((e) => TextButton(
            onPressed: (){
              callback(e);
            },
            child: Text(e),)).toList(),
        ).toShowDialog(context: context);
        break;
    }
  }
}

extension CupertinoAlertDialogExt on CupertinoAlertDialog{

  // ///showDialog
  // toShowDialog({
  //   required BuildContext context,
  //   bool barrierDismissible = true,
  //   Color? barrierColor = Colors.black54,
  //   String? barrierLabel,
  //   bool useSafeArea = true,
  //   bool useRootNavigator = true,
  //   RouteSettings? routeSettings,
  // }) => showDialog(
  //     context: context,
  //     barrierDismissible: barrierDismissible,
  //     barrierColor: barrierColor,
  //     barrierLabel: barrierLabel,
  //     useRootNavigator: useRootNavigator,
  //     routeSettings: routeSettings,
  //     builder: (BuildContext context) {
  //       return this;
  //     },
  //   );
  }


