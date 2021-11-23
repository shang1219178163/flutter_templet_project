//
//  alertDialog_extension.dart
//  fluttertemplet
//
//  Created by shang on 5/17/21 3:57 PM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


extension AlertDialogExt on AlertDialog{

  ///showDialog
  void toShowCupertinoDialog({
    required BuildContext context,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) => showDialog(
    context: context,
    builder: (context) => this,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
  );

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
        )
        .toShowCupertinoDialog(context: context);

        break;
      default:

        CupertinoAlertDialog(
          title: title,
          content: content,
          actions: actionTitles.map((e) => TextButton(onPressed: (){
            callback(e);
          }, child: Text(e),)).toList()
          ,
        )
            .toShowCupertinoDialog(context: context);
        break;
    }
  }
}

extension CupertinoAlertDialogExt on CupertinoAlertDialog{

  ///showDialog
  void toShowCupertinoDialog({required BuildContext context}){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return this;
      },
    );
  }
}

