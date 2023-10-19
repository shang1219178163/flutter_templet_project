

import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/uti/color_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';


class GetSheet{

  /// 弹框 - 自定义child
  static void showBottomSheet({
    Widget? child,
  }) {
    Get.bottomSheet(
      UnconstrainedBox(
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          child: child,
        ),
      ),
      enableDrag: false,
    );
  }

  /// 底部展示菜单
  static void showSheetActions({
    required List<Tuple2<int, Widget>> actions,
    required ValueChanged<int> onItem,
  }) {
    assert(actions.isNotEmpty && !actions.map((e) => e.item1).contains(-1), "取消是 -1");
    if (actions.isEmpty) {
      return;
    }

    showBottomSheet(
      child: Column(
        children: [
          ...actions.map((e) => sheetActionCell(
            content: e.item2,
            tag: e.item1,
            onItem: onItem,
            hasDivider: actions.indexOf(e) != 0,
          )).toList(),
          Container(height: 8.h, color: bgColor),
          sheetActionCell(
            content: NText('取消',),
            tag: -1,
            onItem: onItem,
          ),
          SizedBox(height: Platform.isIOS ? 34.h : 8.h),
        ],
      ),
    );
  }

  /// 展示菜单子项
  /// hasDivider 是否显示分割线
  /// content 子组件
  /// content 对应的 tag
  /// onItem 点击回调
  static Widget sheetActionCell({
    bool hasDivider = true,
    required Widget content,
    required int tag,
    required ValueChanged<int> onItem,
  }) {
    return Column(
      children: [
        if (hasDivider) const Divider(height: 1,),
        InkWell(
          onTap: () {
            Get.back();
            onItem(tag);
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            // color: ColorExt.random,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: content,
          ),
        ),
      ],
    );
  }

}

class GetDialog{

  /// 弹框 - 自定义child
  static void showBottomSheet({
    Widget? child,
  }) {
    Get.bottomSheet(
      UnconstrainedBox(
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: ScreenUtil().screenWidth,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
          ),
          child: child,
        ),
      ),
      enableDrag: false,
    );
  }

  /// 底部展示菜单
  static void showSheetActions({
    required List<Tuple2<int, Widget>> actions,
    required ValueChanged<int> onItem,
  }) {
    assert(actions.isNotEmpty && !actions.map((e) => e.item1).contains(-1), "取消是 -1");
    if (actions.isEmpty) {
      return;
    }

    showBottomSheet(
      child: Column(
        children: [
          ...actions.map((e) => sheetActionCell(
            content: e.item2,
            tag: e.item1,
            onItem: onItem,
            hasDivider: actions.indexOf(e) != 0,
          )).toList(),
          Container(height: 8.h, color: bgColor),
          sheetActionCell(
            content: NText('取消',),
            tag: -1,
            onItem: onItem,
          ),
          SizedBox(height: Platform.isIOS ? 34.h : 8.h),
        ],
      ),
    );
  }

  /// 展示菜单子项
  /// hasDivider 是否显示分割线
  /// content 子组件
  /// content 对应的 tag
  /// onItem 点击回调
  static Widget sheetActionCell({
    bool hasDivider = true,
    required Widget content,
    required int tag,
    required ValueChanged<int> onItem,
  }) {
    return Column(
      children: [
        if (hasDivider) const Divider(height: 1,),
        InkWell(
          onTap: () {
            Get.back();
            onItem(tag);
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            // color: ColorExt.random,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: content,
          ),
        ),
      ],
    );
  }

}