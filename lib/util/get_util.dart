import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

/// 自定义路由函数封装
extension GetRouteUtil on GetInterface {
  /// 堆栈路由跳转
  /// pageRoute 路由
  /// onBefore 跳转前回调函数
  /// onUntil 堆栈中查询到路由时回调方法, 为空执行 Get.until
  /// onJump 堆栈中没查询到路由时回调方法, 为空执行 Get.offNamed
  /// 返回值 是否在堆栈中查询到路由
  bool jump(
    String pageRoute, {
    dynamic arguments,
    VoidCallback? onBefore,
    VoidCallback? onJump,
    VoidCallback? onUntil,
  }) {
    final routes = Get.routeTree.routes.reversed;
    for (final route in routes) {
      if (route.name == pageRoute) {
        onBefore?.call();
        if (onUntil != null) {
          onUntil.call();
        } else {
          Get.until((route) => route.settings.name == pageRoute);
        }
        return true;
      }
    }

    onBefore?.call();
    if (onJump != null) {
      onJump.call();
    } else {
      Get.offNamed(pageRoute, arguments: arguments);
    }
    return false;
  }

  /// 当前路由堆栈是否包含此路由
  bool hasRoute(String routeName) {
    final routes = Get.routeTree.routes.reversed;
    for (final route in routes) {
      if (route.name == routeName) {
        return true;
      }
    }
    return false;
  }
}

class GetSheet {
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
    assert(actions.isNotEmpty && !actions.map((e) => e.item1).contains(-1),
        "取消是 -1");
    if (actions.isEmpty) {
      return;
    }

    showBottomSheet(
      child: Column(
        children: [
          ...actions
              .map((e) => sheetActionCell(
                    content: e.item2,
                    tag: e.item1,
                    onItem: onItem,
                    hasDivider: actions.indexOf(e) != 0,
                  ))
              .toList(),
          Container(height: 8.h, color: bgColor),
          sheetActionCell(
            content: NText(
              '取消',
            ),
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
        if (hasDivider)
          const Divider(
            height: 1,
          ),
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

  /// 输入框弹窗
  static void showInput({
    required TextEditingController controller,
    String title = "编辑原因",
    int lengthLimit = 200,
    EdgeInsets textFieldPadding = const EdgeInsets.only(
      top: 20,
      left: 15,
      right: 15,
      bottom: 12,
    ),
    VoidCallback? onCancel,
    required VoidCallback? onConfirm,
  }) {
    final context = Get.context;
    final primary = context?.primaryColor ?? Colors.transparent;

    showBottomSheet(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 13,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Container(
              padding: textFieldPadding,
              constraints: const BoxConstraints(minHeight: 82),
              child: Column(
                children: [
                  NTextField(
                    controller: controller,
                    hintText: '请输入...',
                    hintStyle: TextStyle(fontSize: 14, color: fontColor),
                    minLines: 5,
                    maxLines: 10,
                    autofocus: true,
                    fillColor: Colors.white,
                    radius: 8,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(lengthLimit),
                    ],
                    onChanged: (String value) {},
                    onSubmitted: (String value) {},
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onCancel ?? () => Get.back(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.08),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        height: 44,
                        alignment: Alignment.center,
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onConfirm,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          gradient: LinearGradient(
                            colors: [primary, primary],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 5),
                              blurRadius: 10,
                              color: Color(0x52007DBF),
                            )
                          ],
                        ),
                        height: 44,
                        alignment: Alignment.center,
                        child: const Text(
                          '提交',
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: max(
                  context == null ? 0 : MediaQuery.of(context).padding.bottom,
                  12),
            ),
            // const SizedBox(
            //   height: 12,
            // ),
          ],
        ),
      ),
    );
  }
}

class GetDialog {
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
    assert(actions.isNotEmpty && !actions.map((e) => e.item1).contains(-1),
        "取消是 -1");
    if (actions.isEmpty) {
      return;
    }

    showBottomSheet(
      child: Column(
        children: [
          ...actions
              .map((e) => sheetActionCell(
                    content: e.item2,
                    tag: e.item1,
                    onItem: onItem,
                    hasDivider: actions.indexOf(e) != 0,
                  ))
              .toList(),
          Container(height: 8.h, color: bgColor),
          sheetActionCell(
            content: NText(
              '取消',
            ),
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
        if (hasDivider)
          const Divider(
            height: 1,
          ),
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
