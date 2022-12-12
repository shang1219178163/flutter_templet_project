import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/widget_extension.dart';

extension ActionSheetExt on BottomSheet{
  ///showModalBottomSheet
  void showModel({
    required BuildContext context,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => this,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
    );
  }


  ///自定义sheet弹窗方法
  static void showModalSheet({
    required BuildContext context,
    required String title,
    String? message,
    required List<String> actionTitles,
    List<Widget>? actionWidgets,
    required void Function(String value) callback}){

    var listView = Container(
      height: 300,
      child: ListView.separated(
        itemCount: actionTitles.length,
        itemBuilder: (context, index) {
          final e = actionTitles[index];
          return ListTile(
            title: Text(e),
            subtitle: null,
            onTap: (){
              callback(e);
              Navigator.pop(context);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFDDDDDD),
          );
        },
      ).addCupertinoScrollbar(),
    );

    var list = actionWidgets ?? [listView];
    list.insertAll(0, [
        // Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600), textAlign: TextAlign.start,),
        Text(message ?? "", textAlign: TextAlign.start,),
      ],
    );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min, // 设置最小的弹出
          children:[
            Container(
              height: 40,
              child: Center(
                child: Row(
                  children: [
                      TextButton(
                        onPressed: (){
                          ddlog("Done");
                        },
                        child: Text("取消", style: TextStyle(color: Colors.black87),)
                      ),
                      Expanded(
                        child: Text(title,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,),
                      ),
                      TextButton(
                        onPressed: (){
                          ddlog("Done");
                        },
                        child: Text("确定", style: TextStyle(color: Colors.black87,)),
                    ),
                  ],
                ),
              ),
          ),
          Divider(),
          listView
        ]);
      },
    );
  }
}

extension CupertinoActionSheetExt on CupertinoActionSheet{
  ///showCupertinoModalPopup
  void toShowCupertinoModalPopup({
    required BuildContext context,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) => showCupertinoModalPopup(
    context: context,
    builder: (context) => this,
    filter: filter,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    semanticsDismissible: semanticsDismissible,
    routeSettings: routeSettings,
  );
}


extension CupertinoDatePickerExt on CupertinoDatePicker{
  ///showCupertinoModalPopup
  void toShowCupertinoModalPopup({
    required BuildContext context,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
  }) => showCupertinoModalPopup(
    context: context,
    builder: (context) => this,
    filter: filter,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    semanticsDismissible: semanticsDismissible,
    routeSettings: routeSettings,
  );
}
