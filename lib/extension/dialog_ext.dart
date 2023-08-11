//
//  dialog_ext.dart
//  flutter_templet_project
//
//  Created by shang on 5/17/21 3:57 PM.
//  Copyright © 5/17/21 shang. All rights reserved.
//


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';


extension AlertDialogExt on AlertDialog{
  //
  // ///按平台弹出不同样式
  // static void toShowAlert({
  //   required BuildContext context,
  //   Widget? title,
  //   Widget? content,
  //   required List<String> actionTitles,
  //   required void Function(String value) callback}) {
  //
  //   switch(Platform.operatingSystem) {
  //     case "android":
  //       AlertDialog(
  //         title: title,
  //         content: content,
  //         actions: actionTitles.map((e) => TextButton(onPressed: (){
  //           callback(e);
  //         }, child: Text(e),)).toList()
  //         ,
  //       ).toShowDialog(context: context);
  //
  //       break;
  //     default:
  //
  //       CupertinoAlertDialog(
  //         title: title,
  //         content: content,
  //         actions: actionTitles.map((e) => TextButton(
  //           onPressed: (){
  //             callback(e);
  //           },
  //           child: Text(e),)).toList(),
  //       ).toShowDialog(context: context);
  //       break;
  //   }
  // }
}

