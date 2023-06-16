//
//  BottomSheetExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/1/14 14:46.
//  Copyright © 2023/1/14 shang. All rights reserved.
//


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';


extension BottomSheetExt on BottomSheet{

  ///自定义sheet弹窗方法
  static presentSheet({
    required BuildContext context,
    String title = "请选择",
    double maxHeight = 400,
    required Widget content,
    required VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }){
    final scrollController = ScrollController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {

        return Material(
          child: Column(
            children: [
              buildTitleBar(
                context: context,
                title: title,
                onCancel: onCancel,
                onConfirm: onConfirm,
              ),
              Expanded(
                child: CupertinoScrollbar(
                  controller: scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: maxHeight,
                      minHeight: 100,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: content,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static  Widget buildTitleBar({
    required BuildContext context,
    String title = "请选择",
    required VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }){
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe4e4e4))),
      ),
      child: NavigationToolbar(
        leading: TextButton(
          onPressed: onCancel ?? (){
            debugPrint("取消");
          },
          child: Text("取消",
            style: TextStyle(
              color: context.primaryColor
            ),
          )
        ),
        middle: Text(title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        trailing: TextButton(
          onPressed: onConfirm ?? (){
            debugPrint("确定");
          },
          child: Text("确定",
            style: TextStyle(
              color: context.primaryColor
            ),
          )
        ),
      ),
    );
  }
}
